//
//  BookViewModel.m
//  MyWorld
//
//  Created by wayneking on 2018/4/28.
//  Copyright © 2018年 wayneking. All rights reserved.
//

#import "BookViewModel.h"

@interface BookViewModel()
@property(nonatomic,strong) NSMutableArray *chapArray;
@property(nonatomic,strong) NSMutableArray *chaptItleArray;
@end


@implementation BookViewModel

-(instancetype)init{
    if (self = [super init]) {
        [self initCommand];
        [self initSubscribe];
    }
    return self;
}

#pragma mark - 初始化command
- (void)initCommand{
    self.fetchContentCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSURL *url) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            //根据url读取小说内容
            NSString *content = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
            if (!content) {
                content = [NSString stringWithContentsOfURL:url encoding:0x80000632 error:nil];
            }
            if (!content) {
                content = [NSString stringWithContentsOfURL:url encoding:0x80000631 error:nil];
            }
            [self separterChapWithContent:content];
            BookModel *model = [[BookModel alloc]init];
            model.chapArray = [self.chapArray copy];
            model.chapTitleArray = [self.chaptItleArray copy];
            //将model发出
            [subscriber sendNext:model];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
}

#pragma mark - 订阅command
- (void)initSubscribe{
    //订阅获取小说内容信号
    @weakify(self);
    [[self.fetchContentCommand.executionSignals switchToLatest] subscribeNext:^(BookModel *model) {
        @strongify(self);
        self.model = model;
    }];
    
}

#pragma mark - 更新阅读记录
- (void)updateRecord:(NSInteger)page WithChap:(NSInteger)chap WithTitle:(NSString *)title{
    NSString *path = [RecordPath stringByAppendingPathComponent:title];
    BookRecordModel *model = [[BookRecordModel alloc]init];
    model.recordTitle = title;
    model.recordPage = [NSString stringWithFormat:@"%ld",page];
    model.recordChap = [NSString stringWithFormat:@"%ld",chap];
    self.recordModel = model;
    BOOL success = [NSKeyedArchiver archiveRootObject:model toFile:path];
    if (success) {
        WBLog(@"Title:%@  ChapTitle:%@  Page:%@ 缓存成功",model.recordTitle,model.recordChap,model.recordPage);
    }else{
        WBLog(@"Title:%@  ChapTitle:%@  Page:%@ 缓存失败",model.recordTitle,model.recordChap,model.recordPage);
    }
}

//获取阅读记录
- (BOOL)hasRecordWithPath:(NSString *)path{
    self.recordModel = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if (self.recordModel) {
        return true;
    }else{
        return false;
    }
}

#pragma mark - Private methods
//将小说内容根据章节进行分割
- (void)separterChapWithContent:(NSString *)content{
    //根据名称进行分割
    NSString *parten = @"第[0-9一二三四五六七八九十百千]*[章回].*";
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:parten options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray* match = [reg matchesInString:content options:NSMatchingReportCompletion range:NSMakeRange(0, [content length])];
    
    //生成对应model
    if (match.count != 0) {
        
        //用来记录上一次的range
        NSRange lastRange = NSMakeRange(0, 0);
        
        for (int i = 0; i < match.count; i++) {
            //查询出来的结果
            NSTextCheckingResult *result = match[i];
            NSRange range = [result range];
            NSInteger local = range.location;

            if (i ==0) {
                //起始
                BookChapModel *chapModel = [[BookChapModel alloc]init];
                chapModel.chapTitle = @"引子";
                NSInteger len = local;
                chapModel.chapContent = [content substringWithRange:NSMakeRange(0, len)];
                [self.chapArray addObject:chapModel];
                [self.chaptItleArray addObject:@"引子"];
            }else if(i == match.count - 1){
                //最后一个
                BookChapModel *chapModel = [[BookChapModel alloc]init];
                NSString *title = [content substringWithRange:range];
                chapModel.chapTitle = title;
                chapModel.chapContent = [content substringWithRange:NSMakeRange(local, content.length-local)];
                [self.chapArray addObject:chapModel];
                [self.chaptItleArray addObject:title];
            }else if(i > 0){
                BookChapModel *chapModel = [[BookChapModel alloc]init];
                NSString *title = [content substringWithRange:lastRange];
                chapModel.chapTitle = title;
                NSInteger len = range.location - lastRange.location;
                chapModel.chapContent = [content substringWithRange:NSMakeRange(lastRange.location, len)];
                [self.chapArray addObject:chapModel];
                [self.chaptItleArray addObject:title];
            }
            
            lastRange = range;
        }
    }
    
}

//根据章和页数返回内容
- (NSString *)getContentWithChap:(NSInteger)chap Page:(NSInteger)page{
    BookChapModel *model = self.model.chapArray[chap];
    return [model getContent:page];
}

#pragma mark - Getter and Setter
-(NSMutableArray *)chapArray{
    if (!_chapArray) {
        _chapArray = [[NSMutableArray alloc]init];
    }
    return _chapArray;
}

-(NSMutableArray *)chaptItleArray{
    if (!_chaptItleArray) {
        _chaptItleArray = [[NSMutableArray alloc]init];
    }
    return _chaptItleArray;
}



@end
