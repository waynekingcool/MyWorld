//
//  WBProgressView.h
//  MyWorld
//
//  Created by wayneking on 2018/5/15.
//  Copyright © 2018年 wayneking. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBProgressView : UIView

///包含已完成 和 总数
@property(nonatomic,assign) NSDictionary *dataDic;

///显示
- (void)show;
///隐藏
- (void)hide;

@end
