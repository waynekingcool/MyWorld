//
//  BookViewModel.h
//  MyWorld
//
//  Created by wayneking on 2018/4/28.
//  Copyright © 2018年 wayneking. All rights reserved.
//  本地小说viewModel

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
//model
#import "BookModel.h"
#import "BookChapModel.h"

@interface BookViewModel : NSObject
///小说model
@property(nonatomic,strong) BookModel *model;

///获取小说内容
@property(nonatomic,strong) RACCommand *fetchContentCommand;


///根据章和页数返回内容
- (NSString *)getContentWithChap:(NSInteger)chap Page:(NSInteger)page;
@end
