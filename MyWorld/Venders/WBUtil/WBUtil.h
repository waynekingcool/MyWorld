//
//  WBUtil.h
//  ylwj_User
//
//  Created by wayneking on 2/23/17.
//  Copyright © 2017 wayneking. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBUtil : NSObject
// 将度数转换为弧度
#define   RADIAN(degrees)  ((M_PI * (degrees))/ 180.f)

// 将弧度转换为度数
#define   DEGREES(radian)  ((radian) * 180.f / M_PI)

/**
 创建UILabel,默认左对齐
 
 @param text 文本内容
 @param size 字体大小
 @param color 字体颜色
 @return 返回UILabel
 */
+(UILabel *)createLabel:(NSString *)text FontSize:(CGFloat)size FontColor:(UIColor *)color;


/**
 创建UILabel

 @param text 文本内容
 @param size 字体大小
 @param color 字体颜色
 @param alignment 对齐方式
 @return 返回UILabel
 */
+(UILabel *)createLabel:(NSString *)text FontSize:(CGFloat)size FontColor:(UIColor *)color TextAlignment:(NSTextAlignment) alignment;

/**
 创建Button

 @param text button标题
 @param size 字体大小
 @param textColor 字体颜色
 @param bgColor 背景颜色
 @return 返回UIButton
 */
+(UIButton *)createButton:(NSString *)text TextSize:(CGFloat)size TextColor:(UIColor *)textColor BackgroundColor:(UIColor *)bgColor;


/**
 创建带有下划线的button

 @param text button标题
 @param size 字体大小
 @param textColor 字体颜色
 @return 返回带有下划线的button
 */
+(UIButton *)createUnderLineButton:(NSString *)text TextSize:(CGFloat)size TextColor:(UIColor *)textColor;


/**
 创建UITableView

 @param vc 代理
 @param style 分割线样式
 @param rowHeight 自适应的估计高度,如果为0,那么cell高度需要自己设置
 @param cellClass cell类
 @return 返回tableView
 */
+(UITableView *)createTableView:(id)vc SeparatorStyle:(UITableViewCellSeparatorStyle)style rowHeight:(CGFloat)rowHeight CellClass:(Class)cellClass;


/**
 返回UIImageView

 @param imageName 图片名称
 @param radius 圆角 如果为0则不设置圆角
 @return 返回UIImageView
 */
+(UIImageView *)createImageVIew:(NSString *)imageName CornRadius:(CGFloat)radius;


/**
 创建分割线

 @return 返回分割线view
 */
+(UIView *)createLineView;

/**
  创建分割线

 @param lineColor 颜色
 @return 返回分割线view
 */
+(UIView *)createLineView:(UIColor *)lineColor;

/**
 返回TextField

 @param placeHolder 占位符
 @param text 内容
 @param fontSize 字体大小
 @return 返回TextField
 */
+ (UITextField *)createTextField:(NSString *)placeHolder Text:(NSString *)text FontSize:(CGFloat)fontSize;


/**
 返回UIColor

 @param red 红
 @param green 绿
 @param blue 蓝
 @return 返回颜色
 */
+ (UIColor *)createColor:(CGFloat)red green:(CGFloat)green blue:(CGFloat )blue;



/**
 返回颜色

 @param hexString 16进制字符串
 @return 返回颜色
 */
+ (UIColor *)createHexColor:(NSString *)hexString;


/**
 根据颜色生成图片

 @param color 颜色
 @return 返回image
 */
+(UIImage*) createImageWithColor:(UIColor*) color;


/**
 同步延迟执行

 @param block 延迟执行的块
 @param sec 延迟时间
 */
+ (void)executeInMainQueen:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec;


/**
 异步延迟执行

 @param block 延迟执行的块
 @param sec 延迟时间
 */
+ (void)executeInGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec;


/**
 产生随机数

 @param from 起始值
 @param to 终点值
 @return 返回这个范围内的值
 */
+ (int)createRandom:(int)from to:(int)to;


/**
 随机字符串

 @return 返回字符串
 */
+(NSString *)returnRandomString:(int)count;
@end
