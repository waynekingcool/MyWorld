//
//  BookRecordModel.m
//  MyWorld
//
//  Created by wayneking on 2018/5/16.
//  Copyright © 2018年 wayneking. All rights reserved.
//

#import "BookRecordModel.h"

@implementation BookRecordModel
-(id)copyWithZone:(NSZone *)zone{
    BookRecordModel *model = [[BookRecordModel allocWithZone:zone]init];
    model.recordChap = self.recordChap;
    model.recordPage = self.recordPage;
    model.recordTitle = self.recordTitle;
    return model;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.recordTitle forKey:@"recordTitle"];
    [aCoder encodeObject:self.recordPage forKey:@"recordPage"];
    [aCoder encodeObject:self.recordChap forKey:@"recordChap"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.recordChap = [aDecoder decodeObjectForKey:@"recordChap"];
        self.recordTitle = [aDecoder decodeObjectForKey:@"recordTitle"];
        self.recordPage = [aDecoder decodeObjectForKey:@"recordPage"];
    }
    return self;
}
@end
