//
//  WebBookToolView.m
//  MyWorld
//
//  Created by wayneking on 2018/5/24.
//  Copyright © 2018年 wayneking. All rights reserved.
//

#import "WebBookToolView.h"

@implementation WebBookToolView

-(instancetype)init{
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    self.backgroundColor = [UIColor whiteColor];
    
    UIButton *downButton = [WBUtil createButton:@"" TextSize:15 TextColor:[UIColor blackColor] BackgroundColor:[UIColor clearColor]];
    [downButton setImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];
    [self addSubview:downButton];
    @weakify(self);
    [[downButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (self_weak_.downSubject) {
            [self_weak_.downSubject sendNext:@""];
        }
    }];
    [downButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(5);
        make.left.mas_equalTo(self.mas_left).offset(margin);
        make.width.height.mas_equalTo(40);
    }];
    
}

@end
