//
//  THReadList.h
//  TodayHistory
//
//  Created by 谭伟 on 15/12/28.
//  Copyright © 2015年 谭伟. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^uploadResultBlock)(NSDictionary *dic);

@class THRead;
@class THReadProgress;

@interface THReadList : NSObject

+(NSArray<THRead*> *)books;

+(BOOL)AddData:(THRead*)read;
+(BOOL)DelDataWithID:(NSString*)rID;
+(BOOL)DelData:(THRead *)read;
+(BOOL)EditPage:(NSUInteger)page Read:(THRead*)read;
+(void)storageData;
+(BOOL)DelReadProgressDataForLast:(THRead*)read;
+(void)SortBooksAsReadProgress;
-(void)UploadDataWithHost:(NSString*)host resultBlock:(uploadResultBlock)block;

+(NSUInteger)lastDayProgressForReadID:(NSString*)rID;
+(NSUInteger)lastPageProgressForReadID:(NSString*)rID;
+(NSArray<THReadProgress*>*)getReadProgressFromReadID:(NSString*)rID;
@end
