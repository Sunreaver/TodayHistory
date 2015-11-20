//
//  HealthStoreManager.h
//  TodayHistory
//
//  Created by 谭伟 on 15/11/20.
//  Copyright © 2015年 谭伟. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  SexualActivity结果
 *
 *  @param success 是否成功
 *  @param count   次数
 */
typedef void(^SexualActivityResultBlock)(BOOL success, NSInteger count, NSInteger safe, NSInteger unsafe);

/**
 *  咖啡因
 *
 *  @param success 是否成功
 *  @param g       克
 */
typedef void(^CoffeeResultBlock)(BOOL success, double g);

typedef void(^HealthStoreCompetence)(BOOL success);

typedef enum : NSUInteger {
    SexualActivity_Safe = 1,
    SexualActivity_UnSafe = 0,
} SexualActivity_Type;

@interface HealthStoreManager : NSObject
-(void)regHealthData:(HealthStoreCompetence)block;
-(void)getSexualActivityWithDay:(NSDate*)start EndDay:(NSDate*)end Block:(SexualActivityResultBlock)block;
-(void)getCoffeeWithDay:(NSDate*)start EndDay:(NSDate*)end Block:(CoffeeResultBlock)block;

-(void)setSexualActivityWithDay:(NSDate*)date EndDay:(NSDate*)end isSafe:(SexualActivity_Type)type Block:(SexualActivityResultBlock)block;
-(void)setCoffeeWithDay:(NSDate*)date quantity:(double)g Block:(CoffeeResultBlock)block;

@end
