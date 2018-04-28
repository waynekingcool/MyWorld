//
//  BookReadView.m
//  MyWorld
//
//  Created by wayneking on 2018/4/28.
//  Copyright © 2018年 wayneking. All rights reserved.
//

#import "BookReadView.h"

#define ViewSize(view)  (view.frame.size)
@interface BookReadView()

@property(nonatomic,strong) NSArray *pathArray;
//滑动有效区间
@property(nonatomic, assign) CGRect leftRect;
@property(nonatomic, assign) CGRect rightRect;

@end

@implementation BookReadView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}


-(void)drawRect:(CGRect)rect{
    if (!self.frameRef) {
        return;
    }
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //倒置
    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
    CGContextTranslateCTM(ctx, 0, self.bounds.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    
//    CGRect leftDot, rightDoc = CGRectZero;
//    [self drawSelectedPath:self.pathArray LeftDot:&leftDot RightDot:&rightDoc];
    CTFrameDraw(self.frameRef, ctx);
    //xx
//    [self drawDotWithLeft:leftDot right:rightDoc];
}

- (void)drawSelectedPath:(NSArray *)array LeftDot:(CGRect *)leftDot RightDot:(CGRect *)rightDot{
    CGMutablePathRef path = CGPathCreateMutable();
    [[UIColor cyanColor] setFill];
    for (int i = 0; i < array.count; i++) {
        CGRect rect = CGRectFromString([array objectAtIndex:i]);
        CGPathAddRect(path, NULL, rect);
        if (i == 0) {
            *leftDot = rect;
        }
        
        if (i == array.count-1) {
            *rightDot = rect;
        }
    }
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddPath(ctx, path);
    CGContextFillPath(ctx);
    CGPathRelease(path);
}

-(void)drawDotWithLeft:(CGRect)Left right:(CGRect)right
{
    if (CGRectEqualToRect(CGRectZero, Left) || (CGRectEqualToRect(CGRectZero, right))){
        return;
    }
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGMutablePathRef _path = CGPathCreateMutable();
    [[UIColor orangeColor] setFill];
    CGPathAddRect(_path, NULL, CGRectMake(CGRectGetMinX(Left)-2, CGRectGetMinY(Left),2, CGRectGetHeight(Left)));
    CGPathAddRect(_path, NULL, CGRectMake(CGRectGetMaxX(right), CGRectGetMinY(right),2, CGRectGetHeight(right)));
    CGContextAddPath(ctx, _path);
    CGContextFillPath(ctx);
    CGPathRelease(_path);
    CGFloat dotSize = 15;
    _leftRect = CGRectMake(CGRectGetMinX(Left)-dotSize/2-10, ViewSize(self).height-(CGRectGetMaxY(Left)-dotSize/2-10)-(dotSize+20), dotSize+20, dotSize+20);
    _rightRect = CGRectMake(CGRectGetMaxX(right)-dotSize/2-10,ViewSize(self).height- (CGRectGetMinY(right)-dotSize/2-10)-(dotSize+20), dotSize+20, dotSize+20);
    CGContextDrawImage(ctx,CGRectMake(CGRectGetMinX(Left)-dotSize/2, CGRectGetMaxY(Left)-dotSize/2, dotSize, dotSize),[UIImage imageNamed:@"r_drag-dot"].CGImage);
    CGContextDrawImage(ctx,CGRectMake(CGRectGetMaxX(right)-dotSize/2, CGRectGetMinY(right)-dotSize/2, dotSize, dotSize),[UIImage imageNamed:@"r_drag-dot"].CGImage);
}
@end
