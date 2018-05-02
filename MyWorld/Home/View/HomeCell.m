//
//  HomeCell.m
//  MyWorld
//
//  Created by wayneking on 2018/4/27.
//  Copyright © 2018年 wayneking. All rights reserved.
//

#import "HomeCell.h"

@interface HomeCell()


@end

@implementation HomeCell

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
    self.contentView.backgroundColor = [WBUtil createColor:245 green:247 blue:249];
    
    self.articleImageView = [WBUtil createImageVIew:@"pikaqiu.jpg" CornRadius:5];
    [self.contentView addSubview:self.articleImageView];
    [self.articleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(topdown);
        make.left.mas_equalTo(self.contentView.mas_left).offset(margin);
        make.width.height.mas_equalTo(100);
    }];
    
    self.articleLabel = [WBUtil createLabel:@"《民调局异闻录》全集(1-6部全)【精校版】" FontSize:16 FontColor:[UIColor blackColor]];
    self.articleLabel.numberOfLines = 2;
    [self.contentView addSubview:self.articleLabel];
    [self.articleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(topdown);
        make.left.mas_equalTo(self.articleImageView.mas_right).offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-margin);
    }];
    
    self.authorLabel = [WBUtil createLabel:@"耳东水寿(陈涛)" FontSize:14 FontColor:[UIColor blackColor]];
    [self.contentView addSubview:self.authorLabel];
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.articleLabel.mas_bottom).offset(topdown);
        make.left.mas_equalTo(self.articleLabel.mas_left).offset(0);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-margin);
    }];
}

@end
