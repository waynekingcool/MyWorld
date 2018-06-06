//
//  WBDownloadItem.h
//  MyWorld
//
//  Created by wayneking on 2018/6/6.
//  Copyright © 2018年 wayneking. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, WBDownloadState){
    WBDownloadStateNormal,  //默认状态 不会下载
    WBDownloadStateWait,    //等待下载
    WBDownloadStateLoading, //正在下载
    WBDownloadStatePaused,  //下载暂停
    WBDownloadStateProcess, //定制处理
    WBDownloadStateComplete,    //下载完成
    WBDownloadStateError,   //下载失败
};

//黑魔法 该宏表示为非空的开始
NS_ASSUME_NONNULL_BEGIN

@protocol WBDownloadItem <NSObject>

@optional
///下载进度, 支持KVO
@property(nonatomic, assign) double wb_downloadProgress;
///下载状态,支持KVO,该属性的值由WBDownloader维护,调用 SODownloader 类的下载相关方法可以使该属性值改变，不要自己修改这个属性的值。
@property(nonatomic, assign) WBDownloadState wb_downloadState;
///下载速度,单位是字节/秒
@property(nonatomic, assign) NSUInteger wb_downloadSpeed;
///当下载失败时,此属性保存失败错误对象
@property(nonatomic,strong,nullable) NSError *wb_downloadError;

@required
///返回下载对应的下载地址
- (NSURL *)wb_downloadURL;

@end

@interface WBDownloadItem : NSObject<WBDownloadItem>

@end

//黑魔法 该宏表示为非空的结束
NS_ASSUME_NONNULL_END
