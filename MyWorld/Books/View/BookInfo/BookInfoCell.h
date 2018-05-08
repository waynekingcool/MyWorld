//
//  BookInfoCell.h
//  MyWorld
//
//  Created by wayneking on 2018/5/5.
//  Copyright © 2018年 wayneking. All rights reserved.
//  小说详情cell

#import <UIKit/UIKit.h>
#import "BookInfoChapModel.h"

@interface BookInfoCell : UITableViewCell
///章节
@property(nonatomic,strong) BookInfoChapModel *model;
@end
