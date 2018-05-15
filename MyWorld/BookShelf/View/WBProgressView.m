//
//  WBProgressView.m
//  MyWorld
//
//  Created by wayneking on 2018/5/15.
//  Copyright © 2018年 wayneking. All rights reserved.
//

#import "WBProgressView.h"
#import <YLProgressBar/YLProgressBar.h>

@interface WBProgressView()
///进度条
@property(nonatomic,strong) YLProgressBar *progressBar;
///进度
@property(nonatomic,strong) UILabel *progressLabel;

@end

@implementation WBProgressView

-(instancetype)init{
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 5.f;
    self.layer.masksToBounds = YES;
    
    [self addSubview:self.progressBar];
    [self.progressBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX).offset(0);
        make.centerY.mas_equalTo(self.mas_centerY).offset(-10);
        make.height.mas_equalTo(14);
        make.width.mas_equalTo(200);
    }];
    
    self.progressLabel = [WBUtil createLabel:@"" FontSize:16 FontColor:[UIColor blackColor]];
    self.progressLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.progressLabel];
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX).offset(0);
        make.top.mas_equalTo(self.progressBar.mas_bottom).offset(10);
    }];
    
    self.transform = CGAffineTransformMakeScale(0.1, 0.1);
}

- (void)show{
    [UIView animateWithDuration:0.5 animations:^{
        [self setHidden: NO];
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
}

- (void)hide{
    [UIView animateWithDuration:0.5 animations:^{
        self.transform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:^(BOOL finished) {
        [self setHidden:YES];
    }];
}

#pragma mark - Getter And Setter
-(YLProgressBar *)progressBar{
    if (!_progressBar) {
        _progressBar = [[YLProgressBar alloc]init];
        _progressBar.progressTintColor = [WBUtil createColor:176 green:224 blue:230];
        _progressBar.type = YLProgressBarTypeRounded;
        _progressBar.trackTintColor = [UIColor whiteColor];
        _progressBar.stripesOrientation = YLProgressBarStripesOrientationVertical;
        _progressBar.stripesDirection = YLProgressBarStripesDirectionRight;
        _progressBar.indicatorTextDisplayMode = YLProgressBarIndicatorTextDisplayModeFixedRight;
        _progressBar.behavior = YLProgressBarBehaviorIndeterminate;
        _progressBar.uniformTintColor = YES;
        _progressBar.indicatorTextLabel.font  = [UIFont fontWithName:@"Arial-BoldMT" size:20];
        _progressBar.layer.borderColor = [WBUtil createColor:242 green:150 blue:0].CGColor;
        _progressBar.layer.cornerRadius = 7.f;
        _progressBar.layer.masksToBounds = YES;
        _progressBar.layer.borderWidth = 1.f;
        [_progressBar setProgress:0.0];
    }
    return _progressBar;
}

-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    NSNumber *finish = (NSNumber *)dataDic[@"finish"];
    NSNumber *all = (NSNumber *)dataDic[@"all"];
    
    CGFloat progress = [finish floatValue]/ [all floatValue];
    [self.progressBar setProgress:progress animated:YES];
    if ([finish isEqual:all]) {
        self.progressLabel.text = @"所有下载已完成";
        [self hide];
        [CCProgressHUD showMessageInAFlashWithMessage:@"所有下载已完成"];
    }else{
        self.progressLabel.text = [NSString stringWithFormat:@"已完成:  %ld / %ld",[finish integerValue],[all integerValue]];
    }
    
    
}


@end
