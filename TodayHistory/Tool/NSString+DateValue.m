//
//  NSString+DateValue.m
//  DateMethod
//
//  Created by 谭伟 on 15/7/22.
//  Copyright (c) 2015年 谭伟. All rights reserved.
//

#import "NSString+DateValue.h"

@implementation NSString (DateValue)

-(NSDate*)dateValue
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd";
    return [df dateFromString:self];
}

@end
