//
//  BookModel.h
//  MyWorld
//
//  Created by wayneking on 2018/4/28.
//  Copyright © 2018年 wayneking. All rights reserved.
//  小说model

#import <Foundation/Foundation.h>
//model
#import "BookChapModel.h"

@interface BookModel : NSObject

@property(nonatomic,strong) NSMutableArray *chapArray;
///标题数组
@property(nonatomic,strong) NSMutableArray *chapTitleArray;

@end
