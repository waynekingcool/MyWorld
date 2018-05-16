//
//  WebBookViewModel.h
//  MyWorld
//
//  Created by wayneking on 2018/5/7.
//  Copyright © 2018年 wayneking. All rights reserved.
//  web小说viewModel

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
//model
#import "BookChapModel.h"
#import "BookRecordModel.h"

@interface WebBookViewModel : NSObject

///获取内容
@property(nonatomic,strong) RACCommand *fetchContentCommad;
///model
@property(nonatomic,strong) BookChapModel *model;
//recordModel
@property(nonatomic,strong) BookRecordModel *recordModel;


///根据页数返回内容
- (NSString *)getContentWithPage:(NSInteger)page;
///判断是否有阅读记录
- (BOOL)hasRecordWithPath:(NSString *)path;
///缓存数据
- (void)saveRecordWithTitle:(NSString *)title WithChapTitle:(NSString *)chapTitle WithPage:(NSString *)page;
@end
