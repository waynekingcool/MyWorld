//
//  BookChapListCell.m
//  MyWorld
//
//  Created by wayneking on 2018/5/8.
//  Copyright © 2018年 wayneking. All rights reserved.
//

#import "BookChapListCell.h"

@interface BookChapListCell()
///章节标题
@property(nonatomic,strong) UILabel *chapTitleLabel;
///选中按钮
@property(nonatomic,strong) UIButton *selectButton;
///显示下载状态
@property(nonatomic,strong) UILabel *downLabel;
@end

@implementation BookChapListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)createUI{
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.chapTitleLabel = [WBUtil createLabel:@"章节标题" FontSize:14 FontColor:[UIColor blackColor]];
    [self.contentView addSubview:self.chapTitleLabel];
    [self.chapTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(margin);
        make.centerY.mas_equalTo(self.contentView.mas_centerY).offset(0);
    }];
    
    self.selectButton = [WBUtil createButton:@"" TextSize:15 TextColor:[UIColor blackColor] BackgroundColor:[UIColor whiteColor]];
    [self.selectButton setImage:[UIImage imageNamed:@"Icon-remember_login_"] forState:UIControlStateNormal];
    [self.selectButton setImage:[UIImage imageNamed:@"Icon-remember-pre_login_"] forState:UIControlStateSelected];
    [self.contentView addSubview:self.selectButton];
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-margin);
        make.centerY.mas_equalTo(self.contentView.mas_centerY).offset(0);
        make.height.mas_equalTo(49);
        make.width.mas_equalTo(50);
    }];
    
    self.downLabel = [WBUtil createLabel:@"已下载" FontSize:15 FontColor:[UIColor lightGrayColor]];
    [self.contentView addSubview:self.downLabel];
    [self.downLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-margin);
        make.centerY.mas_equalTo(self.contentView.mas_centerY).offset(0);
    }];
    
    UIView *lineView = [WBUtil createLineView];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(margin);
        make.height.mas_equalTo(1);
        make.width.mas_equalTo(screenWidth-margin);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(0);
    }];
    
}

-(void)setTitle:(NSString *)title{
    _title = title;
    self.chapTitleLabel.text = title;
}

-(void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    self.selectButton.selected = isSelect;
}

-(void)setIsDown:(BOOL)isDown{
    _isDown = isDown;
    if (isDown) {
        self.selectButton.hidden = YES;
        self.downLabel.hidden = NO;
    }else{
        self.selectButton.hidden = NO;
        self.downLabel.hidden = YES;
    }
}

@end
