//
//  BookChapListCell.h
//  MyWorld
//
//  Created by wayneking on 2018/5/8.
//  Copyright © 2018年 wayneking. All rights reserved.
//  小说章节列表cell

#import <UIKit/UIKit.h>

@interface BookChapListCell : UITableViewCell
///标题
@property(nonatomic,copy) NSString *title;
///是否选中
@property(nonatomic, assign) BOOL isSelect;

@end
