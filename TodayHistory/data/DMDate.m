//
//  DMDate.m
//  DateMethod
//
//  Created by 谭伟 on 15/7/22.
//  Copyright (c) 2015年 谭伟. All rights reserved.
//

#import "DMDate.h"
#import "NSDate+EarlyInTheMorning.h"

@interface DMDate ()

@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *endDate;
@property (nonatomic, assign) NSInteger iDay;

@end

@implementation DMDate

+(instancetype)newWithStartDate:(NSDate *)s Day:(NSInteger)d
{
    DMDate *dm = [[DMDate alloc] init];
    dm.startDate = s.earlyInTheMorning;
    dm.endDate = [NSDate dateWithTimeInterval:d*24*3600 sinceDate:dm.startDate].earlyInTheMorning;
    dm.iDay = d;
    return dm;
}

+(instancetype)newWithStartDate:(NSDate *)s EndDate:(NSDate *)e
{
    DMDate *dm = [[DMDate alloc] init];
    dm.startDate = s.earlyInTheMorning;
    dm.endDate = e.earlyInTheMorning;
    NSTimeInterval ti = dm.endDate.timeIntervalSince1970 - dm.startDate.timeIntervalSince1970;
    ti += ti > 0 ? 3600 : -3600;
    dm.iDay = ti/3600/24;
    return dm;
}

-(NSString*)day
{
    return @(self.iDay).stringValue;
}

-(NSString*)start
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd";
    return [df stringFromDate:self.startDate];
}

-(NSString*)end
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd";
    return [df stringFromDate:self.endDate];
}

@end
