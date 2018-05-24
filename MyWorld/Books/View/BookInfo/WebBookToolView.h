//
//  WebBookToolView.h
//  MyWorld
//
//  Created by wayneking on 2018/5/24.
//  Copyright © 2018年 wayneking. All rights reserved.
//  工具条

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface WebBookToolView : UIView
///下载章节
@property(nonatomic,strong) RACSubject *downSubject;

@end
