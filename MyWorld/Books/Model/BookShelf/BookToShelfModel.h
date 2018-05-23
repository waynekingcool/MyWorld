//
//  BookToShelfModel.h
//  MyWorld
//
//  Created by wayneking on 2018/5/23.
//  Copyright © 2018年 wayneking. All rights reserved.
//  保存到书架model

#import <Foundation/Foundation.h>

@interface BookToShelfModel : NSObject
///书名
@property(nonatomic,copy) NSString *title;
///封面url
@property(nonatomic,copy) NSString *picUrl;
///阅读记录
@property(nonatomic,copy) NSString *recordTitle;
///书连接地址
@property(nonatomic,copy) NSString *url;
@end
