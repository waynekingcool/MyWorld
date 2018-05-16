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
        NSString *sqlStr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (chapTitle text,chapContent text,pre text,next text,chapId INTEGER,current text);",title];
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
        
        NSString *sqlStr = [NSString stringWithFormat:@"INSERT INTO %@ (chapTitle,chapContent,pre,next,chapId,current) VALUES ('%@','%@','%@','%@','%@','%@');",title,model.chapTitle,model.chapContent,model.pre,model.next,model.chapId,model.current];
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

//根据条件进行查询,判断是否存在
+ (BOOL)isExistWithSQL:(NSString *)sql WithTableName:(NSString *)name{
    FMDatabase *db = [WBDatabase shareDB];
    //检查表是否存在
    BOOL isExist = [WBDatabase createTableWithTitle:name];
    if (!isExist) {
        return false;
    }
    
    FMResultSet *result = [db executeQuery:sql];
    //总数
    int count = 0;
    if ([result next]) {
        count = [result intForColumnIndex:0];
    }
    
    return count == 0 ? false : true;
    
}

//获取model
+ (BookChapModel *)getDataWithTableName:(NSString *)tableName WithChapName:(NSString *)chapTitle{
    FMDatabase *db = [WBDatabase shareDB];
    [db open];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE chapTitle = '%@'",tableName,chapTitle];
    FMResultSet *result = [db executeQuery:sql];
    BookChapModel *model = nil;
    while([result next]) {
        //有数据则初始化
        model = [[BookChapModel alloc]init];
        NSString *chapTitle = [result stringForColumn:@"chapTitle"];
        NSString *chapContent = [result stringForColumn:@"chapContent"];
        NSString *pre = [result stringForColumn:@"pre"];
        NSString *next = [result stringForColumn:@"next"];
        NSString *chapId = [result stringForColumn:@"chapId"];
        model.chapId = chapId;
        model.chapTitle = chapTitle;
        model.pre = pre;
        model.next = next;
        model.chapContent = chapContent;
    }
    [result close];
    return model;
}

//根据url获取model
+ (BookChapModel *)getDataWithUrl:(NSString *)url WithTableName:(NSString *)tableName{
    FMDatabase *db = [WBDatabase shareDB];
    [db open];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE current = '%@'",tableName,url];
    FMResultSet *result = [db executeQuery:sql];
    BookChapModel *model = nil;
    while([result next]) {
        //如果有数据则初始化
        model = [[BookChapModel alloc]init];
        NSString *chapTitle = [result stringForColumn:@"chapTitle"];
        NSString *chapContent = [result stringForColumn:@"chapContent"];
        NSString *pre = [result stringForColumn:@"pre"];
        NSString *next = [result stringForColumn:@"next"];
        NSString *chapId = [result stringForColumn:@"chapId"];
        NSString *current = [result stringForColumn:@"current"];
        model.chapId = chapId;
        model.chapTitle = chapTitle;
        model.pre = pre;
        model.next = next;
        model.chapContent = chapContent;
        model.current = current;
    }
    [result close];
    return model;
    
}

@end








