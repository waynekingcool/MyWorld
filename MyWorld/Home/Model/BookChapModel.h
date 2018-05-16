//
//  BookChapModel.h
//  MyWorld
//
//  Created by wayneking on 2018/4/28.
//  Copyright © 2018年 wayneking. All rights reserved.
//  小说章节model

#import <Foundation/Foundation.h>

@interface BookChapModel : NSObject
///章节名称
@property(nonatomic,copy) NSString *chapTitle;
///章节内容
@property(nonatomic,copy) NSString *chapContent;
///章节总页数
@property(nonatomic) NSInteger pageCount;

//web端
///上一章url
@property(nonatomic,copy) NSString *pre;
///下一章url
@property(nonatomic,copy) NSString *next;
///当前url
@property(nonatomic,copy) NSString *current;
///缓存需要用到的id,根据章节名称来定义
@property(nonatomic,copy) NSString *chapId;

///根据页数获取内容
- (NSString *)getContent:(NSInteger)page;

@end
