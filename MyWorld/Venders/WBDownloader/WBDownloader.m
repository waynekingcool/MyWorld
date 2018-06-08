//
//  WBDownloader.m
//  MyWorld
//
//  Created by wayneking on 2018/6/2.
//  Copyright © 2018年 wayneking. All rights reserved.
//

#import "WBDownloader.h"
#import <AFNetworking/AFNetworking.h>
#import "WBDownloadResponseSerializer.h"
#import <CommonCrypto/CommonDigest.h>

NSString *const WBDownloaderNoDiskSpaceNotification = @"WBDownloaderNoDiskSpaceNotification";

NSString *const WBDownloaderDownloadArrayObserveKeyPath = @"downloadMutableArray";
NSString *const WBDownloaderCompleteArrayObserveKeyPath = @"completeMutableArray";

static NSString *WBDownloadProgressUserInfoStartTimeKey = @"WBDownloadProgressUserInfoStartTime";
static NSString *WBDownloadProgressUserInfoStartOffsetKey = @"WBDownloadProgressUserInfoStartOffsetKey";

//下载路径
@interface WBDownloader(DownloadPath)

- (void)createPath;
- (void)saveResumeData:(NSData *)resumeData forItem:(id<WBDownloadItem>)item;
- (NSData *)resumenDataForItem:(id<WBDownloadItem>)item;

@end

@interface WBDownloader(DownloadNotify)

- (void)notifyDownloadItem:(id<WBDownloadItem>)item withDownloadProgress:(double)downloadProgress;
- (void)notifyDownloadItem:(id<WBDownloadItem>)item withDownloadState:(WBDownloadState)downloadState;
- (void)notifyDownloadItem:(id<WBDownloadItem>)item withDownloadSpeed:(NSInteger)downloadSpeed;
- (void)notifyDownloadItem:(id<WBDownloadItem>)item withDownloadError:(NSError *)error;

@end

//下载控制
@interface WBDownloader(_DownloadControl)

- (void)_pauseAll;
- (void)_cancelItem:(id<WBDownloadItem>)item remove:(BOOL)remove;

@end

@interface WBDownloader()

///downloader identifier
@property(nonatomic,copy) NSString *downloaderIdentifier;
///current download counts
@property(nonatomic, assign) NSInteger activeRequestCount;

@property(nonatomic,strong) NSMutableDictionary *tasks;
@property(nonatomic,strong,readonly) NSMutableArray *downloadArrayWarpper;
@property(nonatomic,strong,readonly) NSMutableArray *completeArrayWarpper;
///下载项数组(包含等待中,下载中,暂停状态的下载项目)
@property(nonatomic,strong) NSMutableArray *downloadMutableArray;
///已下载项数组
@property(nonatomic,strong) NSMutableArray *completeMutableArray;

@property(nonatomic,strong) AFHTTPSessionManager *sessionManager;
@property(nonatomic,strong) dispatch_queue_t synchronizationQueue;

///paths
@property(nonatomic,strong) NSString *downloaderPath;
///complete block
@property(nonatomic,copy) WBDownloadCompleteBlock_t completeBlock;

@end

@implementation WBDownloader

-(instancetype)initWithIdentifier:(NSString *)identifier timeoutInterval:(NSTimeInterval)timeoutInterval completeBlock:(WBDownloadCompleteBlock_t)completeBlock{
    if (self = [super init]) {
        NSString *queueLabel = [NSString stringWithFormat:@"wayneking.MyWorld-%@",[NSUUID UUID].UUIDString];
        self.synchronizationQueue = dispatch_queue_create([queueLabel UTF8String], DISPATCH_QUEUE_SERIAL);
        
        NSURLSessionConfiguration *sessionConfiguation = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:identifier];
        
#ifdef DEBUG
        if (timeoutInterval < 10) {
            WBLog(@"[WBDownloader]: 超时时间过于短暂");
        }
#endif
        sessionConfiguation.timeoutIntervalForRequest = timeoutInterval > 0 ? timeoutInterval : 15;
        
        self.sessionManager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:sessionConfiguation];
        self.sessionManager.responseSerializer = [WBDownloadResponseSerializer serializer];
        
        self.downloaderIdentifier = identifier;
        self.completeBlock = completeBlock;
        self.downloaderPath = [NSTemporaryDirectory() stringByAppendingPathComponent:self.downloaderIdentifier];
        
        self.tasks = [[NSMutableDictionary alloc]init];
        self.downloadMutableArray = [[NSMutableArray alloc]init];
        self.completeMutableArray = [[NSMutableArray alloc]init];
        
        [self createPath];
        _maximumActiveDownloads = 3;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
}

#pragma mark - Getter And Setter

-(NSMutableArray *)downloadArrayWarpper{
    return [self mutableArrayValueForKey:WBDownloaderDownloadArrayObserveKeyPath];
}

- (NSMutableArray *)completeArrayWarpper{
    return [self mutableArrayValueForKey:WBDownloaderCompleteArrayObserveKeyPath];
}

- (NSArray *)downloadArray{
    return [self.downloadMutableArray copy];
}

-(NSArray *)completeArray{
    return [self.completeMutableArray copy];
}

-(void)setAllowsCellularAccess:(BOOL)allowsCellularAccess{
    //允许蜂窝连接
    self.sessionManager.requestSerializer.allowsCellularAccess = allowsCellularAccess;
}

-(BOOL)allowsCellularAccess{
    return self.sessionManager.requestSerializer.allowsCellularAccess;
}

- (void)setAcceptableContentTypes:(NSSet<NSString *> *)acceptableContentTypes{
    [self.sessionManager.responseSerializer setAcceptableContentTypes:acceptableContentTypes];
}

-(NSSet<NSString *> *)acceptableContentTypes{
    return self.sessionManager.responseSerializer.acceptableContentTypes;
}

-(void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field{
    [self.sessionManager.requestSerializer setValue:value forHTTPHeaderField:field];
}

- (void)setDidFinishEventsForBackgroundURLSessionBlock:(void (^)(NSURLSession * _Nonnull))block{
    [self.sessionManager setDidFinishEventsForBackgroundURLSessionBlock:block];
}

-(void)setMaximumActiveDownloads:(NSInteger)maximumActiveDownloads{
    dispatch_sync(self.synchronizationQueue, ^{
        _maximumActiveDownloads = maximumActiveDownloads;
        [self startNextTaskIfNecessary];
    });
}

#pragma mark - 下载处理
///开始下载一个item,这个方法必须在同步线程中调用,且调用前必须先判断是否可以开始新的下载
- (void)startDownloadItem:(id<WBDownloadItem>)item{
    [self notifyDownloadItem:item withDownloadState:WBDownloadStateLoading];
    NSString *URLIdentifier = [item.wb_downloadURL absoluteString];
    
    NSURLSessionDownloadTask *existingDownloadTask = self.tasks[URLIdentifier];
    if (existingDownloadTask) {
        return;
    }
    NSURLSessionDownloadTask *downloadTask = nil;
    NSURLRequest *request = [self.sessionManager.requestSerializer requestWithMethod:@"GET" URLString:URLIdentifier parameters:nil error:nil];
    if (!request) {
        NSError *URLError = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadURL userInfo:nil];
        WBLog(@"WBDownload fail: %@", URLError);
        [self notifyDownloadItem:item withDownloadError:URLError];
        [self notifyDownloadItem:item withDownloadState:WBDownloadStateError];
        [self startNextTaskIfNecessary];
        return;
    }
    
    __weak __typeof__(self) weakSelf = self;
    //IOS8后最多在后台运行3分钟
    UIApplication *application = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier taskId = [application beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask:taskId];
        taskId = UIBackgroundTaskInvalid;
    }];
    
    //创建下载完成的回调
    void (^completeBlock)(NSURLResponse *response, NSURL *filePath, NSError *error) = ^(NSURLResponse * _Nonnull response, NSURL *_Nullable filePath, NSError * _Nullable error){
        __strong __typeof__(weakSelf) strongSelf = weakSelf;
        dispatch_sync(self.synchronizationQueue, ^{
            if (error) {
                [strongSelf handleError:error forItem:item];
            }else{
                if (strongSelf.completeBlock == nil) {
                    [strongSelf.downloadArrayWarpper removeObject:item];
                    [strongSelf.completeArrayWarpper addObject:item];
                    [strongSelf notifyDownloadItem:item withDownloadState:WBDownloadStateComplete];
                }else{
                    [strongSelf notifyDownloadItem:item withDownloadProgress:WBDownloadStateProcess];
                    NSError *processError = strongSelf.completeBlock(strongSelf, item, filePath);
                    if (processError) {
                        [strongSelf handleError:processError forItem:item];
                    }else{
                        [strongSelf.downloadArrayWarpper removeObject:item];
                        [strongSelf.completeArrayWarpper addObject:item];
                        [strongSelf notifyDownloadItem:item withDownloadState:WBDownloadStateComplete];
                    }
                }
            }
            //移除已完成的任务
            [strongSelf removeTaskInfoForItem:item];
            [strongSelf startNextTaskIfNecessary];
        });
    };
    
    NSURL *(^destinationBlock)(NSURL *targetPath, NSURLResponse *response) = ^(NSURL *targetPath, NSURLResponse *response){
        NSString *fileName = [targetPath lastPathComponent];
        NSString *destinationPath = [weakSelf.downloaderPath stringByAppendingPathComponent:fileName];
        return [NSURL fileURLWithPath:destinationPath];
    };
    
    //创建task
    void (^progressBlock)(NSProgress *downloadProgress) = ^(NSProgress *downloadProgress){
        __strong __typeof__(weakSelf) strongSelf = weakSelf;
        NSDictionary *progressInfo = downloadProgress.userInfo;
        NSNumber *startTimeValue = progressInfo[WBDownloadProgressUserInfoStartTimeKey];
        NSNumber *startOffsetValue = progressInfo[WBDownloadProgressUserInfoStartOffsetKey];
        if (startTimeValue) {
            CFAbsoluteTime startTime = [startTimeValue doubleValue];
            int64_t startOffset = [startOffsetValue longLongValue];
            NSInteger downloadSpeed = (NSInteger)((downloadProgress.completedUnitCount - startOffset) / (CFAbsoluteTimeGetCurrent() - startTime));
            [strongSelf notifyDownloadItem:item withDownloadSpeed:downloadSpeed];
        }else{
            [downloadProgress setUserInfoObject:@(CFAbsoluteTimeGetCurrent()) forKey:WBDownloadProgressUserInfoStartTimeKey];
            [downloadProgress setUserInfoObject:@(downloadProgress.completedUnitCount) forKey:WBDownloadProgressUserInfoStartOffsetKey];
        }
        [strongSelf notifyDownloadItem:item withDownloadProgress:downloadProgress.fractionCompleted];
    };
    
    NSData *resumeData = [self resumenDataForItem:item];
    if (resumeData) {
        downloadTask = [self.sessionManager downloadTaskWithResumeData:resumeData progress:progressBlock destination:destinationBlock completionHandler:completeBlock];
    }else{
        downloadTask = [self.sessionManager downloadTaskWithRequest:request progress:progressBlock destination:destinationBlock completionHandler:completeBlock];
    }
    
    [self startDownloadTask:downloadTask forItem:item];
    if (taskId != UIBackgroundTaskInvalid) {
        [application endBackgroundTask:taskId];
        taskId = UIBackgroundTaskInvalid;
    }
    
}

- (void)handleError:(NSError *)error forItem:(id<WBDownloadItem>)item{
    //取消的情况在task cancel方法时处理,所以这里只需处理非取消的情况
    BOOL handledError = NO;
    if ([error.domain isEqualToString:NSURLErrorDomain]) {
        //handle url error
        switch (error.code) {
            case NSURLErrorCancelled:
                handledError = YES;
                break;
            default:
                break;
        }
    }else if([error.domain isEqualToString:NSPOSIXErrorDomain]){
        switch (error.code) {
            case 28:  //没有存储空间了
                WBLog(@"[WBDownloader]: 没有更多的空间了 ");
                //xx
                [[NSNotificationCenter defaultCenter]postNotificationName:WBDownloaderNoDiskSpaceNotification object:self];
                break;
            default:
                break;
        }
    }
    
    
}


#pragma mark - 同时下载数支持
- (void)startDownloadTask:(NSURLSessionDownloadTask *)downloadTask forItem:(id<WBDownloadItem>)item{
    self.tasks[[item.wb_downloadURL absoluteString]] = downloadTask;
    [downloadTask resume];
    ++self.activeRequestCount;
}

- (NSURLSessionDownloadTask *)downloadTaskForItem:(id<WBDownloadItem>)item{
    return self.tasks[[item.wb_downloadURL absoluteString]];
}

//尝试开始更多下载, 需要在同步队列中执行
- (void)startNextTaskIfNecessary{
    for (id<WBDownloadItem> item in self.downloadMutableArray) {
        if ([self isActiveRequestCountBelowMaximumLimit]) {
            if (item.wb_downloadState == WBDownloadStateWait) {
                [self startDownloadItem:item];
            }
        }else{
            break;
        }
    }
}

- (BOOL)isActiveRequestCountBelowMaximumLimit{
    return self.activeRequestCount < self.maximumActiveDownloads;
}

- (void)removeTaskInfoForItem:(id<WBDownloadItem>)item{
    [self.tasks removeObjectForKey:[item.wb_downloadURL absoluteString]];
    --self.activeRequestCount;
}

@end





@implementation WBDownloader (DownloadPath)

- (void)createPath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL exist = [fileManager fileExistsAtPath:self.downloaderPath isDirectory:&isDir];
    if (!exist || !isDir) {
        NSError *error;
        [fileManager createDirectoryAtPath:self.downloaderPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            WBLog(@"WBDownloader: 创建下载路径失败");
        }
    }
}

- (NSString *)pathForDownloadURL:(NSURL *)url{
    NSData *data = [[url absoluteString] dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data.bytes, (CC_LONG)data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x",digest[i]];
    }
    return [output copy];
}

- (NSString *)resumePathForItem:(id<WBDownloadItem>)item{
    NSString *tempFileName = [[self pathForDownloadURL:[item wb_downloadURL]] stringByAppendingPathExtension:@"download"];
    return [self.downloaderPath stringByAppendingPathComponent:tempFileName];
}

- (void)saveResumeData:(NSData *)resumeData forItem:(id<WBDownloadItem>)item{
    [resumeData writeToFile:[self resumePathForItem:item] atomically:YES];
}

- (NSData *)resumenDataForItem:(id<WBDownloadItem>)item{
    NSString *resumePath = [self resumePathForItem:item];
    if ([[NSFileManager defaultManager]fileExistsAtPath:resumePath]) {
        NSDictionary *resumeInfo = [NSDictionary dictionaryWithContentsOfFile:resumePath];
        NSInteger resumeInfoVersion = [resumeInfo[@"NSURLSessionResumeInfoVersion"] integerValue];
        NSString *tempPath = nil;
        switch (resumeInfoVersion) {
            case 1:
                tempPath = resumeInfo[@"NSURLSessionResumeInfoLocalPath"];
                break;
                
            default:
            {
                NSString *tempFileName = resumeInfo[@"NSURLSessionResumeInfoTempFileName"];
                if (tempFileName) {
                    tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:tempFileName];
                }else{
                    WBLog(@"不支持的 resumeInfoVersion %@, 请前往 https://github.com/scfhao/SODownloader/issues 反馈", @(resumeInfoVersion).stringValue);
                }
            }
                break;
        }
        
        if (tempPath && [[NSFileManager defaultManager] fileExistsAtPath:tempPath]) {
            NSData *resumeData = [NSData dataWithContentsOfFile:resumePath];
            [[NSFileManager defaultManager] removeItemAtPath:resumePath error:nil];
            return resumeData;
        }else{
            WBLog(@"没有找到文件: %@",tempPath);
        }
    }else{
        WBLog(@"没有找到文件: %@",resumePath);
    }
    return nil;
}

#pragma mark - 暂停下载相关方法
- (void)pauseItem:(id<WBDownloadItem>)item{
    //xx
}

- (void)_pauseItem:(id<WBDownloadItem>)item{
    if (item.wb_downloadState == WBDownloadStateLoading || item.wb_downloadState == WBDownloadStateWait) {
        [self _pauseTaskForItem:item saveResumeData:YES];
        [self notifyDownloadItem:item withDownloadState:WBDownloadStatePaused];
    }
}


#pragma mark - 取消下载相关方法
- (void)applicationWillTerminate:(NSNotification *)notification{
    dispatch_sync(self.synchronizationQueue, ^{
        for (id<WBDownloadItem> item in self.downloadArray) {
            [self _pauseTaskForItem:item saveResumeData:YES];
        }
    });
}

- (void)_pauseTaskForItem:(id<WBDownloadItem>)item saveResumeData:(BOOL)save{
    if (item.wb_downloadState == WBDownloadStateLoading) {
        NSURLSessionDownloadTask *downloadTask = [self downloadTaskForItem:item];
        [downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            if (save && resumeData) {
                [self saveResumeData:resumeData forItem:item];
            }
        }];
    }
    
    if (!save) {
        NSError *error = nil;
        BOOL removed = [[NSFileManager defaultManager] removeItemAtPath:@"" error:&error];
        if (!removed) {
            WBLog(@"[SODownloader]: remove resume data fail: %@",error);
        }
    }
}

//判断item是否在当前的downloader的控制下,用于条件判断
- (BOOL)isControlDownloadFlowForItem:(id<WBDownloadItem>)item{
    return [self.downloadMutableArray containsObject:item] || [self.completeMutableArray containsObject:item];
}

@end

@implementation WBDownloader(DownloadNotify)

- (void)notifyDownloadItem:(id<WBDownloadItem>)item withDownloadState:(WBDownloadState)downloadState{
    if ([item respondsToSelector:@selector(setWb_downloadState:)]) {
        item.wb_downloadState = downloadState;
    }else{
        WBLog(@"下载模型必须实现setDownloadState:才能获取到正确的下载状态!");
    }
}

- (void)notifyDownloadItem:(id<WBDownloadItem>)item withDownloadProgress:(double)downloadProgress{
    if ([item respondsToSelector:@selector(setWb_downloadProgress:)]) {
        item.wb_downloadProgress = downloadProgress;
    }else{
        WBLog(@"下载模型必须实现setDownloadProgress:才能获取到正确的下载状态!");
    }
}

- (void)notifyDownloadItem:(id<WBDownloadItem>)item withDownloadError:(NSError *)error{
    if ([item respondsToSelector:@selector(setWb_downloadError:)]) {
        item.wb_downloadError = error;
    }
}

- (void)notifyDownloadItem:(id<WBDownloadItem>)item withDownloadSpeed:(NSInteger)downloadSpeed{
    if ([item respondsToSelector:@selector(setWb_downloadSpeed:)]) {
        item.wb_downloadSpeed = downloadSpeed;
    }
}
@end














