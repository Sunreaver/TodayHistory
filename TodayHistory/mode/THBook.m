//
//  THBook.m
//  TodayHistory
//
//  Created by 谭伟 on 15/12/28.
//  Copyright © 2015年 谭伟. All rights reserved.
//

#import "THBook.h"
#import "NSDate+EarlyInTheMorning.h"
#import "NSString+NSData+md5sha1.h"

@implementation THBook

+(instancetype)initWithBookName:(NSString *)name PageNum:(NSUInteger)page Deadline:(NSUInteger)day
{
    THBook *read = [[THBook alloc] init];
    read.bookName = name;
    read.page = @(page);
    read.startDate = [[NSDate date] earlyInTheMorning];
    read.deadline = @(day);
    read.rID = [[NSString stringWithFormat:@"%@+%@", read.bookName, read.page] md5_32];
    
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
