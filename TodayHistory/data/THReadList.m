//
//  THReadList.m
//  TodayHistory
//
//  Created by 谭伟 on 15/12/28.
//  Copyright © 2015年 谭伟. All rights reserved.
//

#import "THReadList.h"
#import "UserDef.h"
#import "THReadBook.h"
#import "NSDate+EarlyInTheMorning.h"

@import EGOCache;

static NSMutableArray<THRead*> *s_data = nil;
static NSMutableDictionary  *s_readProgress;

@implementation THReadList

+(NSArray<THRead*> *)books
{
    if (!s_data)
    {
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

+(NSMutableDictionary*)readProgress
{
    if (!s_readProgress)
    {
        s_readProgress = [NSMutableDictionary dictionaryWithCapacity:[THReadList books].count];
        EGOCache *catch = [EGOCache globalCache];
        for (THRead *book in [THReadList books])
        {
            NSString *key = [NSString stringWithFormat:@"com.readlist.%@", book.rID];
            if ([catch hasCacheForKey:key])
            {
                [s_readProgress setValue:[catch objectForKey:key] forKey:key];
            }
        }
    }
    return s_readProgress;
}

+(void)storageData
{
    if (s_data)
    {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:s_data];
        [data writeToFile:File_Path(@"com.tmp.readlist") atomically:YES];
    }
}

+(BOOL)AddData:(THRead *)read
{
    if (read.page.integerValue == 0 || read.deadline.integerValue == 0) {
        return NO;
    }
    for (THRead *r in s_data)
    {
        if ([r.rID isEqualToString:read.rID])
        {
            THRead *rd = [THRead initWithBookName:[read.bookName stringByAppendingString:@"※"] PageNum:[read.page integerValue] Deadline:[read.deadline integerValue]];
            [THReadList AddData:rd];
            return YES;
        }
    }
    [s_data insertObject:read atIndex:0];
    
    [THReadList storageData];
    
    return YES;
}

+(BOOL)DelDataWithID:(NSString *)rID
{
    for (int i = 0; i < [THReadList books].count; ++i) {
        THRead *read = [THReadList books][i];
        if ([read.rID isEqualToString:rID])
        {
            [s_data removeObjectAtIndex:i];
            break;
        }
    }
    
    NSString *key = [NSString stringWithFormat:@"com.readlist.%@", rID];
    EGOCache *catch = [EGOCache globalCache];
    [catch removeCacheForKey:key];
    [[THReadList readProgress] removeObjectForKey:key];
    [THReadList storageData];
    return NO;
}

+(BOOL)DelData:(THRead *)read
{
    NSString *key = [NSString stringWithFormat:@"com.readlist.%@", read.rID];
    EGOCache *catch = [EGOCache globalCache];
    [catch removeCacheForKey:key];
    [[THReadList readProgress] removeObjectForKey:key];
    
    [s_data removeObject:read];
    [THReadList storageData];
    return NO;
}

+(BOOL)EditPage:(NSUInteger)page Read:(THRead *)read
{
    page = MIN(page, read.page.unsignedIntegerValue);
    
    NSMutableArray<THReadProgress*> *newData = [NSMutableArray array];
    
    NSString *key = [NSString stringWithFormat:@"com.readlist.%@", read.rID];
    NSArray *arr = [THReadList readProgress][key];
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
    
    [[THReadList readProgress] setValue:newData forKey:key];
    EGOCache *catch = [EGOCache globalCache];
    catch.defaultTimeoutInterval = 10 * 365 * 24 * 3600; //10年有效期
    [catch setObject:newData forKey:key];
    
    //当已经读完，就重新排序
    if (page == read.page.unsignedIntegerValue)
    {
        [THReadList SortBooksAsReadProgress];
        [THReadList storageData];
    }
    
    return YES;
}

+(NSUInteger)lastPageProgressForReadID:(NSString*)rID
{
    NSString *key = [NSString stringWithFormat:@"com.readlist.%@", rID];
    NSArray<THReadProgress*> *arr = [THReadList readProgress][key];
    
    if (arr && arr.count > 0)
    {
        return [arr lastObject].page.unsignedIntegerValue;
    }
    
    return 0;
}

+(NSUInteger)lastDayProgressForReadID:(NSString*)rID
{
    NSString *key = [NSString stringWithFormat:@"com.readlist.%@", rID];
    NSArray<THReadProgress*> *arr = [THReadList readProgress][key];
    
    if (arr && arr.count > 0)
    {
        return [arr lastObject].day.unsignedIntegerValue;
    }
    
    return 0;
}

+(NSArray<THReadProgress*>*)getReadProgressFromReadID:(NSString *)rID
{
    NSString *key = [NSString stringWithFormat:@"com.readlist.%@", rID];
    NSArray<THReadProgress*> *arr = [THReadList readProgress][key];
    
    if (arr && arr.count > 0)
    {
        return arr;
    }
    return nil;
}

+(BOOL)DelReadProgressDataForLast:(THRead *)read
{
    NSString *key = [NSString stringWithFormat:@"com.readlist.%@", read.rID];
    NSArray<THReadProgress*> *arr = [THReadList readProgress][key];
    
    if (arr && arr.count > 0)
    {
        EGOCache *catch = [EGOCache globalCache];
        
        NSMutableArray *newData = [NSMutableArray arrayWithArray:arr];
        THReadProgress *rp = newData.lastObject;
        [newData removeLastObject];
        if (newData.count == 0)
        {
            [catch removeCacheForKey:key];
            [[THReadList readProgress] removeObjectForKey:key];
        }
        else
        {
            [catch setObject:newData forKey:key];
            [[THReadList readProgress] setValue:newData forKey:key];
        }
        
        if (rp.page.unsignedIntegerValue >= read.page.unsignedIntegerValue)
        {
            [THReadList SortBooksAsReadProgress];
            [THReadList storageData];
        }
        return YES;
    }
    return NO;
}

+(void)SortBooksAsReadProgress
{
    NSArray *sortArr = [[THReadList books] sortedArrayWithOptions:NSSortStable|NSSortConcurrent usingComparator:^NSComparisonResult(THRead*  _Nonnull obj1, THRead*  _Nonnull obj2) {
        if (obj1.page.unsignedIntegerValue <= [THReadList lastPageProgressForReadID:obj1.rID] &&
            obj2.page.unsignedIntegerValue > [THReadList lastPageProgressForReadID:obj2.rID])
        {
            return NSOrderedDescending;
        }
        else if (obj2.page.unsignedIntegerValue <= [THReadList lastPageProgressForReadID:obj2.rID] &&
                 obj1.page.unsignedIntegerValue > [THReadList lastPageProgressForReadID:obj1.rID])
        {
            return NSOrderedAscending;
        }
        else if (obj1.startDate.timeIntervalSince1970 < obj2.startDate.timeIntervalSince1970)
        {
            return NSOrderedDescending;
        }
        else if (obj1.startDate.timeIntervalSince1970 > obj2.startDate.timeIntervalSince1970)
        {
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
    [s_data removeAllObjects];
    [s_data addObjectsFromArray:sortArr];
}
@end
