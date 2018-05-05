//
//  BookInfoTableHeadView.h
//  MyWorld
//
//  Created by wayneking on 2018/5/5.
//  Copyright © 2018年 wayneking. All rights reserved.
//  小说详情headView

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "BookInfoModel.h"

@interface BookInfoTableHeadView : UIView
///开始阅读
@property(nonatomic,strong) RACSubject *startSubject;
///放入书架
@property(nonatomic,strong) RACSubject *putSubject;
///我的书架
@property(nonatomic,strong) RACSubject *shelfSubject;

@property(nonatomic,strong) BookInfoModel *model;
@end
