//
//  BookIndexImgCell.m
//  MyWorld
//
//  Created by wayneking on 2018/5/4.
//  Copyright © 2018年 wayneking. All rights reserved.
//

#import "BookIndexImgCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface BookIndexImgCell()

@property(nonatomic,strong) UIImageView *bookImageView; //封面
@property(nonatomic,strong) UILabel *bookTitleLabel;    //名称
@property(nonatomic,strong) UILabel *bookAuthorLabel;   //作者
@property(nonatomic,strong) UILabel *descLabel; //描述

@end

@implementation BookIndexImgCell

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
    
    self.bookImageView = [WBUtil createImageVIew:@"placeholder" CornRadius:5];
    [self.contentView addSubview:self.bookImageView];
    [self.bookImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(topdown);
        make.left.mas_equalTo(self.contentView.mas_left).offset(margin);
        make.width.height.mas_equalTo(100);
    }];
    
    self.bookTitleLabel = [WBUtil createLabel:@"暂无名称" FontSize:16 FontColor:[UIColor blackColor]];
    [self.contentView addSubview:self.bookTitleLabel];
    [self.bookTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(topdown);
        make.left.mas_equalTo(self.bookImageView.mas_right).offset(10);
    }];
    
    self.bookAuthorLabel = [WBUtil createLabel:@"匿名" FontSize:16 FontColor:[UIColor blackColor]];
    [self.contentView addSubview:self.bookAuthorLabel];
    [self.bookAuthorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(topdown);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-margin);
    }];
    
    self.descLabel = [WBUtil createLabel:@"暂无描述" FontSize:16 FontColor:[UIColor blackColor]];
    self.descLabel.numberOfLines = 3;
    [self.contentView addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bookTitleLabel.mas_bottom).offset(topdown);
        make.left.mas_equalTo(self.bookImageView.mas_right).offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-margin);
    }];
    
    UIView *lineView = [WBUtil createLineView];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(self.contentView.mas_left).offset(margin);
        make.width.mas_equalTo(screenWidth-margin);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(0);
    }];
}

-(void)setModel:(BookIndexModel *)model{
    _model = model;
    
    [self.bookImageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.bookTitleLabel.text = model.title;
    self.bookAuthorLabel.text = model.author;
    self.descLabel.text = model.bookDesc;
}

@end
