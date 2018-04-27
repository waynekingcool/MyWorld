//
//  BaseController.h
//  广生盈
//
//  Created by wayneking on 18/10/2017.
//  Copyright © 2017 wayneking. All rights reserved.
//  全局基类

#import <UIKit/UIKit.h>
#import "TTFaveButton.h"

@interface BaseController : UIViewController

@property(nonatomic,strong) UIButton *leftButton;
@property(nonatomic,strong) UIButton *rightButton;
//@property(nonatomic,strong) UIButton *rightButton2;
@property(nonatomic,strong) TTFaveButton *rightButton2;
@property(nonatomic,strong) UIBarButtonItem *right;
@property(nonatomic,strong) UIBarButtonItem *right2;

//网络状态 NotReachable 3G/4G WiFi
@property(nonatomic,copy) NSString *netState;

- (void)leftButtonAction;
- (void)rightButtonAction;
- (void)rightButtonAction2;

- (void)setLeftButtonImage:(NSString *)imageName;
- (void)setRightButtonImage:(NSString *)imageName;

///监听网络
- (void)listenNetChange;
///子类如果需要监听网络变化,需要重写该方法
- (void)netWorkChange:(NSString *)currentState;
@end
