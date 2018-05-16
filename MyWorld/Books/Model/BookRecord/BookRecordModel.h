//
//  BookRecordModel.h
//  MyWorld
//
//  Created by wayneking on 2018/5/16.
//  Copyright © 2018年 wayneking. All rights reserved.
//  小说阅读记录model

#import <Foundation/Foundation.h>

@interface BookRecordModel : NSObject<NSCopying,NSCoding>
///名称
@property(nonatomic,copy) NSString *recordTitle;
///章节
@property(nonatomic,copy) NSString *recordChap;
///章节第几页
@property(nonatomic,copy) NSString *recordPage;

@end
