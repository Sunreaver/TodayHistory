//
//  THBook.m
//  TodayHistory
//
//  Created by 谭伟 on 15/12/28.
//  Copyright © 2015年 谭伟. All rights reserved.
//

#import "THBook.h"

@implementation THReadProgress

+(instancetype)initWithCurPage:(NSUInteger)page CurDay:(NSUInteger)day
{
    THReadProgress *readProgress = [[THReadProgress alloc] init];
    readProgress.page = @(page);
    readProgress.day = @(day);
    
    return readProgress;
}

#pragma mark -NSCoding

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.day = [aDecoder decodeObjectForKey:@"cd"];
        self.page = [aDecoder decodeObjectForKey:@"cp"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.day forKey:@"cd"];
    [aCoder encodeObject:self.page forKey:@"cp"];
}
@end
