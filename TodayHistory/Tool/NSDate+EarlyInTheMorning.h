//
//  NSDate+EarlyInTheMorning.h
//  DateMethod
//
//  Created by 谭伟 on 15/7/22.
//  Copyright (c) 2015年 谭伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (EarlyInTheMorning)

-(NSDate*)earlyInTheMorning;
-(NSString*)yyyyMMddStringValue;

@end

@interface NSString (EarlyInTheMorning)

-(NSDate*)yyyyMMddString2Date;

@end
