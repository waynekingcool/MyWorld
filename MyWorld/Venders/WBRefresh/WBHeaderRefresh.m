//
//  WBHeaderRefresh.m
//  MyWorld
//
//  Created by wayneking on 2018/6/1.
//  Copyright © 2018年 wayneking. All rights reserved.
//

#import "WBHeaderRefresh.h"
#import "FBShimmeringView.h"

@interface WBHeaderRefresh()

@property(nonatomic,strong) UIView *animatedView;
@property(nonatomic,strong) CAShapeLayer *shapeLayer;
@property(nonatomic,strong) CAEmitterLayer *refreshingLayer;
@property(nonatomic,strong) FBShimmeringView *shimmeringView;
@end

@implementation WBHeaderRefresh

#pragma mark - 重写方法
-(void)prepare{
    [super prepare];
    
    self.clipsToBounds = YES;
    if (self.tintColor == nil) {
        self.tintColor = [UIColor orangeColor];
    }
    
    self.shimmeringView = [[FBShimmeringView alloc] initWithFrame:CGRectMake(0, 0, 300, 60)];
    self.shimmeringView.center = CGPointMake(screenWidth/2.0, 25);
    [self addSubview:self.shimmeringView];
    
    UILabel *label = [[UILabel alloc]init];
    label.layer.cornerRadius = 20;
    label.layer.masksToBounds = YES;
    label.text = @"My World";
    label.frame = self.shimmeringView.bounds;
    label.font =  [UIFont systemFontOfSize:40 weight:5];
    label.textColor = [WBUtil createHexColor:@"#00456b"];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor clearColor];
    self.shimmeringView.contentView = label;
    self.shimmeringView.shimmering = YES;
}

- (void)placeSubviews{
    [super placeSubviews];
    
    self.animatedView.bounds = CGRectMake(0, 0, 50, 50);
    self.animatedView.center = CGPointMake(self.mj_w*0.5, self.mj_h*0.5);
//    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:self.animatedView.bounds];
//    if (self.path != nil && !self.path.isEmpty) {
//        path = self.path;
//    }else{
//        //画笑脸
//        [path moveToPoint:CGPointMake(15, 20)];
//        [path addArcWithCenter:CGPointMake(15, 20) radius:2 startAngle:0 endAngle:2 * M_PI clockwise:YES];
//        [path moveToPoint:CGPointMake(35, 20)];
//        [path addArcWithCenter:CGPointMake(35, 20) radius:2 startAngle:0 endAngle:2 * M_PI clockwise:YES];
//        [path moveToPoint:CGPointMake(15, 30)];
//        [path addQuadCurveToPoint:CGPointMake(35, 30) controlPoint:CGPointMake(25, 40)];
//    }
//    self.shapeLayer.path = path.CGPath;
    
    self.refreshingLayer.frame = CGRectMake(0, self.mj_h, self.mj_w, self.mj_h);
    self.refreshingLayer.emitterPosition = CGPointMake(self.animatedView.bounds.size.width*0.5, 0);
    self.refreshingLayer.emitterSize = CGSizeMake(self.mj_w, self.animatedView.bounds.size.height);
    [self addSubview:self.animatedView];
    [self.animatedView.layer addSublayer:self.shapeLayer];
    [self.animatedView.layer addSublayer:self.refreshingLayer];
    
}

-(void)setState:(MJRefreshState)state{
    MJRefreshCheckState
    //根据状态做事
    [super setState:state];
    if (state == 1) { //刷新完成
        [self stopAnimation];
    } else if (state == 2) {
        self.shapeLayer.strokeEnd = 1;
    } else if (state == 3) {
        [self startAnimation];
    }
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];
    self.shapeLayer.strokeEnd = self.pullingPercent;;
}

- (void)startAnimation{
    self.refreshingLayer.hidden = NO;
    self.shapeLayer.hidden = YES;
}

- (void)stopAnimation{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.refreshingLayer.hidden = YES;
        self.shapeLayer.hidden = NO;
    });
}

#pragma mark - Getter And Setter
- (UIView *)animatedView{
    if (!_animatedView) {
        _animatedView = [[UIView alloc]init];
        _animatedView.backgroundColor = [UIColor clearColor];
    }
    return _animatedView;
}

-(CAShapeLayer *)shapeLayer{
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;
        _shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
        _shapeLayer.lineWidth = 2.5;
        _shapeLayer.lineCap = kCALineCapRound;
    }
    return _shapeLayer;
}

-(CAEmitterLayer *)refreshingLayer{
    if (!_refreshingLayer) {
        _refreshingLayer = [CAEmitterLayer layer];
        //粒子叠加显示
        _refreshingLayer.renderMode = kCAEmitterLayerAdditive;
        //粒子发射点形状
        _refreshingLayer.emitterShape = kCAEmitterLayerRectangle;
        _refreshingLayer.emitterCells = @[[self getEmitterCell]];
    }
    return _refreshingLayer;
}

- (CAEmitterCell *)getEmitterCell{
    CAEmitterCell *cell = [[CAEmitterCell alloc]init];
    CGFloat colorChangeValue = 1;
    cell.blueRange = colorChangeValue;
    cell.redRange = colorChangeValue;
    cell.greenRange = colorChangeValue;

    cell.birthRate = 5; //每秒生成的粒子数量
    cell.speed = 5.f;   //粒子发射器的粒子数量
    cell.velocity = -20.f;  //粒子的移动速度
    cell.velocityRange = -40.f; //粒子速度的范围
    cell.yAcceleration = -20.f;
    cell.emissionRange = M_PI;
    cell.contents = (__bridge id _Nullable)([UIImage imageNamed:@"bubble"].CGImage);
    cell.lifetime = 15;
    cell.lifetimeRange = 20;
    cell.scale = 0.1;
    cell.scaleRange = 0.3;

    return cell;
}

-(void)setTintColor:(UIColor *)tintColor{
    _tintColor = tintColor;
    self.shapeLayer.strokeColor = tintColor.CGColor;
}

@end
