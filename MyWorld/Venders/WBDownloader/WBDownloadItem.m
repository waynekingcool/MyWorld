//
//  WBDownloadItem.m
//  MyWorld
//
//  Created by wayneking on 2018/6/6.
//  Copyright © 2018年 wayneking. All rights reserved.
//

#import "WBDownloadItem.h"

@implementation WBDownloadItem
@synthesize wb_downloadState, wb_downloadProgress;

-(NSURL *)wb_downloadURL{
    NSAssert(NO, @"[WBDownloader]:Your download item class must implements -(NSURL *)downloadURL method declare in protocol WBDownloadItem");
    return nil;
}


@end
