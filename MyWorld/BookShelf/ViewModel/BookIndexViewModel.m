//
//  BookIndexViewModel.m
//  MyWorld
//
//  Created by wayneking on 2018/5/4.
//  Copyright © 2018年 wayneking. All rights reserved.
//

#import "BookIndexViewModel.h"

@interface BookIndexViewModel()
@property(nonatomic,strong) WBNetWorkTool *tool;

@end

@implementation BookIndexViewModel

-(instancetype)init{
    if (self = [super init]) {
        [self initCommand];
        [self initSubscribe];
    }
    return self;
}

//初始化command
- (void)initCommand{
    self.fetchDataCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            //获取数据
            [self loadData:subscriber];
            return nil;
        }];
    }];
}

//订阅信号
- (void)initSubscribe{
    [[self.fetchDataCommand.executionSignals switchToLatest] subscribeNext:^(NSArray *tempArray) {
        //更新数据
        self.dataArray = [tempArray copy];
    }];
}

- (void)loadData:(id<RACSubscriber>)subscriber{
    
    [self.tool getDataWithAct:@"index" params:nil start:^{
        
    } fail:^(NSError *error) {
        //发送错误信号
        [subscriber sendError:error];
    } success:^(NSDictionary *data) {
        //临时数组
        NSMutableArray *tempDataArray = [[NSMutableArray alloc]init];
        
        NSArray *array = (NSArray *)data;
        for (NSDictionary *dic in array) {
            //遍历字典
            for (NSString *key in [dic allKeys]) {
                NSArray *value = dic[key];
                //转换为model
                NSMutableArray *tempArray = [[NSMutableArray alloc]init];
                for (NSDictionary *modelDic in value) {
                    BookIndexModel *model = [BookIndexModel mj_objectWithKeyValues:modelDic];
                    [tempArray addObject:model];
                }
                //拼成字典
                NSDictionary *tempDic = @{key:tempArray};
                [tempDataArray addObject:tempDic];
            }
        }
        
        //发送数据
        [subscriber sendNext:tempDataArray];
        [subscriber sendCompleted];
    }];
}

//获取某一分类的个数
- (NSInteger)getCount:(NSInteger)section{
    NSDictionary *dic = self.dataArray[section];
    for (NSString *key in [dic allKeys]) {
        NSArray *array = dic[key];
        return array.count;
    }
    return 0;
}

//获取某一分类其中的某个model
- (void)getModelBySection:(NSInteger)section WithRow:(NSInteger)row{
    NSDictionary *dic = self.dataArray[section];
    for (NSString *key in [dic allKeys]) {
        NSArray *array = dic[key];
        for (int i = 0 ; i < array.count; i++) {
            if (i == row) {
                BookIndexModel *model = array[row];
                self.isHot = [self isHotModel:key];
                self.model = model;
                self.path = [self getBookPath:model.bookurl];
                break;
            }
        }
    }
}

//是否为热门推荐
- (BOOL)isHotModel:(NSString *)key{
    if ([key isEqualToString:@"hot"]) {
        return YES;
    }else{
        return NO;
    }
}

//返回分类标题
- (NSString *)getHeadViewTitle:(NSInteger)section{
    NSDictionary *dic = self.dataArray[section];
    for (NSString *key in [dic allKeys]) {
        if ([key isEqualToString:@"hot"]) {
            return @"热门推荐";
        }else{
            return key;
        }
    }
    return @"";
}

//获取小说链接
- (NSString *)getBookPath:(NSString *)string{
    NSArray *split = [string componentsSeparatedByString:@"/"];
    NSString *path = [NSString stringWithFormat:@"%@_%@/",split[split.count-3],split[split.count-2]];
    return path;
}


- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

#pragma mark - Getter And Setter
-(WBNetWorkTool *)tool{
    if (!_tool) {
        _tool = [[WBNetWorkTool alloc]init];
    }
    return _tool;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}
@end
