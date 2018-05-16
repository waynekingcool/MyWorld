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


/**
 判断是否存在

 @param sql sql语句
 @param name 表的名称
 @return bool 0不存在 1 存在
 */
+ (BOOL)isExistWithSQL:(NSString *)sql WithTableName:(NSString *)name;


/**
 获取缓存数据

 @param tableName 小说名称
 @param chapTitle 章节名称
 @return 返回BookChapModel
 */
+ (BookChapModel *)getDataWithTableName:(NSString *)tableName WithChapName:(NSString *)chapTitle;


/**
 根据url获取缓存数据

 @param url 链接
 @param tableName 表的名称
 @return 返回BookChapModel
 */
+ (BookChapModel *)getDataWithUrl:(NSString *)url WithTableName:(NSString *)tableName;
@end
