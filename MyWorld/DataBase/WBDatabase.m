//
//  WBDatabase.m
//  MyWorld
//
//  Created by wayneking on 2018/5/9.
//  Copyright © 2018年 wayneking. All rights reserved.
//

#import "WBDatabase.h"

@implementation WBDatabase
static FMDatabase *single = nil;

+ (FMDatabase *)shareDB{
    NSString *path = DBPath;
    WBLog(@"DBPath: %@",DBPath);
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        single = [FMDatabase databaseWithPath:path];
    });
    return single;
}

//根据名称建表
+ (BOOL)createTableWithTitle:(NSString *)title{
    FMDatabase *db = [WBDatabase shareDB];
    if ([db open]) {
        NSString *sqlStr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (chapTitle text,chapContent text,pre text,next text,chapId text);",title];
        BOOL result = [db executeUpdate:sqlStr];
        if (result) {
//            WBLog(@"表: %@ 创建成功",title);
        }else{
             WBLog(@"表: %@ 创建失败",title);
        }
        return result;
    }else{
        WBLog(@"数据库打开失败");
        return false;
    }
}

//保存到数据库中
+ (BOOL)saveModel:(BookChapModel *)model WithTitle:(NSString *)title{
    FMDatabase *db = [WBDatabase shareDB];
    if ([db open]) {
        //检查表是否存在
        BOOL isExist = [WBDatabase createTableWithTitle:title];
        if (!isExist) {
            return false;
        }
        
        NSString *sqlStr = [NSString stringWithFormat:@"INSERT INTO %@ (chapTitle,chapContent,pre,next,chapId) VALUES ('%@','%@','%@','%@','%@');",title,model.chapTitle,model.chapContent,model.pre,model.next,model.chapId];
        BOOL result = [db executeUpdate:sqlStr];
        if (result) {
            WBLog(@"插入成功:%@",model.chapTitle);
        }else{
            WBLog(@"插入失败:%@",model.chapTitle);
        }
        return result;
    }else{
        WBLog(@"数据库打开失败");
        return false;
    }
}
@end








