//
//  HomeCell.h
//  MyWorld
//
//  Created by wayneking on 2018/4/27.
//  Copyright © 2018年 wayneking. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCell : UITableViewCell
@property(nonatomic,strong) UIImageView *articleImageView;      //小说封面
@property(nonatomic,strong) UILabel *articleLabel;      //小说名称
@property(nonatomic,strong) UILabel *authorLabel;   //作者
@end
