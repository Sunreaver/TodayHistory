//
//  NSDate+EarlyInTheMorning.m
//  DateMethod
//
//  Created by 谭伟 on 15/7/22.
//  Copyright (c) 2015年 谭伟. All rights reserved.
//

#import "NSDate+EarlyInTheMorning.h"

@implementation NSDate (EarlyInTheMorning)
-(NSDate*)earlyInTheMorning
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyyMMdd";
    NSString *dateStr = [df stringFromDate:self];
    return [df dateFromString:dateStr];
}

-(NSString*)yyyyMMddStringValue
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyyMMdd";
    return [df stringFromDate:self];
}

@end

@implementation NSString (EarlyInTheMorning)

-(NSDate*)yyyyMMddString2Date
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyyMMdd";
    return [df dateFromString:self];
}

@end
