//
//  BookIndexNoImgCell.m
//  MyWorld
//
//  Created by wayneking on 2018/5/4.
//  Copyright © 2018年 wayneking. All rights reserved.
//

#import "BookIndexNoImgCell.h"

@interface BookIndexNoImgCell()
@property(nonatomic,strong) UILabel *bookTypeLabel; //小说类型
@property(nonatomic,strong) UILabel *bookTitleLabel;    //小说名称
@property(nonatomic,strong) UILabel *bookAuthorLabel;   //小说作者
@end

@implementation BookIndexNoImgCell

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
    
    self.bookTypeLabel = [WBUtil createLabel:@"暂无类别" FontSize:16 FontColor:[UIColor blackColor]];
    [self.contentView addSubview:self.bookTypeLabel];
    [self.bookTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY).offset(0);
        make.left.mas_equalTo(self.contentView.mas_left).offset(margin);
    }];
    
    self.bookTitleLabel = [WBUtil createLabel:@"暂无名称" FontSize:16 FontColor:[UIColor blackColor]];
    [self.contentView addSubview:self.bookTitleLabel];
    [self.bookTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY).offset(0);
        make.left.mas_equalTo(self.bookTypeLabel.mas_right).offset(10);
    }];
    
    self.bookAuthorLabel = [WBUtil createLabel:@"暂无作者" FontSize:16 FontColor:[UIColor blackColor]];
    [self.contentView addSubview:self.bookAuthorLabel];
    [self.bookAuthorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY).offset(0);
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
    self.bookTypeLabel.text = model.bookType;
    self.bookTitleLabel.text = model.title;
    self.bookAuthorLabel.text = model.author;
}

@end
