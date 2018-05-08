//
//  BookIndexViewModel.h
//  MyWorld
//
//  Created by wayneking on 2018/5/4.
//  Copyright © 2018年 wayneking. All rights reserved.
//  小说推荐viewModel

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "BookIndexModel.h"

@interface BookIndexViewModel : NSObject
///获取网络数据
@property(nonatomic,strong) RACCommand *fetchDataCommand;
@property(nonatomic,strong) NSMutableArray *dataArray;
///cell的model
@property(nonatomic,strong)BookIndexModel *model;
//是否为热门model
@property(nonatomic) BOOL isHot;
///小说链接
@property(nonatomic,copy) NSString *path;


///获取某一分类的个数
- (NSInteger)getCount:(NSInteger)section;
///获取某一分类其中的某个model
- (void)getModelBySection:(NSInteger)section WithRow:(NSInteger)row;
///返回分类标题
- (NSString *)getHeadViewTitle:(NSInteger)section;
@end
