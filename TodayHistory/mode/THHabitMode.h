//
//  THHabitMode.h
//  TodayHistory
//
//  Created by 谭伟 on 15/12/4.
//  Copyright © 2015年 谭伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THHabitMode : NSObject

@property (nonatomic, retain) NSDate *date;
@property (nonatomic, assign) NSCalendarUnit unit;
@property (nonatomic, assign) NSInteger unitMultiple;//unit的倍数,默认1
@property (nonatomic, retain) NSString *title;

@end
