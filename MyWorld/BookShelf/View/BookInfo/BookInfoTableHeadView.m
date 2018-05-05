//
//  BookInfoTableHeadView.m
//  MyWorld
//
//  Created by wayneking on 2018/5/5.
//  Copyright © 2018年 wayneking. All rights reserved.
//

#import "BookInfoTableHeadView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface BookInfoTableHeadView()

@property(nonatomic,strong) UIImageView *bookImageView; //封面
@property(nonatomic,strong) UILabel *titleLabel;    //书名
@property(nonatomic,strong) UILabel *authorLabel;   //作者
@property(nonatomic,strong) UILabel *categoryLabel; //分类
@property(nonatomic,strong) UILabel *typeLabel; //状态
@property(nonatomic,strong) UILabel *wordCountLabel;    //字数
@property(nonatomic,strong) UILabel *updateLabel;   //更新

@end

@implementation BookInfoTableHeadView

-(instancetype)init{
    if (self = [super init]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    self.backgroundColor = [UIColor whiteColor];
    
    self.bookImageView = [WBUtil createImageVIew:@"placeholder" CornRadius:0];
    [self addSubview:self.bookImageView];
    [self.bookImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(topdown);
        make.left.mas_equalTo(self.mas_left).offset(margin);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(130);
    }];
    
    self.titleLabel = [WBUtil createLabel:@"啊咧?没有书名" FontSize:20 FontColor:[UIColor blackColor]];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(topdown);
        make.left.mas_equalTo(self.bookImageView.mas_right).offset(5);
        make.right.mas_equalTo(self.mas_right).offset(-margin);
    }];
    
    self.authorLabel = [WBUtil createLabel:@"啊咧?没有作者" FontSize:16 FontColor:[UIColor blackColor]];
    [self addSubview:self.authorLabel];
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(topdown);
        make.left.mas_equalTo(self.bookImageView.mas_right).offset(5);
    }];
    
    self.categoryLabel = [WBUtil createLabel:@"啊咧?没有分类" FontSize:16 FontColor:[UIColor blackColor]];
    [self addSubview:self.categoryLabel];
    [self.categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.authorLabel.mas_top).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(-margin);
    }];
    
    self.typeLabel = [WBUtil createLabel:@"啊咧?没有状态" FontSize:16 FontColor:[UIColor blackColor]];
    [self addSubview:self.typeLabel];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.authorLabel.mas_bottom).offset(topdown);
        make.left.mas_equalTo(self.bookImageView.mas_right).offset(5);
    }];
    
    self.wordCountLabel = [WBUtil createLabel:@"啊咧?没有字数" FontSize:16 FontColor:[UIColor blackColor]];
    [self addSubview:self.wordCountLabel];
    [self.wordCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.typeLabel.mas_top).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(-margin);
    }];
    
    self.updateLabel = [WBUtil createLabel:@"啊咧?没有更新" FontSize:16 FontColor:[UIColor blackColor]];
    [self addSubview:self.updateLabel];
    [self.updateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.typeLabel.mas_bottom).offset(topdown);
        make.left.mas_equalTo(self.bookImageView.mas_right).offset(5);
    }];
    
    CGFloat width = (screenWidth - 2*margin -2*margin)/3;
    
    UIButton *startButton = [WBUtil createButton:@"开始阅读" TextSize:18 TextColor:[UIColor whiteColor] BackgroundColor:[UIColor orangeColor]];
    startButton.layer.cornerRadius = 5.f;
    startButton.layer.masksToBounds = YES;
    [self addSubview:startButton];
    @weakify(self);
    [[startButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if (self.startSubject) {
            [self.startSubject sendNext:@0];
        }
    }];
    [startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bookImageView.mas_bottom).offset(topdown);
        make.left.mas_equalTo(self.mas_left).offset(margin);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(width);
    }];
    
    UIButton *putButton = [WBUtil createButton:@"放入书架" TextSize:18 TextColor:[UIColor whiteColor] BackgroundColor:[WBUtil createColor:104 green:108 blue:234]];
    putButton.layer.cornerRadius = 5.f;
    putButton.layer.masksToBounds = YES;
    [self addSubview:putButton];
    [[putButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if (self.putSubject) {
            [self.putSubject sendNext:@0];
        }
    }];
    [putButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bookImageView.mas_bottom).offset(topdown);
        make.left.mas_equalTo(startButton.mas_right).offset(margin);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(width);
    }];
    
    UIButton *shelfButton = [WBUtil createButton:@"我的书架" TextSize:18 TextColor:[UIColor whiteColor] BackgroundColor:[WBUtil createColor:235 green:68 blue:79]];
    shelfButton.layer.cornerRadius = 5.f;
    shelfButton.layer.masksToBounds = YES;
    [self addSubview:shelfButton];
    [[shelfButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if (self.shelfSubject) {
            [self.shelfSubject sendNext:@0];
        }
    }];
    [shelfButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bookImageView.mas_bottom).offset(topdown);
        make.left.mas_equalTo(putButton.mas_right).offset(margin);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(width);
    }];
}

-(void)setModel:(BookInfoModel *)model{
    _model = model;
    [self.bookImageView sd_setImageWithURL:[NSURL URLWithString:model.coverUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.titleLabel.text = model.title;
    self.authorLabel.text = [NSString stringWithFormat:@"作者: %@",model.author];
    self.categoryLabel.text = [NSString stringWithFormat:@"分类: %@",model.category];
    self.typeLabel.text = [NSString stringWithFormat:@"状态: %@",model.state];
    self.wordCountLabel.text = [NSString stringWithFormat:@"字数: %@",model.wordCount];
    self.updateLabel.text = [NSString stringWithFormat:@"更新时间: %@",model.updateTime];
}

@end
