//
//  WBDatabase.h
//  MyWorld
//
//  Created by wayneking on 2018/5/9.
//  Copyright © 2018年 wayneking. All rights reserved.
//  对FMDB再次封装

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>
#import "BookChapModel.h"

@interface WBDatabase : NSObject
///单例
+ (FMDatabase *)shareDB;

///根据小说名称建表
+ (BOOL)createTableWithTitle:(NSString *)title;

///根据model将数据保存到数据库中
+ (BOOL)saveModel:(BookChapModel *)model WithTitle:(NSString *)title;

@end
