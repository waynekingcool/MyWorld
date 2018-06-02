//
//  WBHeaderRefresh.h
//  MyWorld
//
//  Created by wayneking on 2018/6/1.
//  Copyright © 2018年 wayneking. All rights reserved.
//  下拉刷新动画

#import <MJRefresh/MJRefresh.h>

@interface WBHeaderRefresh : MJRefreshHeader

@property(nonatomic,strong) UIBezierPath *path;
@property(nonatomic,strong) UIColor *tintColor;

@end
