//
//  WBUtil+WBTableViewCell.h
//  ylwj_User
//
//  Created by wayneking on 3/16/17.
//  WBTableViewCell的扩展

#import "WBUtil.h"
#import "WBTableViewCell.h"

@interface WBUtil (WBTableViewCell)
/**
 返回WBTableViewCell
 
 @param title 左边的标题
 @param placeholder 右边的说明--placeHolder
 @param canBeInput 右边的textField是否可以点击
 @param vc 谁为代理
 @return 返回WBTableViewCell
 */
+(WBTableViewCell *)createWBCellWithTitle:(NSString *)title WithPlaceholder:(NSString *)placeholder CanBeInput:(BOOL) canBeInput delegate:(id)vc;

@end
