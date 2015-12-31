//
//  THReadList.m
//  TodayHistory
//
//  Created by 谭伟 on 15/12/28.
//  Copyright © 2015年 谭伟. All rights reserved.
//

#import "THReadList.h"
#import "UserDef.h"
#import "THBook.h"
#import "NSDate+EarlyInTheMorning.h"

@import EGOCache;

static NSMutableArray *s_data = nil;
static BOOL s_bDataChange = NO;

@implementation THReadList

+(NSArray<THBook*> *)books
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

+(BOOL)AddData:(THBook *)read
{
    if (read.page.integerValue == 0 || read.deadline.integerValue == 0) {
        return NO;
    }
    for (THBook *r in s_data)
    {
        if ([r.rID isEqualToString:read.rID])
        {
            THBook *rd = [THBook initWithBookName:[read.bookName stringByAppendingString:@"※"] PageNum:[read.page integerValue] Deadline:[read.deadline integerValue]];
            [THReadList AddData:rd];
            return YES;
        }
    }
    [s_data insertObject:read atIndex:0];
    s_bDataChange = YES;
    
    [THReadList storageData];
    
    return YES;
}

+(BOOL)DelDataWithID:(NSString *)rID
{
    for (int i = 0; i < [THReadList books].count; ++i) {
        THBook *read = [THReadList books][i];
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

+(BOOL)DelData:(THBook *)read
{
    EGOCache *catch = [EGOCache globalCache];
    [catch removeCacheForKey:[NSString stringWithFormat:@"com.readlist.%@", read.rID]];
    
    [s_data removeObject:read];
    [THReadList storageData];
    return NO;
}

+(BOOL)EditPage:(NSUInteger)page Read:(THBook *)read
{
    page = MIN(page, read.page.unsignedIntegerValue);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray<THReadProgress*> *newData = [NSMutableArray array];
        
        EGOCache *catch = [EGOCache globalCache];
        catch.defaultTimeoutInterval = 10 * 365 * 24 * 3600; //10年有效期
        NSArray *arr = (NSArray*)[catch objectForKey:[NSString stringWithFormat:@"com.readlist.%@", read.rID]];
        if (arr)
        {
            [newData addObjectsFromArray:arr];
        }
        
        NSInteger day = ([[NSDate date] earlyInTheMorning].timeIntervalSince1970 - read.startDate.timeIntervalSince1970)/24/3600;
        
        for (NSInteger j = newData.count - 1; j >= 0 ; --j)
        {
            if (newData[j].day.integerValue == day)
            {
                [newData removeObjectAtIndex:j];
                break;
            }
        }
        
        THReadProgress *progress = [THReadProgress initWithCurPage:page CurDay:day];
        [newData addObject:progress];
        [catch setObject:newData forKey:[NSString stringWithFormat:@"com.readlist.%@", read.rID]];
    });
    
    return YES;
}

+(NSUInteger)lastPageProgressForReadID:(NSString*)rID
{
    EGOCache *catch = [EGOCache globalCache];
    NSArray<THReadProgress*> *arr = (NSArray*)[catch objectForKey:[NSString stringWithFormat:@"com.readlist.%@", rID]];
    
    if (arr && arr.count > 0)
    {
        return [arr lastObject].page.unsignedIntegerValue;
    }
    
    return 0;
}

+(NSUInteger)lastDayProgressForReadID:(NSString*)rID
{
    EGOCache *catch = [EGOCache globalCache];
    NSArray<THReadProgress*> *arr = (NSArray*)[catch objectForKey:[NSString stringWithFormat:@"com.readlist.%@", rID]];
    
    if (arr && arr.count > 0)
    {
        return [arr lastObject].day.unsignedIntegerValue;
    }
    
    return 0;
}

+(NSArray<THReadProgress*>*)getReadProgressFromReadID:(NSString *)rID
{
    EGOCache *catch = [EGOCache globalCache];
    NSArray<THReadProgress*> *arr = (NSArray*)[catch objectForKey:[NSString stringWithFormat:@"com.readlist.%@", rID]];
    
    if (arr && arr.count > 0)
    {
        return arr;
    }
    return nil;
}

+(BOOL)DelReadProgressDataForLast:(THBook *)read
{
    EGOCache *catch = [EGOCache globalCache];
    NSArray<THReadProgress*> *arr = (NSArray*)[catch objectForKey:[NSString stringWithFormat:@"com.readlist.%@", read.rID]];
    
    if (arr && arr.count > 0)
    {
        NSMutableArray *newData = [NSMutableArray arrayWithArray:arr];
        [newData removeLastObject];
        if (newData.count == 0)
        {
            [catch removeCacheForKey:[NSString stringWithFormat:@"com.readlist.%@", read.rID]];
        }
        else
        {
            [catch setObject:newData forKey:[NSString stringWithFormat:@"com.readlist.%@", read.rID]];
        }
        return YES;
    }
    return NO;
}
@end
