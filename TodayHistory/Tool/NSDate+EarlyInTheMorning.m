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
    df.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [df stringFromDate:self];
    return [df dateFromString:dateStr];
}

-(NSString*)stringValue
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd";
    return [df stringFromDate:self];
}

@end
