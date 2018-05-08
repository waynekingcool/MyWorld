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

-(NSMutableArray *)pageArray{
    if (!_pageArray) {
        _pageArray = [[NSMutableArray alloc]init];
    }
    return _pageArray;
}

-(void)setChapTitle:(NSString *)chapTitle{
    _chapTitle = chapTitle;
    
}

#pragma mark - Private Methods
//将汉字转换为数字
- (NSString *)arabicNumberalsFromChineseNumberals:(NSString *)arabic{
    
    NSMutableDictionary * mdic =[[NSMutableDictionary alloc]init];
    [mdic setObject:[NSNumber numberWithInt:10000] forKey:@"万"];
    [mdic setObject:[NSNumber numberWithInt:1000] forKey:@"千"];
    [mdic setObject:[NSNumber numberWithInt:100] forKey:@"百"];
    [mdic setObject:[NSNumber numberWithInt:10] forKey:@"十"];
    [mdic setObject:[NSNumber numberWithInt:9] forKey:@"九"];
    [mdic setObject:[NSNumber numberWithInt:8] forKey:@"八"];
    [mdic setObject:[NSNumber numberWithInt:7] forKey:@"七"];
    [mdic setObject:[NSNumber numberWithInt:6] forKey:@"六"];
    [mdic setObject:[NSNumber numberWithInt:5] forKey:@"五"];
    [mdic setObject:[NSNumber numberWithInt:4] forKey:@"四"];
    [mdic setObject:[NSNumber numberWithInt:3] forKey:@"三"];
    [mdic setObject:[NSNumber numberWithInt:2] forKey:@"二"];
    [mdic setObject:[NSNumber numberWithInt:2] forKey:@"两"];
    [mdic setObject:[NSNumber numberWithInt:1] forKey:@"一"];
    [mdic setObject:[NSNumber numberWithInt:0] forKey:@"零"];
    
    BOOL flag=YES;//yes表示正数，no表示负数
    NSString * s=[arabic substringWithRange:NSMakeRange(0, 1)];
    if([s isEqualToString:@"负"]){
        flag=NO;
    }
    int i=0;
    if(!flag){
        i=1;
    }
    
    int sum=0;//和
    int num[20];//保存单个汉字信息数组
    for(int i=0;i<20;i++){//将其全部赋值为0
        num[i]=0;
    }
    
    int k=0;//用来记录数据的个数
    //如果是负数，正常的数据从第二个汉字开始，否则从第一个开始
    for(;i<[arabic length];i++){
        NSString * key=[arabic substringWithRange:NSMakeRange(i, 1)];
        int tmp=[[mdic valueForKey:key] intValue];
        num[k++]=tmp;
    }
    
    //将获得的所有数据进行拼装
    for(int i=0;i<k;i++){
        if(num[i]<10&&num[i+1]>=10){
            sum+=num[i]*num[i+1];
            i++;
        }else{
            sum+=num[i];
        }
    }
    
    NSMutableString * result=[[NSMutableString alloc]init];;
    if(flag){//如果正数
        NSLog(@"%d",sum);
        result=[NSMutableString stringWithFormat:@"%d",sum];
    }else{//如果负数
        NSLog(@"-%d",sum);
        result=[NSMutableString stringWithFormat:@"-%d",sum];
    }
    return result;
}



@end
