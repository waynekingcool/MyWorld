//
//  BookModel.m
//  MyWorld
//
//  Created by wayneking on 2018/4/28.
//  Copyright © 2018年 wayneking. All rights reserved.
//

#import "BookModel.h"

@implementation BookModel

#pragma mark - Getter And Setter
-(NSMutableArray *)chapArray{
    if (!_chapArray) {
        _chapArray = [[NSMutableArray alloc]init];
    }
    return _chapArray;
}

-(NSMutableArray *)chapTitleArray{
    if (!_chapTitleArray) {
        _chapTitleArray = [[NSMutableArray alloc]init];
    }
    return _chapTitleArray;
}

@end
