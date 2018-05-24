//
//  WBDatabase.m
//  MyWorld
//
//  Created by wayneking on 2018/5/9.
//  Copyright © 2018年 wayneking. All rights reserved.
//

#import "WBDatabase.h"
#import "BookRecordModel.h"

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
        NSString *sqlStr = @"";
        if ([title isEqualToString:@"BookShelf"]) {
            sqlStr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS BookShelf (title text,picUrl text,recordTitle text,url text);"];
        }else{
            sqlStr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (chapTitle text,chapContent text,pre text,next text,chapId INTEGER,current text);",title];
        }
        
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
    [db open];
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
    [db close];
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

//将书添加到书架
+ (BOOL)saveBookToShelf:(BookToShelfModel *)model{
    FMDatabase *db = [WBDatabase shareDB];
    [db open];
    NSString *sqlStr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS BookShelf (title text,picUrl text,recordTitle text,url text);"];
    BOOL result = [db executeUpdate:sqlStr];
    if (result) {
        
        //检测是否已经有数据
        NSString *querySql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM BookShelf WHERE title = '%@'",model.title];
        FMResultSet *setResult = [db executeQuery:querySql];
        //总数
        int count = 0;
        if ([setResult next]) {
            count = [setResult intForColumnIndex:0];
        }
        
        if (count == 0) {
            //不存在 则插入
            //将数据插入
            NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO BookShelf (title,picUrl,recordTitle,url) VALUES ('%@','%@','%@','%@');",model.title,model.picUrl,model.recordTitle,model.url];
            BOOL result = [db executeUpdate:insertSql];
            [db close];
            if (result) {
                WBLog(@"插入成功:%@",model.title);
                return true;
            }else{
                WBLog(@"插入失败:%@",model.title);
                return false;
            }
        }else{
            //存在
            return false;
        }
        
    }else{
        WBLog(@"表创建失败");
        return false;
    }
}

//获取书架数据
+ (NSArray *)loadBookToShelf{
    FMDatabase *db = [WBDatabase shareDB];
    WBLog(@"%@",DBPath);
    [db open];
    //判断表是否存在
    NSString *sqlStr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS BookShelf (title text,picUrl text,recordTitle text,url text);"];
    BOOL result = [db executeUpdate:sqlStr];
    if (result) {
//        WBLog(@"表BookShelf不已创建");
    }else{
        WBLog(@"表BookShelf创建失败");
    }
    
    NSString *sqlStr2 = @"SELECT * FROM BookShelf";
    FMResultSet *set = [db executeQuery:sqlStr2];
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    while ([set next]) {
        BookToShelfModel *model = [[BookToShelfModel alloc]init];
        model.title = [set stringForColumn:@"title"];
        model.picUrl = [set stringForColumn:@"picUrl"];
        
        //获取实时记录
        NSString *filePath = [RecordPath stringByAppendingPathComponent:model.title];
        BookRecordModel *recordModel = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        if (recordModel) {
            //有阅读记录
            model.recordTitle = recordModel.recordChap;
        }else{
            //从第一章开始
            model.recordTitle = @"无阅读记录";
        }
        
        model.url = [set stringForColumn:@"url"];
        [dataArray addObject:model];
    }
    [set close];
    return [dataArray copy];

}

@end








