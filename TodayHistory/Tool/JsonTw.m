//
//  JsonTw.m
//  TodayHistory
//
//  Created by 谭伟 on 15/9/9.
//  Copyright (c) 2015年 谭伟. All rights reserved.
//

#import "JsonTw.h"

@implementation NSString (JsonTw)

-(NSDictionary*)dicValues
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    return [NSJSONSerialization JSONObjectWithData:data
                                           options:NSJSONReadingAllowFragments
                                             error:nil];
}

@end
