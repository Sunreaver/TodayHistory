//
//  THDictionaryData.m
//  TodayHistory
//
//  Created by 谭伟 on 15/11/17.
//  Copyright © 2015年 谭伟. All rights reserved.
//

#import "THDictionaryData.h"

@implementation THDictionaryData

+(NSString*)getStringWithDictionary:(NSDictionary*)data
{
    if (data == nil ||
        ![data isKindOfClass:[NSDictionary class]] ||
        !data[@"res"])
    {
        return @"查询失败";
    }
    
    return @"";
}

@end
