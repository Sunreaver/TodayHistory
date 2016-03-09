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
#import "TodayHistory-Swift.h"

#define READ_PROGRESS [THReadList readProgress]

@import EGOCache;
@import ReactiveCocoa;
@import JSONKit;

static NSMutableArray<THRead*> *s_data = nil;
static NSMutableDictionary  *s_readProgress;

@interface THReadList()<NetWorkManagerDelegate>

@property (nonatomic, copy) uploadResultBlock block;
@property (nonatomic, retain) NSMutableArray *nets;

@end

@implementation THReadList

-(NSMutableArray*)nets
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _nets = [NSMutableArray array];
    });
    return _nets;
}

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
        
        void(^resave)(id) = ^(id x){
            [THReadList storageData];
        };
        [[s_data rac_signalForSelector:@selector(insertObject:atIndex:)] subscribeNext:resave];
        [[s_data rac_signalForSelector:@selector(addObject:)] subscribeNext:resave];
        [[s_data rac_signalForSelector:@selector(removeObject:)] subscribeNext:resave];
        [[s_data rac_signalForSelector:@selector(removeObjectAtIndex:)] subscribeNext:resave];
        [[s_data rac_signalForSelector:@selector(addObjectsFromArray:)] subscribeNext:resave];
    }
    return s_data;
}

+(NSMutableDictionary<NSString*, NSArray<THReadProgress*>*>*)readProgress
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
        
        //删除
        [[s_readProgress rac_signalForSelector:@selector(removeObjectForKey:)] subscribeNext:^(RACTuple *key) {
            [[EGOCache globalCache] removeCacheForKey:key.first];
        }];
        //修改
        [[s_readProgress rac_signalForSelector:@selector(setValue:forKey:)] subscribeNext:^(RACTuple *vk) {
            [EGOCache globalCache].defaultTimeoutInterval = 10 * 365 * 24 * 3600; //10年有效期
            [[EGOCache globalCache] setObject:vk.first forKey:vk.second];
        }];
        [[s_readProgress rac_signalForSelector:@selector(setObject:forKey:)] subscribeNext:^(RACTuple *vk) {
            [EGOCache globalCache].defaultTimeoutInterval = 10 * 365 * 24 * 3600; //10年有效期
            [[EGOCache globalCache] setObject:vk.first forKey:vk.second];
        }];
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
    if (read.page.integerValue == 0 || read.deadline.integerValue == 0)
    {
        return NO;
    }
    for (THRead *r in s_data)
    {
        if ([r.rID isEqualToString:read.rID])
        {
            NSString *auther = read.author ? read.author : @"";
            THRead *rd = [THRead initWithBookName:read.bookName Author:[auther stringByAppendingString:@"※"] PageNum:[read.page integerValue] Deadline:[read.deadline integerValue]];
            [THReadList AddData:rd];
            return YES;
        }
    }
    [s_data insertObject:read atIndex:0];
    
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
    [READ_PROGRESS removeObjectForKey:key];
    return NO;
}

+(BOOL)DelData:(THRead *)read
{
    NSString *key = [NSString stringWithFormat:@"com.readlist.%@", read.rID];
    [READ_PROGRESS removeObjectForKey:key];
    
    [s_data removeObject:read];
    return NO;
}

+(BOOL)EditPage:(NSUInteger)page Read:(THRead *)read
{
    page = MIN(page, read.page.unsignedIntegerValue);
    
    NSMutableArray<THReadProgress*> *newData = [NSMutableArray array];
    
    NSString *key = [NSString stringWithFormat:@"com.readlist.%@", read.rID];
    NSArray *arr = READ_PROGRESS[key];
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
    
    [READ_PROGRESS setValue:newData forKey:key];
    
    //当已经读完，就重新排序
    if (page == read.page.unsignedIntegerValue)
    {
        [THReadList SortBooksAsReadProgress];
    }
    
    return YES;
}

+(NSUInteger)lastPageProgressForReadID:(NSString*)rID
{
    NSString *key = [NSString stringWithFormat:@"com.readlist.%@", rID];
    NSArray<THReadProgress*> *arr = READ_PROGRESS[key];
    
    if (arr && arr.count > 0)
    {
        return [arr lastObject].page.unsignedIntegerValue;
    }
    
    return 0;
}

+(NSUInteger)lastDayProgressForReadID:(NSString*)rID
{
    NSString *key = [NSString stringWithFormat:@"com.readlist.%@", rID];
    NSArray<THReadProgress*> *arr = READ_PROGRESS[key];
    
    if (arr && arr.count > 0)
    {
        return [arr lastObject].day.unsignedIntegerValue;
    }
    
    return 0;
}

+(NSArray<THReadProgress*>*)getReadProgressFromReadID:(NSString *)rID
{
    NSString *key = [NSString stringWithFormat:@"com.readlist.%@", rID];
    NSArray<THReadProgress*> *arr = READ_PROGRESS[key];
    
    if (arr && arr.count > 0)
    {
        return arr;
    }
    return nil;
}

+(BOOL)DelReadProgressDataForLast:(THRead *)read
{
    NSString *key = [NSString stringWithFormat:@"com.readlist.%@", read.rID];
    NSArray<THReadProgress*> *arr = READ_PROGRESS[key];
    
    if (arr && arr.count > 0)
    {
        NSMutableArray *newData = [NSMutableArray arrayWithArray:arr];
        THReadProgress *rp = newData.lastObject;
        [newData removeLastObject];
        if (newData.count == 0)
        {
            [READ_PROGRESS removeObjectForKey:key];
        }
        else
        {
            [READ_PROGRESS setValue:newData forKey:key];
        }
        
        if (rp.page.unsignedIntegerValue >= read.page.unsignedIntegerValue)
        {
            [THReadList SortBooksAsReadProgress];
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

-(void)UploadDataWithHost:(NSString *)host resultBlock:(uploadResultBlock)block
{
    self.block = block;
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:[THReadList books].count];
    for (THRead *r in [THReadList books]) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:r.dictinary];
        NSArray *prcs = [THReadList getReadProgressFromReadID:r.rID];
        NSMutableArray *ps = [NSMutableArray arrayWithCapacity:prcs.count];
        for (THReadProgress *p in prcs) {
            [ps addObject:p.dictinary];
        }
        [dic setValue:ps forKey:@"process"];
        [arr addObject:dic];
    }
    
    NetWorkManager *net = [[NetWorkManager alloc] init];
    net.delegate = self;
    [net SaveReadProcessWithData:[arr JSONString] Host:host];
    [self.nets addObject:net];
}

-(void)uploadReadProcess:(NSDictionary *)Result sender:(NetWorkManager *)sender
{
    self.block(Result);
    [self.nets removeObject:sender];
}
@end
