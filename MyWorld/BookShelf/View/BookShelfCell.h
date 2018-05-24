//
//  BookShelfCell.h
//  MyWorld
//
//  Created by wayneking on 2018/5/24.
//  Copyright © 2018年 wayneking. All rights reserved.
//  书架cell

#import <UIKit/UIKit.h>
#import "BookToShelfModel.h"

@interface BookShelfCell : UITableViewCell

@property(nonatomic,strong) BookToShelfModel *model;

@end
