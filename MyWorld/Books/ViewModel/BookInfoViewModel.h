//
//  BookInfoViewModel.h
//  MyWorld
//
//  Created by wayneking on 2018/5/5.
//  Copyright © 2018年 wayneking. All rights reserved.
//  小说详情viewModel

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
//model
#import "BookInfoModel.h"
#import "BookInfoChapModel.h"
#import "BookRecordModel.h"

@interface BookInfoViewModel : NSObject

///获取数据
@property(nonatomic,strong) RACCommand *fetchDataCommadn;
///最新章节
@property(nonatomic,strong) NSMutableArray *lastArray;
///全部章节
@property(nonatomic,strong) NSMutableArray *allArray;
///小说model
@property(nonatomic,strong) BookInfoModel *model;

///获取章节数
- (NSInteger)getChapCount:(NSInteger)section;
///获取model
- (BookInfoChapModel *)getModelWIthSection:(NSInteger)section WithRow:(NSInteger)row;
///获取章节url
- (NSURL *)getChapUrlWithSection:(NSInteger)section WithRow:(NSInteger)row;
///获取章节名称
- (NSString *)getChapTitleWithSection:(NSInteger)section WithRow:(NSInteger)row;
///将书籍保存到书架
- (NSString *)saveBookToShelf;
@end
