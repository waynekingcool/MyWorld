//
//  WebBookController.h
//  MyWorld
//
//  Created by wayneking on 2018/5/7.
//  Copyright © 2018年 wayneking. All rights reserved.
//  web小说

#import "BaseController.h"

@interface WebBookController : BaseController
///连接
@property(nonatomic,strong) NSURL *webUrl;
///用来判断是否有缓存
@property(nonatomic,copy) NSString *recordTitle;
///选择某章节阅读
@property(nonatomic, assign) BOOL isChoseChap;

@end
