//
//  NSMutableDictionary+ToJson.m
//  斜杠头条
//
//  Created by wayneking on 2018/4/17.
//  Copyright © 2018年 wayneking. All rights reserved.
//

#import "NSMutableDictionary+ToJson.h"

@implementation NSMutableDictionary (ToJson)
/**
 *  字典转 json字符串
 *
 *  @return json字符串
 */
-(NSString *)dictionaryToJsonString
{
    NSError *error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    
    if (error) {
        return nil;
    }
    
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
//    NSRange range3 = {0,mutStr.length};
//    //去掉字符串中的换行符
//    [mutStr replaceOccurrencesOfString:@"\"" withString:@"" options:NSLiteralSearch range:range3];
    return mutStr;
    
}

@end
