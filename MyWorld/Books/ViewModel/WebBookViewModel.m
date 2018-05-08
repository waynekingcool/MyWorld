//
//  WebBookViewModel.m
//  MyWorld
//
//  Created by wayneking on 2018/5/7.
//  Copyright © 2018年 wayneking. All rights reserved.
//

#import "WebBookViewModel.h"


@interface WebBookViewModel()

@property(nonatomic,strong) WBNetWorkTool *tool;

@end


@implementation WebBookViewModel

-(instancetype)init{
    if (self = [super init]) {
        [self initCommand];
        [self initSubscribe];
    }
    return self;
}

//初始化command
- (void)initCommand{
    self.fetchContentCommad = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSString *path) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            //获取数据
            [self loadData:subscriber WithPath:path];
            return nil;
        }];
    }];
}

//初始化订阅者
- (void)initSubscribe{
    [[self.fetchContentCommad.executionSignals switchToLatest] subscribeNext:^(NSDictionary *data) {
        self.model = [BookChapModel mj_objectWithKeyValues:data];
    }];
}

- (void)loadData:(id<RACSubscriber>)subscriber WithPath:(NSString *)path{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:path forKey:@"path"];
    
    [self.tool getDataWithAct:@"chapContent" params:dic start:^{
        
    } fail:^(NSError *error) {
        [subscriber sendError:error];
    } success:^(NSDictionary *data) {
        [subscriber sendNext:data];
        [subscriber sendCompleted];
    }];
}

#pragma mark - Private Methods
//根据页数返回内容
- (NSString *)getContentWithPage:(NSInteger)page{
    return [self.model getContent:page];
}

#pragma mark - Getter And Setter
-(WBNetWorkTool *)tool{
    if (!_tool) {
        _tool = [[WBNetWorkTool alloc]init];
    }
    return _tool;
}

@end
