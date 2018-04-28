//
//  BookChapModel.m
//  MyWorld
//
//  Created by wayneking on 2018/4/28.
//  Copyright © 2018年 wayneking. All rights reserved.
//

#import "BookChapModel.h"
#import <CoreText/CoreText.h>

@interface BookChapModel()

@property(nonatomic,strong) NSMutableArray *pageArray;

@end

@implementation BookChapModel

#pragma mark - Getter And Setter
-(void)setChapContent:(NSString *)chapContent{
    _chapContent = chapContent;
    
    //获取页数
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:chapContent];
    //样式
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    dict[NSForegroundColorAttributeName] = [UIColor blackColor];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = 10.f;
    paragraphStyle.alignment = NSTextAlignmentJustified;
    dict[NSParagraphStyleAttributeName] = paragraphStyle;
    //设置样式
    [attrStr setAttributes:dict range:NSMakeRange(0, attrStr.length)];
    //赋值
    NSAttributedString *attrString = [attrStr copy];
    
    //coreText框架
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) attrString);
    CGRect bounds = CGRectMake(LeftSpacing, TopSpacing, screenWidth-LeftSpacing-RightSpacing, screenHeight-TopSpacing-BottomSpacing);
    CGPathRef path = CGPathCreateWithRect(bounds, NULL);
    
    int currentOffset = 0;
    int currentInnerOffset = 0;
    BOOL hasMorePages = YES;
    
    while (hasMorePages) {
        //如果是第一页
//        if (self.pageArray.count == 0) {
//            [self.pageArray addObject:@(currentOffset)];
//        }else{
//            NSInteger lastOffset = [[self.pageArray lastObject] integerValue];
//            if (lastOffset != currentOffset) {
//                [self.pageArray addObject:@(currentOffset)];
//            }
//        }
        
        [self.pageArray addObject:@(currentOffset)];
        CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(currentOffset, 0), path, NULL);
        CFRange range = CTFrameGetVisibleStringRange(frame);
        if ((range.location + range.length) != attrString.length) {
            currentOffset += range.length;
            currentInnerOffset += range.length;
        }else{
            //分页完毕
            hasMorePages = NO;
        }
        //释放
        if (frame) {
            CFRelease(frame);
        }
    }
    
    //释放
    CGPathRelease(path);
    CFRelease(frameSetter);
    
    //根据分页的页数赋值
    self.pageCount = self.pageArray.count;
}

- (NSString *)getContent:(NSInteger)page{
    NSInteger local = [self.pageArray[page] integerValue];
    NSInteger length = 0;
    if (page < self.pageCount-1) {
        length = [self.pageArray[page+1] integerValue] - [self.pageArray[page] integerValue];
    }else{
        length = self.chapContent.length - [self.pageArray[page] integerValue];
    }
    
    return [self.chapContent substringWithRange:NSMakeRange(local, length)];
}

#pragma mark - Getter And Setter
-(NSMutableArray *)pageArray{
    if (!_pageArray) {
        _pageArray = [[NSMutableArray alloc]init];
    }
    return _pageArray;
}

@end
