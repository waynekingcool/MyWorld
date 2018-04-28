//
//  BookPageController.m
//  MyWorld
//
//  Created by wayneking on 2018/4/28.
//  Copyright © 2018年 wayneking. All rights reserved.
//

#import "BookPageController.h"
#import "BookReadView.h"
#import <CoreText/CoreText.h>

@interface BookPageController ()

@property(nonatomic,strong) BookReadView *readView;

@end

@implementation BookPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)createUI{
    [self.view addSubview:self.readView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self prefersStatusBarHidden];
}

#pragma mark - Getter And Setter
-(BookReadView *)readView{
    if (!_readView) {
        _readView = [[BookReadView alloc] initWithFrame:CGRectMake(LeftSpacing,TopSpacing, self.view.frame.size.width-LeftSpacing-RightSpacing, self.view.frame.size.height-TopSpacing-BottomSpacing)];
        
        //暂时显示第一页
        BookChapModel *model = self.model.chapArray[0];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:model.chapContent];
        //样式
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        dict[NSForegroundColorAttributeName] = [UIColor cyanColor];
        dict[NSFontAttributeName] = [UIFont systemFontOfSize:14];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineSpacing = 10.f;
        paragraphStyle.alignment = NSTextAlignmentJustified;
        dict[NSParagraphStyleAttributeName] = paragraphStyle;
        //设置样式
        [attrStr setAttributes:dict range:NSMakeRange(0, model.chapContent.length)];
        
        CTFramesetterRef setterRef = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attrStr);
        CGPathRef pathRef = CGPathCreateWithRect(CGRectMake(0,0, _readView.frame.size.width, _readView.frame.size.height), NULL);
        CTFrameRef frameRef = CTFramesetterCreateFrame(setterRef, CFRangeMake(0, 0), pathRef, NULL);
        CFRelease(setterRef);
        CFRelease(pathRef);
        
        _readView.frameRef = frameRef;
        _readView.content = model.chapContent;
    }
    return _readView;
}


@end
