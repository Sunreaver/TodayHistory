//
//  DMDate.h
//  DateMethod
//
//  Created by 谭伟 on 15/7/22.
//  Copyright (c) 2015年 谭伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMDate : NSObject

@property (nonatomic, retain, readonly) NSString *start;
@property (nonatomic, retain, readonly) NSString *end;
@property (nonatomic, retain, readonly) NSString *day;

+(instancetype)newWithStartDate:(NSDate*)s EndDate:(NSDate*)e;
+(instancetype)newWithStartDate:(NSDate*)s Day:(NSInteger)d;

//- (instancetype)init NS_UNAVAILABLE;
@end
