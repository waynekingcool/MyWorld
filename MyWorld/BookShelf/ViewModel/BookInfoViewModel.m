//
//  BookInfoViewModel.m
//  MyWorld
//
//  Created by wayneking on 2018/5/5.
//  Copyright © 2018年 wayneking. All rights reserved.
//

#import "BookInfoViewModel.h"

@interface BookInfoViewModel()

@property(nonatomic,strong) WBNetWorkTool *tool;

@end

@implementation BookInfoViewModel

-(instancetype)init{
    if (self = [super init]) {
        [self initCommand];
        [self initSubscribe];
    }
    return self;
}

- (void)initCommand{
    @weakify(self);
    self.fetchDataCommadn = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSString *input) {
        @strongify(self);
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [self loadData:subscriber WithPath:input];
            return nil;
        }];
    }];
}

- (void)initSubscribe{
    [[self.fetchDataCommadn.executionSignals switchToLatest] subscribeNext:^(NSDictionary *data) {
        //解析数据
        NSDictionary *bookInfo = data[@"bookInfo"];
        self.model = [BookInfoModel mj_objectWithKeyValues:bookInfo];
        
        NSMutableArray *tempLast = [[NSMutableArray alloc]init];
        NSArray *lastChap = data[@"lastChap"];
        for (NSDictionary *dic in lastChap) {
            BookInfoChapModel *model = [BookInfoChapModel mj_objectWithKeyValues:dic];
            [tempLast addObject:model];
        }
        self.lastArray = [tempLast copy];
        
        NSMutableArray *tempAll = [[NSMutableArray alloc]init];
        NSArray *allChap = data[@"allChap"];
        for (NSDictionary *dic in allChap) {
            BookInfoChapModel *model = [BookInfoChapModel mj_objectWithKeyValues:dic];
            [tempAll addObject:model];
        }
        self.allArray = [tempAll copy];
        
    }];
    
}

- (void)loadData:(id<RACSubscriber>)subscribe WithPath:(NSString *)path{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:path forKey:@"path"];
    
    [self.tool getDataWithAct:@"bookInfo" params:dic start:^{
        
    } fail:^(NSError *error) {
        [subscribe sendError:error];
    } success:^(NSDictionary *data) {
        
        [subscribe sendNext:data];
        [subscribe sendCompleted];
    }];
}

//获取章节数
- (NSInteger)getChapCount:(NSInteger)section{
    if (section == 0) {
        return self.lastArray.count;
    }else{
        return self.allArray.count;
    }
}

//获取model
- (BookInfoChapModel *)getModelWIthSection:(NSInteger)section WithRow:(NSInteger)row{
    if (section == 0) {
        return self.lastArray[row];
    }else{
        return self.allArray[row];
    }
}

//获取章节url
- (NSURL *)getChapUrlWithSection:(NSInteger)section WithRow:(NSInteger)row{
    BookInfoChapModel *model = [self getModelWIthSection:section WithRow:row];
    return [NSURL URLWithString:model.chapUrl];
}

#pragma mark - Getter And Setter
-(NSMutableArray *)lastArray{
    if (!_lastArray) {
        _lastArray = [[NSMutableArray alloc]init];
    }
    return _lastArray;
}

-(NSMutableArray *)allArray{
    if (!_allArray) {
        _allArray = [[NSMutableArray alloc]init];
    }
    return _allArray;
}

-(WBNetWorkTool *)tool{
    if (!_tool) {
        _tool = [[WBNetWorkTool alloc]init];
    }
    return _tool;
}

@end
