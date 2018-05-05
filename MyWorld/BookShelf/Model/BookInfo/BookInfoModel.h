//
//  BookInfoModel.h
//  MyWorld
//
//  Created by wayneking on 2018/5/5.
//  Copyright © 2018年 wayneking. All rights reserved.
//  小说详情model

#import <Foundation/Foundation.h>

@interface BookInfoModel : NSObject
///书名
@property(nonatomic,copy) NSString *title;
///作者
@property(nonatomic,copy) NSString *author;
///分类
@property(nonatomic,copy) NSString *category;
///状态
@property(nonatomic,copy) NSString *state;
///字数
@property(nonatomic,copy) NSString *wordCount;
///更新时间
@property(nonatomic,copy) NSString *updateTime;
///描述
@property(nonatomic,copy) NSString *desc;
///封面
@property(nonatomic,copy) NSString *coverUrl;
@end
