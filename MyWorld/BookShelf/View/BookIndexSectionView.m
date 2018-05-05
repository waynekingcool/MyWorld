//
//  BookIndexSectionView.m
//  MyWorld
//
//  Created by wayneking on 2018/5/4.
//  Copyright © 2018年 wayneking. All rights reserved.
//

#import "BookIndexSectionView.h"

@interface BookIndexSectionView()

@property(nonatomic,strong) UILabel *titleLabel;

@end

@implementation BookIndexSectionView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.titleLabel = [WBUtil createLabel:@"暂无标题" FontSize:17 FontColor:[UIColor blackColor]];
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY).offset(0);
            make.left.mas_equalTo(self.mas_left).offset(margin);
        }];
    }
    return self;
}



-(void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    self.titleLabel.text = titleStr;
}

@end
