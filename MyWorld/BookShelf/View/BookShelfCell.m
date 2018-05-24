//
//  BookShelfCell.m
//  MyWorld
//
//  Created by wayneking on 2018/5/24.
//  Copyright © 2018年 wayneking. All rights reserved.
//

#import "BookShelfCell.h"

@interface BookShelfCell()

@property(nonatomic,strong) UIImageView *coverImageView;    //封面
@property(nonatomic,strong) UILabel *bookTitleLabel;    //书名
@property(nonatomic,strong) UILabel *recordLabel;   //阅读记录

@end

@implementation BookShelfCell

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
    
    self.coverImageView = [WBUtil createImageVIew:@"placeholder" CornRadius:5];
    [self.contentView addSubview:self.coverImageView];
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(5);
        make.left.mas_equalTo(self.contentView.mas_left).offset(margin);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(130);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
    self.bookTitleLabel = [WBUtil createLabel:@"书名" FontSize:15 FontColor:[UIColor blackColor]];
    self.bookTitleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.bookTitleLabel];
    [self.bookTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(5);
        make.left.mas_equalTo(self.coverImageView.mas_right).offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-margin);
    }];
    
    self.recordLabel = [WBUtil createLabel:@"当前阅读: 暂无" FontSize:15 FontColor:[UIColor blackColor]];
    self.recordLabel.numberOfLines = 0;
    [self.contentView addSubview:self.recordLabel];
    [self.recordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bookTitleLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(self.coverImageView.mas_right).offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-margin);
    }];
    
}

-(void)setModel:(BookToShelfModel *)model{
    _model = model;
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.bookTitleLabel.text = model.title;
    self.recordLabel.text = [NSString stringWithFormat:@"当前阅读: %@",model.recordTitle];
}

@end
