//
//  THReadList.m
//  TodayHistory
//
//  Created by 谭伟 on 15/12/28.
//  Copyright © 2015年 谭伟. All rights reserved.
//

#import "THReadList.h"
#import "UserDef.h"
#import "THRead.h"
#import "NSDate+EarlyInTheMorning.h"

@import EGOCache;

static NSMutableArray *s_data = nil;
static BOOL s_bDataChange = NO;

@implementation THReadList

+(NSArray<THRead*> *)data
{
    if (!s_data)
    {
        s_bDataChange = NO;
        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:File_Path(@"com.tmp.readlist")];
        if (arr)
        {
            s_data = [arr mutableCopy];
        }
        else
        {
            s_data = [NSMutableArray array];
        }
    }
    return s_data;
}

+(void)storageData
{
    if (s_bDataChange && s_data)
    {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:s_data];
        [data writeToFile:File_Path(@"com.tmp.readlist") atomically:YES];
        s_bDataChange = NO;
    }
}

+(BOOL)AddData:(THRead *)read
{
    [s_data addObject:read];
    s_bDataChange = YES;
    
    [THReadList storageData];
    
    return YES;
}

+(BOOL)DelData:(NSString *)rID
{
    for (int i = 0; i < [THReadList data].count; ++i) {
        THRead *read = [THReadList data][i];
        if ([read.rID isEqualToString:rID])
        {
            [s_data removeObjectAtIndex:i];
            s_bDataChange = YES;
            break;
        }
    }
    
    EGOCache *catch = [EGOCache globalCache];
    [catch removeCacheForKey:[NSString stringWithFormat:@"com.readlist.%@", rID]];
    [THReadList storageData];
    return NO;
}

+(BOOL)EditPage:(NSUInteger)page ReadID:(NSString *)rID
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray<THReadProgress*> *newData = [NSMutableArray array];
        
        EGOCache *catch = [EGOCache globalCache];
        catch.defaultTimeoutInterval = 10 * 365 * 24 * 3600; //10年有效期
        NSArray *arr = (NSArray*)[catch objectForKey:[NSString stringWithFormat:@"com.readlist.%@", rID]];
        if (arr)
        {
            [newData addObjectsFromArray:arr];
        }
        
        for (int i = 0; i < [THReadList data].count; ++i)
        {
            THRead *read = [THReadList data][i];
            if ([read.rID isEqualToString:rID])
            {
                NSInteger day = ([[NSDate date] earlyInTheMorning].timeIntervalSince1970 - read.startDate.timeIntervalSince1970)/24/3600;
                
                for (int j = 0; j < newData.count; ++j)
                {
                    if (newData[j].curDay.integerValue == day)
                    {
                        [newData removeObjectAtIndex:j];
                        break;
                    }
                }
                
                THReadProgress *progress = [THReadProgress initWithCurPage:page CurDay:day];
                [newData addObject:progress];
                [catch setObject:newData forKey:[NSString stringWithFormat:@"com.readlist.%@", rID]];
            }
        }
    });
    
    return YES;
}

+(NSUInteger)cuePageProgress:(NSString*)rID
{
    EGOCache *catch = [EGOCache globalCache];
    NSArray<THReadProgress*> *arr = (NSArray*)[catch objectForKey:[NSString stringWithFormat:@"com.readlist.%@", rID]];
    
    if (arr)
    {
        return [arr lastObject].curPage.unsignedIntegerValue;
    }
    
    return 0;
}
@end
