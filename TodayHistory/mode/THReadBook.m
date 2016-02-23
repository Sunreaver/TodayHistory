//
//  THReadBook.m
//  TodayHistory
//
//  Created by 谭伟 on 15/12/31.
//  Copyright © 2015年 谭伟. All rights reserved.
//

#import "THReadBook.h"
#import "NSDate+EarlyInTheMorning.h"
#import "NSString+NSData+md5sha1.h"

@implementation THRead

+(instancetype)initWithBookName:(NSString *)name PageNum:(NSUInteger)page Deadline:(NSUInteger)day
{
    return [THRead initWithBookName:name Author:nil PageNum:page Deadline:day];
}

+(instancetype)initWithBookName:(NSString*)name Author:(NSString*)author PageNum:(NSUInteger)page Deadline:(NSUInteger)day
{
    THRead *read = [[THRead alloc] init];
    read.author = author;
    read.bookName = name;
    read.page = @(page);
    read.startDate = [[NSDate date] earlyInTheMorning];
    read.deadline = @(day);
    read.rID = [[NSString stringWithFormat:@"%@+%@+%@", read.bookName, read.page, read.author] md5_32];
    
    return read;
}

-(NSDictionary*)dictinary
{
    id author = self.author == nil ? @"" : self.author;
    return @{
             @"bookID":self.rID,
             @"bookName":self.bookName,
             @"bookAuthor":author,
             @"bookPage":self.page,
             @"startTime":@(self.startDate.timeIntervalSince1970),
             @"deadLine":self.deadline
             };
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
        self.author = [aDecoder decodeObjectForKey:@"au"];
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
    [aCoder encodeObject:self.author forKey:@"au"];
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

-(NSDictionary*)dictinary
{
    return @{
             @"page":self.page,
             @"day":self.day
             };
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
