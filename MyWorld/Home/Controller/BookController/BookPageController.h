//
//  BookPageController.h
//  MyWorld
//
//  Created by wayneking on 2018/4/28.
//  Copyright © 2018年 wayneking. All rights reserved.
//  小说阅读Controller

#import "BaseController.h"
#import "BookModel.h"

@interface BookPageController : BaseController

@property(nonatomic,strong) BookModel *model;
@property(nonatomic,copy) NSString *content;
@end
