//
//  WBNetWorkTool.h
//  广生盈
//
//  Created by wayneking on 18/10/2017.
//  Copyright © 2017 wayneking. All rights reserved.
//  封装了网络请求

#import <Foundation/Foundation.h>

@interface WBNetWorkTool : NSObject
/**
 获取接口数据的通用方法
 
 @param act 接口方法
 @param params 接口需要的参数
 @param startBlock 开始block
 @param failBlock 失败block
 @param successBlock 成功block
 @return 返回数据
 */
- (NSString *)getDataWithAct:(NSString *)act
                          params:(NSMutableDictionary *)params
                           start:(void(^)(void))startBlock
                            fail:(void(^)(NSError *error))failBlock
                         success:(void(^)(NSDictionary *data))successBlock;


/**
 Post请求获取接口数据
 
 @param act 接口方法
 @param params 接口需要的参数
 @param startBlock 开始block
 @param failBlock 失败block
 @param successBlock 成功block
 @return 返回数据
 */
- (NSString *)postDataWithAct:(NSString *)act
                       params:(NSMutableDictionary *)params
                        start:(void(^)(void))startBlock
                         fail:(void(^)(NSError *error))failBlock
                      success:(void(^)(NSDictionary *modelDict))successBlock;

/**
 Post请求获取接口数据,参数放到Body里
 
 @param act 接口方法
 @param params 接口需要的参数
 @param startBlock 开始block
 @param failBlock 失败block
 @param successBlock 成功block
 @return 返回数据
 */
-(NSString *)postDataWithActString:(NSString *)act
                            params:(NSMutableDictionary *)params
                             start:(void (^)(void))startBlock
                              fail:(void (^)(NSError *))failBlock
                           success:(void (^)(NSDictionary *))successBlock;

/**
 Delete请求获取接口数据,参数放到Body里
 
 @param act 接口方法
 @param params 接口需要的参数
 @param headJson 头包含的参数
 @param startBlock 开始block
 @param failBlock 失败block
 @param successBlock 成功block
 @return 返回数据
 */
-(NSString *)deleteDataWithActString:(NSString *)act
                              params:(NSMutableDictionary *)params
                            headJson:(NSString *)headJson
                               start:(void (^)(void))startBlock
                                fail:(void (^)(NSError *))failBlock
                             success:(void (^)(NSDictionary *))successBlock;


/**
 Post上传文件

 @param act 接口方法
 @param data 文件数据
 @param startBlock 开始block
 @param failBlock 失败block
 @param successBlock 成功block
 @param progress 上传进度
 */
- (void)uploadDataWithAct:(NSString *)act
                 data:(NSData *)data
                    start:(void (^)(void))startBlock
                     fail:(void(^)(NSError *))failBlock
                  success:(void(^)(NSDictionary *))successBlock
                 progress:(void(^)(NSString *))progress;
@end
