//
//  BookInfoSectionView.m
//  MyWorld
//
//  Created by wayneking on 2018/5/5.
//  Copyright © 2018年 wayneking. All rights reserved.
//

#import "BookInfoSectionView.h"

@interface BookInfoSectionView()

@property(nonatomic,strong) UILabel *sectionLabel;

@end

@implementation BookInfoSectionView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    self.contentView.backgroundColor = ProtectEyeColor;
    
    self.sectionLabel = [WBUtil createLabel:@"暂无标题" FontSize:16 FontColor:[UIColor blackColor]];
    [self addSubview:self.sectionLabel];
    [self.sectionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(margin);
    }];
    
}

-(void)setSectionTitle:(NSString *)sectionTitle{
    _sectionTitle = sectionTitle;
    self.sectionLabel.text = sectionTitle;
}

@end
