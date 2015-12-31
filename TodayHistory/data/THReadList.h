//
//  THReadList.h
//  TodayHistory
//
//  Created by 谭伟 on 15/12/28.
//  Copyright © 2015年 谭伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THBook;
@class THReadProgress;

@interface THReadList : NSObject

+(NSArray<THBook*> *)books;

+(BOOL)AddData:(THBook*)read;
+(BOOL)DelDataWithID:(NSString*)rID;
+(BOOL)DelData:(THBook *)read;
+(BOOL)EditPage:(NSUInteger)page Read:(THBook*)read;
+(void)storageData;
+(BOOL)DelReadProgressDataForLast:(THBook*)read;

+(NSUInteger)lastDayProgressForReadID:(NSString*)rID;
+(NSUInteger)lastPageProgressForReadID:(NSString*)rID;
+(NSArray<THReadProgress*>*)getReadProgressFromReadID:(NSString*)rID;
@end
