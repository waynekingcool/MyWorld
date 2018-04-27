//
//  WBUtil+WBTableViewCell.m
//  ylwj_User
//
//  Created by wayneking on 3/16/17.
//

#import "WBUtil+WBTableViewCell.h"

@implementation WBUtil (WBTableViewCell)
+(WBTableViewCell *)createWBCellWithTitle:(NSString *)title WithPlaceholder:(NSString *)placeholder CanBeInput:(BOOL) canBeInput delegate:(id)vc{
    WBTableViewCell *cell = [[WBTableViewCell alloc]initWithTitle:title WithPlaceholder:placeholder CanBeInput:canBeInput delegate:vc];
    return cell;
}
@end
