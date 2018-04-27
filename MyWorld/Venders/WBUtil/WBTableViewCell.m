//
//  WBTableViewCell.m
//  ylwj_User
//
//  Created by wayneking on 3/16/17.
//  Copyright © 2017 wayneking. All rights reserved.
//

#import "WBTableViewCell.h"

@interface WBTableViewCell()<UITextFieldDelegate>

@property(nonatomic,strong) UIImageView *rightArrow;
@property (nonatomic,strong) UILabel *titleLabel;
@end

@implementation WBTableViewCell

-(instancetype)initWithTitle:(NSString *)title WithPlaceholder:(NSString *)placeholder CanBeInput:(BOOL) canBeInput delegate:(id)vc{
    if (self=[super init]) {
        //设置代理
        self.delegate = vc;
        self.backgroundColor = [UIColor whiteColor];
        
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.text = title;
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(15);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(100);
        }];
        
        self.textField = [[UITextField alloc]init];
        self.textField.font = [UIFont systemFontOfSize:14];
        self.textField.textAlignment = NSTextAlignmentRight;
        self.textField.placeholder = placeholder;
        self.textField.userInteractionEnabled = canBeInput;
        self.textField.delegate = self;
        [self addSubview:self.textField];
        
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(self.titleLabel.mas_right).offset(0);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.right.mas_equalTo(self.mas_right).offset(-15);
        }];
        
        self.rightArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ico_health_security_right"]];
        [self addSubview:self.rightArrow];
        [self.rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY).offset(0);
            make.right.mas_equalTo(self.mas_right).offset(-5);
        }];
        
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = [UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(self.mas_right).offset(0);
            make.height.mas_equalTo(1);
            make.bottom.mas_equalTo(self.mas_bottom).offset(0);
        }];
        
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSelf:)];
        [self addGestureRecognizer:tapGR];

    }
    return self;
}

#pragma mark - Custom Methods
- (void)tapSelf:(UITapGestureRecognizer *)sender{
    [self.delegate touchWBTableViewCell:self];
}

-(void)hideArrow:(BOOL)hidden{
    if (hidden==true) {
        self.rightArrow.hidden = true;
    }else{
        self.rightArrow.hidden = false;
    }
}

#pragma mark - Delegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
    //填充值,方便获取
    self.string = textField.text;
}

-(NSString *)string{
    return self.textField.text;
}

- (void)setString:(NSString *)string{
    self.textField.text = string;
}

-(void)setTitleColor:(UIColor *)titleColor{
    self.titleLabel.textColor = titleColor;
}
@end
