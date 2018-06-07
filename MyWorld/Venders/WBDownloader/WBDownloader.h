//
//  WBDownloader.h
//  MyWorld
//
//  Created by wayneking on 2018/6/2.
//  Copyright © 2018年 wayneking. All rights reserved.
//  多任务下载

#import <Foundation/Foundation.h>
#import "WBDownloadItem.h"

@class WBDownloader;
NS_ASSUME_NONNULL_BEGIN
/*
 downloader:根据此对象判断是否下载成功
 item: 下载项对象
 location: 文件位置,需要从此目录将文件移动到Documents Library Cache目录. block调用完后,WBDownloader会自动移除该位置的文件
 */
typedef NSError *_Nullable(^WBDownloadCompleteBlock_t)(WBDownloader *downloader, id<WBDownloadItem> item, NSURL *location);

/*
 用于从WBDownloader的下载列表和已完成列表中筛选下载项
 */
typedef BOOL (^WBDownloadFilter_t)(id<WBDownloadItem> item);

/*
 下载工具类,基于AFURLSessionManager.
 用于下载模型化对象(WBDownloadItem),对于其他下载需求,建议直接使用AFN下载
 */
@interface WBDownloader : NSObject
///下载器的唯一标识
@property(nonatomic,copy,readonly) NSString *downloaderIdentifier;
///最大下载数
@property(nonatomic, assign) NSInteger maximumActiveDownloads;
#pragma mark - 相关数组

/**
 下载项数组, WBDownloaderDownloadArrayObserveKeyPath 外部可通过KVO对此数组内容进行观察
 */
@property(nonatomic,strong,readonly) NSArray *downloadArray;


/**
 已下载数组, WBDownloaderCompleteArrayObserveKeyPath 外部可通过KVO对此数组的内容变化进行观察
 */
@property(nonatomic,strong,readonly) NSArray *completeArray;

#pragma mark - 创建/初始化

/**
 为identifer创建一个downloader

 @param identifier 要获取的downloader的标识符,这个标识符还将被用于downloader临时文件路径名和urlSession的identifier
 @param timeoutInterval 下载超时时间, 当一个下载任务在指定时间未接收到下载数据,会超时,建议大于10s
 @param completeBlock 完成回调,此block在非主线程中被调用
 @return 对应的downloader
 */
- (instancetype)initWithIdentifier:(NSString *)identifier timeoutInterval:(NSTimeInterval)timeoutInterval completeBlock:(WBDownloadCompleteBlock_t)completeBlock;


/**
 对象置换

 @param filter 同一条数据可能会有多份对象,通过此方法获取正确的对象
 @return 返回WBDownloader中的那个具备正确下载状态的对象.
 */
- (id<WBDownloadItem>)filterItemUsingFilter:(WBDownloadFilter_t)filter;


/**
 错误处理分为两类:
 1.可以重新下载.
 2.无法重新下载
 autoCancelFailedItem属性未YES时,当一个下载项下载失败且WBDownloader无法处理时,自动取消该下载项,状态将被置为Normal;属性为NO时,下载状态被置为Error,下载项的wb_downloadError属性将被赋值
 */
@property(nonatomic, assign) BOOL autoCancelFailedItem;
@property (nonatomic, assign) BOOL allowsCellularAccess;

#pragma mark - 后台下载支持
- (void)setDidFinishEventsForBackgroundURLSessionBlock:(void(^)(NSURLSession *session))block;

#pragma mark - HTTP定制
/*
 下载文件接受类型,此属性默认为nil,可接受任务类型的文件
 */
@property(nonatomic,copy,nullable) NSSet <NSString *> *acceptableContentTypes;


/**
设置下载请求使用的HTTP Header.比如User-Agent, 或者其他Header.
 */
- (void)setValue:(nullable NSString *)value forHTTPHeaderField:(nonnull NSString *)field;

@end

///下载管理类
@interface WBDownloader(DownloadControl)

#pragma mark - 下载管理

/**
 将item加入下载列表

 @param item 要加入下载列表的模型对象, 需要实现WBDownloadItem协议
 */
- (void)downloadItem:(id<WBDownloadItem>)item;


/**
 应用重启后,将上次程序运行时未下载完成的项目通过此方法告诉WBDownloader对象,对于上次程序挂起前处于暂停状态的项目,
 autoStartDownload参数传入NO;对于上次程序刮起前处于等待和下载中状态的项目,autoStartDownload参数传入YES.对于上次程序挂起前已下载
 的项目,调用'markItemsAsComplete:'方法将其标识为已下载

 @param item 要加入下载列表的模型对象,需要实现WBDownloadItem协议.
 @param autoStartDownload 是否开启自动下载
 */
- (void)downloadItem:(id<WBDownloadItem>)item autoStartDownload:(BOOL)autoStartDownload;



/**
 将items加入下载列表

 @param items 要加入下载列表的模型对象数组,需要实现WBDownloadItem协议.
 */
- (void)downloadItems:(NSArray<WBDownloadItem> *)items;
- (void)downloaditems:(NSArray <WBDownloadItem> *)items autoStartDownload:(BOOL)autoStartDownload;

///暂停: 用于等待或下载中状态的项目
- (void)pauseItem:(id<WBDownloadItem>)item;
- (void)pauseAll;

///继续: 用于已暂停或失败状态的下载项
- (void)reuseItem:(id<WBDownloadItem>)item;
- (void)resumeAll;

///取消: 用于取消下载列表中尚未下载完成的项目
- (void)cancelItem:(id<WBDownloadItem>)item;
- (void)cancelItems:(NSArray <WBDownloadItem> *)items;
- (void)cancelAll;

///将之前下载的对象通过此方法告诉 WBDownloader, WBDownloader 对象会将其标识为已下载
- (void)markItemsAsComplate:(NSArray<WBDownloadItem> *)items;
///删除: 删除已下载的项目
- (void)removeCompletedItem:(id<WBDownloadItem>)item;
- (void)removeAllCompletedItems;

///判断该item是否在当前的downloader对象的下载列表或完成列表中
- (BOOL)isControlDownloadFlowForItem:(id<WBDownloadItem>)item;

@end


#pragma mark - KVO
//此宏定义所定义的常量在比较字符串的时候更加的效率,通过指针进行比较

///WBDownloader 对象的 downloadArray 属性对应的 Observe Keypath
FOUNDATION_EXPORT NSString *const WBDownloaderDownloadArrayObserveKeyPath;
///WBDownloader 对象的 completeArray 属性对应的 Observe Keypath
FOUNDATION_EXPORT NSString *const WBDownloaderCompleteArrayObserveKeyPath;

#pragma mark - Notifications
///当设备
FOUNDATION_EXPORT NSString *const WBDownloaderNoDiskSpaceNotification;




NS_ASSUME_NONNULL_END











