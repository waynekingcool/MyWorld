//
//  WebBookViewModel.h
//  MyWorld
//
//  Created by wayneking on 2018/5/7.
//  Copyright © 2018年 wayneking. All rights reserved.
//  web小说viewModel

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
//model
#import "BookChapModel.h"

@interface WebBookViewModel : NSObject

///获取内容
@property(nonatomic,strong) RACCommand *fetchContentCommad;
///model
@property(nonatomic,strong) BookChapModel *model;


///根据页数返回内容
- (NSString *)getContentWithPage:(NSInteger)page;
@end
