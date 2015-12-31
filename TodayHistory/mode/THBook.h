//
//  THBook.h
//  TodayHistory
//
//  Created by 谭伟 on 15/12/28.
//  Copyright © 2015年 谭伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THBook : NSObject<NSCoding>

@property(nonatomic, retain) NSString *rID; //md5(bookname+page)
@property(nonatomic, retain) NSString *bookName;
@property(nonatomic, retain) NSNumber *page;
@property(nonatomic, retain) NSNumber *deadline;
@property(nonatomic, retain) NSDate *startDate; //默认今天

+(instancetype)initWithBookName:(NSString*)name PageNum:(NSUInteger)page Deadline:(NSUInteger)day;

@end


@interface THReadProgress : NSObject<NSCoding>

@property(nonatomic, retain) NSNumber *page;
@property(nonatomic, retain) NSNumber *day;

+(instancetype)initWithCurPage:(NSUInteger)page CurDay:(NSUInteger)day;

@end
