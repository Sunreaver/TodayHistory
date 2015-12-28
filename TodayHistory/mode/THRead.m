//
//  THRead.m
//  TodayHistory
//
//  Created by 谭伟 on 15/12/28.
//  Copyright © 2015年 谭伟. All rights reserved.
//

#import "THRead.h"
#import "NSDate+EarlyInTheMorning.h"
#import "MD5Encode.h"

@implementation THRead

+(instancetype)initWithBookName:(NSString *)name PageNum:(NSUInteger)page Deadline:(NSUInteger)day
{
    THRead *read = [[THRead alloc] init];
    read.bookName = name;
    read.page = @(page);
    read.startDate = [[NSDate date] earlyInTheMorning];
    read.deadline = @(day);
    read.rID = [MD5Encode md5_32:[NSString stringWithFormat:@"%@+%@", read.bookName, read.page]];
    
    return read;
}

#pragma mark -NSCoding

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.rID = [aDecoder decodeObjectForKey:@"rid"];
        self.bookName = [aDecoder decodeObjectForKey:@"bn"];
        self.page = [aDecoder decodeObjectForKey:@"pg"];
        self.startDate = [aDecoder decodeObjectForKey:@"sd"];
        self.deadline = [aDecoder decodeObjectForKey:@"dl"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.rID forKey:@"rid"];
    [aCoder encodeObject:self.bookName forKey:@"bn"];
    [aCoder encodeObject:self.page forKey:@"pg"];
    [aCoder encodeObject:self.startDate forKey:@"sd"];
    [aCoder encodeObject:self.deadline forKey:@"dl"];
}
@end


@implementation THReadProgress

+(instancetype)initWithCurPage:(NSUInteger)page CurDay:(NSUInteger)day
{
    THReadProgress *readProgress = [[THReadProgress alloc] init];
    readProgress.curPage = @(page);
    readProgress.curDay = @(day);
    
    return readProgress;
}

#pragma mark -NSCoding

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.curDay = [aDecoder decodeObjectForKey:@"cd"];
        self.curPage = [aDecoder decodeObjectForKey:@"cp"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.curDay forKey:@"cd"];
    [aCoder encodeObject:self.curPage forKey:@"cp"];
}
@end
