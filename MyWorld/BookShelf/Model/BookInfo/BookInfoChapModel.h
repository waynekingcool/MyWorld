//
//  BookInfoChapModel.h
//  MyWorld
//
//  Created by wayneking on 2018/5/5.
//  Copyright © 2018年 wayneking. All rights reserved.
//  小说详情 章节model

#import <Foundation/Foundation.h>

@interface BookInfoChapModel : NSObject
///章节链接
@property(nonatomic,copy) NSString *chapUrl;
///章节名称
@property(nonatomic,copy) NSString *chapTitle;
@end
