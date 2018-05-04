//
//  WBNetWorkTool.m
//  广生盈
//
//  Created by wayneking on 18/10/2017.
//  Copyright © 2017 wayneking. All rights reserved.
//

#import "WBNetWorkTool.h"
#import <SAMKeychain/SAMKeychain.h>
#import <sys/utsname.h>


@implementation WBNetWorkTool

-(NSString *)getDataWithAct:(NSString *)act params:(NSMutableDictionary *)params start:(void (^)(void))startBlock fail:(void (^)(NSError *))failBlock success:(void (^)(NSDictionary *))successBlock{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    //请求超时30秒
    manager.requestSerializer.timeoutInterval = 30.f;
    //ContentTypes类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/html",@"application/json", @"text/json",@"application/xml",@"application/x-www-form-urlencoded",@"application/xhtml+xml",@"image/png",nil];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@",BaseUrl,act];
    startBlock();
    [manager GET:URL parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
        //请求进度
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //成功
        NSData *data = responseObject;
        NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        //回传数据
        successBlock(info);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //失败
        failBlock(error);
    }];
    
    return [NSString stringWithFormat:@"Get请求的接口地址%@",manager.baseURL];
}

-(NSString *)postDataWithAct:(NSString *)act params:(NSMutableDictionary *)params start:(void (^)(void))startBlock fail:(void (^)(NSError *))failBlock success:(void (^)(NSDictionary *))successBlock{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
//    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    //请求超时30秒
    manager.requestSerializer.timeoutInterval = 30.f;
    //ContentTypes类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/html",@"application/json", @"text/json",@"application/xml",@"application/x-www-form-urlencoded",@"application/xhtml+xml",nil];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@",BaseUrl,act];
    [manager POST:URL parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //请求进度
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //成功
        NSData *data = responseObject;
        NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        //回传数据
        successBlock(info);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //失败
        failBlock(error);
    }];
    
     return [NSString stringWithFormat:@"Post请求的接口地址%@",manager.baseURL];
}

-(NSString *)postDataWithActString:(NSString *)act params:(NSMutableDictionary *)params start:(void (^)(void))startBlock fail:(void (^)(NSError *))failBlock success:(void (^)(NSDictionary *))successBlock{    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    //请求超时30秒
    manager.requestSerializer.timeoutInterval = 30.f;
    //ContentTypes类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/html",@"application/json", @"text/json",@"application/xml",@"application/x-www-form-urlencoded",@"application/xhtml+xml",nil];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@",BaseUrl,act];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST"URLString:URL parameters:nil error:nil];

    [request addValue:@"application/json"forHTTPHeaderField:@"Content-Type"];

    NSString *string = [params mj_JSONString];
    NSData *body  =[string dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:body];
    //注册来源 1.移动设备 2.网页 3.其他来源
    [request setValue:@"1" forHTTPHeaderField:@"regFrom"];
    //设备系统  1 安卓  2 ios
    [request setValue:@"2" forHTTPHeaderField:@"deviceOs"];
    //设备ID
    [request setValue:[self getDeviceId] forHTTPHeaderField:@"deviceId"];
    //设备型号
    [request setValue:[self iphoneType] forHTTPHeaderField:@"deviceType"];
    
    
    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if(!error){
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            successBlock(dic);
        }else{
            failBlock(error);
        }
    }] resume];
    
    return @"";
}


-(NSString *)deleteDataWithActString:(NSMutableDictionary *)act params:(NSString *)params headJson:(NSString *)headJson start:(void (^)(void))startBlock fail:(void (^)(NSError *))failBlock success:(void (^)(NSDictionary *))successBlock{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    //请求超时30秒
    manager.requestSerializer.timeoutInterval = 30.f;
    //ContentTypes类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/html",@"application/json", @"text/json",@"application/xml",@"application/x-www-form-urlencoded",@"application/xhtml+xml",nil];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@",BaseUrl,act];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"DELETE"URLString:URL parameters:nil error:nil];
    
    [request addValue:@"application/json"forHTTPHeaderField:@"Content-Type"];
    
    NSString *string = [params mj_JSONString];
    NSData *body  =[string dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:body];
    //注册来源 1.移动设备 2.网页 3.其他来源
    [request setValue:@"1" forHTTPHeaderField:@"regFrom"];
    //设备系统  1 安卓  2 ios
    [request setValue:@"2" forHTTPHeaderField:@"deviceOs"];
    //设备ID
    [request setValue:[self getDeviceId] forHTTPHeaderField:@"deviceId"];
    //设备型号
    [request setValue:[self iphoneType] forHTTPHeaderField:@"deviceType"];
    //....
    [request setValue:headJson forHTTPHeaderField:@"token"];
    
    
    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if(!error){
            successBlock(dic);
        }else{
            failBlock(error);
        }
    }] resume];
    
    return @"";
}


- (void)uploadDataWithAct:(NSString *)act data:(NSData *)data start:(void (^)(void))startBlock fail:(void (^)(NSError *))failBlock success:(void (^)(NSDictionary *))successBlock progress:(void(^)(NSString *))progress{
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
     AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"multipart/form-data; boundary=wfWiEWrgEFA9A78512weF7106A; name=\"file\"" forHTTPHeaderField:@"Content-Type"];
    
    //NSString *URL = [NSString stringWithFormat:@"%@%@",BaseUrl,act];
    //暂时先写死
    NSString *URL = @"http://47.96.179.253:8082/upload/uploadFile";

    NSURLSessionTask *uploadTastk = [manager POST:URL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //随机字符串
        NSString *randomStr = [WBUtil returnRandomString:10];
        
        [formData appendPartWithFileData:data name:@"file" fileName:[NSString stringWithFormat:@"%@.png",randomStr] mimeType:@"image/png"];

    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progress(uploadProgress.localizedDescription);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //回传数据
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         failBlock(error);
    }];
    
    [uploadTastk resume];
    
}

//获取设备id
- (NSString *)getDeviceId
{
    NSString * currentDeviceUUIDStr = [SAMKeychain passwordForService:@"com.xiegangApp.MomApp"account:@"uuid"];
    if (currentDeviceUUIDStr == nil || [currentDeviceUUIDStr isEqualToString:@""])
    {
        NSUUID * currentDeviceUUID  = [UIDevice currentDevice].identifierForVendor;
        currentDeviceUUIDStr = currentDeviceUUID.UUIDString;
        currentDeviceUUIDStr = [currentDeviceUUIDStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
        currentDeviceUUIDStr = [currentDeviceUUIDStr lowercaseString];
        [SAMKeychain setPassword: currentDeviceUUIDStr forService:@"com.xiegangApp.MomApp"account:@"uuid"];
    }
    return currentDeviceUUIDStr;
}


//获取设备型号
- (NSString*)iphoneType {
    
    //需要导入头文件：#import <sys/utsname.h>
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString*platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if([platform isEqualToString:@"iPhone1,1"])  return@"iPhone 2G";
    
    if([platform isEqualToString:@"iPhone1,2"])  return@"iPhone 3G";
    
    if([platform isEqualToString:@"iPhone2,1"])  return@"iPhone 3GS";
    
    if([platform isEqualToString:@"iPhone3,1"])  return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,2"])  return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,3"])  return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone4,1"])  return@"iPhone 4S";
    
    if([platform isEqualToString:@"iPhone5,1"])  return@"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,2"])  return@"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,3"])  return@"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone5,4"])  return@"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone6,1"])  return@"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone6,2"])  return@"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone7,1"])  return@"iPhone 6 Plus";
    
    if([platform isEqualToString:@"iPhone7,2"])  return@"iPhone 6";
    
    if([platform isEqualToString:@"iPhone8,1"])  return@"iPhone 6s";
    
    if([platform isEqualToString:@"iPhone8,2"])  return@"iPhone 6s Plus";
    
    if([platform isEqualToString:@"iPhone8,4"])  return@"iPhone SE";
    
    if([platform isEqualToString:@"iPhone9,1"])  return@"iPhone 7";
    
    if([platform isEqualToString:@"iPhone9,3"])  return@"iPhone 7";
    
    if([platform isEqualToString:@"iPhone9,2"])  return@"iPhone 7 Plus";
    
    if([platform isEqualToString:@"iPhone9,4"])  return@"iPhone 7 Plus";
    
    if([platform isEqualToString:@"iPhone10,1"]) return@"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,4"]) return@"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,2"]) return@"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,5"]) return@"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,3"]) return@"iPhone X";
    
    if([platform isEqualToString:@"iPhone10,6"]) return@"iPhone X";
    
    if([platform isEqualToString:@"iPod1,1"])  return@"iPod Touch 1G";
    
    if([platform isEqualToString:@"iPod2,1"])  return@"iPod Touch 2G";
    
    if([platform isEqualToString:@"iPod3,1"])  return@"iPod Touch 3G";
    
    if([platform isEqualToString:@"iPod4,1"])  return@"iPod Touch 4G";
    
    if([platform isEqualToString:@"iPod5,1"])  return@"iPod Touch 5G";
    
    if([platform isEqualToString:@"iPad1,1"])  return@"iPad 1G";
    
    if([platform isEqualToString:@"iPad2,1"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,2"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,3"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,4"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,5"])  return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,6"])  return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,7"])  return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad3,1"])  return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,2"])  return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,3"])  return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,4"])  return@"iPad 4";
    
    if([platform isEqualToString:@"iPad3,5"])  return@"iPad 4";
    
    if([platform isEqualToString:@"iPad3,6"])  return@"iPad 4";
    
    if([platform isEqualToString:@"iPad4,1"])  return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,2"])  return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,3"])  return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,4"])  return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,5"])  return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,6"])  return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,7"])  return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,8"])  return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,9"])  return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad5,1"])  return@"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,2"])  return@"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,3"])  return@"iPad Air 2";
    
    if([platform isEqualToString:@"iPad5,4"])  return@"iPad Air 2";
    
    if([platform isEqualToString:@"iPad6,3"])  return@"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,4"])  return@"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,7"])  return@"iPad Pro 12.9";
    
    if([platform isEqualToString:@"iPad6,8"])  return@"iPad Pro 12.9";
    
    if([platform isEqualToString:@"i386"])  return@"iPhone Simulator";
    
    if([platform isEqualToString:@"x86_64"])  return@"iPhone Simulator";
    
    return @"Iphone";
    
}


- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

@end
