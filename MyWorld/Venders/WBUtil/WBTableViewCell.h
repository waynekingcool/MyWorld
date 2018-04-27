//
//  WBTableViewCell.h
//  ylwj_User
//
//  Created by wayneking on 3/16/17.
//  Copyright © 2017 wayneking. All rights reserved.
//  表单cell的封装

#import <UIKit/UIKit.h>
@class WBTableViewCell;
@protocol WBTableViewCellDelegate <NSObject>

- (void)touchWBTableViewCell:(WBTableViewCell *)cell;

@end

@interface WBTableViewCell : UIView
//textField的值
@property(nonatomic,copy)NSString *string;
@property(nonatomic,weak)id<WBTableViewCellDelegate> delegate;
@property(nonatomic,strong) UITextField *textField;
//title颜色
@property (nonatomic,strong) UIColor *titleColor;

/**
 返回WBTableViewCell

 @param title 左边的标题
 @param placeholder 右边的说明--placeHolder
 @param canBeInput 右边的textField是否可以点击
 @param vc 谁为代理
 @return 返回WBTableViewCell
 */
-(instancetype)initWithTitle:(NSString *)title WithPlaceholder:(NSString *)placeholder CanBeInput:(BOOL) canBeInput delegate:(id)vc;

//隐藏箭头
- (void)hideArrow:(BOOL)hidden;
@end
