//
//  THReadList.h
//  TodayHistory
//
//  Created by 谭伟 on 15/12/28.
//  Copyright © 2015年 谭伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THRead;

@interface THReadList : NSObject

+(NSArray<THRead*> *)data;

+(BOOL)AddData:(THRead*)read;
+(BOOL)DelData:(NSString*)rID;
+(BOOL)EditPage:(NSUInteger)page ReadID:(NSString*)rID;
+(void)storageData;

+(NSUInteger)cuePageProgress:(NSString*)rID;
@end
