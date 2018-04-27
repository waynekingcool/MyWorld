//
//  NSMutableDictionary+ToJson.h
//  斜杠头条
//
//  Created by wayneking on 2018/4/17.
//  Copyright © 2018年 wayneking. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (ToJson)
/**
 *  字典转 json字符串
 *
 *  @return json字符串
 */
-(NSString *)dictionaryToJsonString;
@end
