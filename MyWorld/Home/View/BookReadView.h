//
//  BookReadView.h
//  MyWorld
//
//  Created by wayneking on 2018/4/28.
//  Copyright © 2018年 wayneking. All rights reserved.
//  小说阅读view

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface BookReadView : UIView
@property (nonatomic,assign) CTFrameRef frameRef;
@property(nonatomic,copy) NSString *content;
@end
