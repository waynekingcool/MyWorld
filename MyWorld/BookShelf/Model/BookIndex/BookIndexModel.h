//
//  BookIndexModel.h
//  MyWorld
//
//  Created by wayneking on 2018/5/4.
//  Copyright © 2018年 wayneking. All rights reserved.
//  书籍推荐model

#import <Foundation/Foundation.h>

@interface BookIndexModel : NSObject
///小说分类
@property(nonatomic,copy) NSString *categoryTitle;
///小说类型
@property(nonatomic,copy) NSString *bookType;
///小说名称
@property(nonatomic,copy) NSString *title;
///小说作者
@property(nonatomic,copy) NSString *author;
///小说链接
@property(nonatomic,copy) NSString *bookurl;
///小说封面
@property(nonatomic,copy) NSString *imageUrl;
///小说描述
@property(nonatomic,copy) NSString *bookDesc;
@end
