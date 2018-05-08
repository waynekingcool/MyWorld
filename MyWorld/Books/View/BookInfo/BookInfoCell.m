//
//  BookInfoCell.m
//  MyWorld
//
//  Created by wayneking on 2018/5/5.
//  Copyright © 2018年 wayneking. All rights reserved.
//

#import "BookInfoCell.h"

@interface BookInfoCell()

@property(nonatomic,strong) UILabel *chapLabel;

@end

@implementation BookInfoCell


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
    
    self.chapLabel = [WBUtil createLabel:@"暂无名称" FontSize:16 FontColor:[UIColor blackColor]];
    [self.contentView addSubview:self.chapLabel];
    [self.chapLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY).offset(0);
        make.left.mas_equalTo(self.contentView.mas_left).offset(margin);
    }];
    
    UIView *lineView = [WBUtil createLineView];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(margin);
        make.width.mas_equalTo(screenWidth-margin);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(0);
    }];
}

-(void)setModel:(BookInfoChapModel *)model{
    _model = model;
    self.chapLabel.text = model.chapTitle;
}

@end
