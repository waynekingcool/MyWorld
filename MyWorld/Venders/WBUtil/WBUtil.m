//
//  WBUtil.m
//  ylwj_User
//
//  Created by wayneking on 2/23/17.
//  Copyright © 2017 wayneking. All rights reserved.
//

#import "WBUtil.h"

@implementation WBUtil
+(UILabel *)createLabel:(NSString *)text FontSize:(CGFloat)size FontColor:(UIColor *)color{
    UILabel *label = [[UILabel alloc]init];
    label.text = text;
    label.font = [UIFont systemFontOfSize:size];
    label.textColor = color;
    [label sizeToFit];
    label.textAlignment = NSTextAlignmentLeft;
    return label;
}

+(UILabel *)createLabel:(NSString *)text FontSize:(CGFloat)size FontColor:(UIColor *)color TextAlignment:(NSTextAlignment) alignment{
    UILabel *label = [[UILabel alloc]init];
    label.text = text;
    label.font = [UIFont systemFontOfSize:size];
    label.textColor = color;
    [label sizeToFit];
    label.textAlignment = alignment;
    return label;
}

+(UIButton *)createButton:(NSString *)text TextSize:(CGFloat)size TextColor:(UIColor *)textColor BackgroundColor:(UIColor *)bgColor{
    UIButton *button = [[UIButton alloc]init];
    [button setTitle:text forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:size];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    button.backgroundColor = bgColor;
    return button;
}

+(UIButton *)createUnderLineButton:(NSString *)text TextSize:(CGFloat)size TextColor:(UIColor *)textColor{
    UIButton *button = [[UIButton alloc]init];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:size] range:strRange];
    [str addAttribute:NSForegroundColorAttributeName value:textColor range:strRange];
    [button setAttributedTitle:str forState:UIControlStateNormal];
    return button;
}

+(UITableView *)createTableView:(id)vc SeparatorStyle:(UITableViewCellSeparatorStyle)style rowHeight:(CGFloat)rowHeight CellClass:(Class)cellClass{
    UITableView *tableView = [[UITableView alloc]init];
    tableView.delegate = vc;
    tableView.dataSource = vc;
    tableView.tableFooterView = [[UIView alloc]init];
    tableView.separatorStyle = style;
    if (rowHeight!=0) {
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = rowHeight;
    }
    [tableView registerClass:cellClass forCellReuseIdentifier:@"cell"];
    return tableView;
}

+(UIImageView *)createImageVIew:(NSString *)imageName CornRadius:(CGFloat)radius{
//    UIImageView *image = [[UIImageView alloc]init];
//    image.image = [UIImage imageNamed:imageName];
//    return image;
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:imageName];
    if (radius!=0) {
        imageView.layer.cornerRadius = radius;
        imageView.layer.masksToBounds = true;
    }
    return imageView;
}

+(UIView *)createLineView{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    //view.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3"];
    return view;
}

+(UIView *)createLineView:(UIColor *)lineColor{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = lineColor;
    return view;
}

+ (UITextField *)createTextField:(NSString *)placeHolder Text:(NSString *)text FontSize:(CGFloat)fontSize{
    UITextField *textField = [[UITextField alloc]init];
    textField.placeholder = placeHolder;
    textField.text = text;
    textField.font = [UIFont systemFontOfSize:fontSize];
    return textField;
}

+ (UIColor *)createColor:(CGFloat)red green:(CGFloat)green blue:(CGFloat )blue{
    UIColor *color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
    return color;
}

+(UIColor *)createHexColor:(NSString *)hexString{
    if ([hexString hasPrefix:@"0x"] || [hexString hasPrefix:@"0X"]) {
        hexString = [hexString substringFromIndex:2];
    } else if ([hexString hasPrefix:@"#"]) {
        hexString = [hexString substringFromIndex:1];
    }
    
    unsigned int value = 0;
    BOOL flag = [[NSScanner scannerWithString:hexString] scanHexInt:&value];
    if (NO == flag)
        return [UIColor clearColor];
    
    float r,g,b,a;
    a = 1.0;
    b = value & 0x0000FF;
    value = value >> 8;
    g = value & 0x0000FF;
    value = value >> 8;
    r = value;
    
    //return [UIColor colorWithDisplayP3Red:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a];
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
}

+(UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+(void)executeInMainQueen:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec{
    //检测block参数是否为空
    NSParameterAssert(block);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * sec), dispatch_get_main_queue(), block);
}

+(void)executeInGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec{
    NSParameterAssert(block);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * sec), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);

}

+(int)createRandom:(int)from to:(int)to{
    //+1,result is [from to]; else is [from, to)!!!!!!!t
    return (int)(from + (arc4random() % (to - from + 1)));
}

+(NSString *)returnRandomString:(int)count{
    
    char data[count];
    
    for (int x=0;x<count;data[x++] = (char)('A'+ (arc4random_uniform(26))));
    
    return [[NSString alloc] initWithBytes:data length:count encoding:NSUTF8StringEncoding];
}

+ (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

@end
