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
 *  @param success 成功与否
 *  @param count   总数
 *  @param safe    safe次数
 *  @param unsafe  unsafe次数
 *  @param today   24h内次数
 */
typedef void(^SexualActivityResultBlock)(BOOL success, NSInteger count, NSInteger safe, NSInteger unsafe, NSInteger today);

/**
 *  咖啡因
 *
 *  @param success 成功与否
 *  @param today   24h内量(mg)
 *  @param sum     总量(mg)
 */
typedef void(^CoffeeResultBlock)(BOOL success, NSInteger today, NSInteger sum);

/**
 *  走路
 *
 *  @param success 成功与否
 *  @param today   24h内量（分钟）
 *  @param sum     总量(分钟)
 */
typedef void(^WorkoutWalkingResultBlock)(BOOL success, NSInteger today, NSInteger sum, NSDate *lastDate);

typedef void(^HealthStoreCompetence)(BOOL success);

typedef enum : NSUInteger {
    SexualActivity_Safe = 1,
    SexualActivity_UnSafe = 0,
} SexualActivity_Type;

@interface HealthStoreManager : NSObject
-(void)regHealthData:(HealthStoreCompetence)block;
-(void)getSexualActivityWithDay:(NSDate*)start EndDay:(NSDate*)end Block:(SexualActivityResultBlock)block;
-(void)getCoffeeWithDay:(NSDate*)start EndDay:(NSDate*)end Block:(CoffeeResultBlock)block;

-(void)setSexualActivityWithDay:(NSDate*)date isSafe:(SexualActivity_Type)type Block:(SexualActivityResultBlock)block;
-(void)setCoffeeWithDay:(NSDate*)date quantity:(double)g Block:(CoffeeResultBlock)block;

-(void)getWorkoutWalkingWithDay:(NSDate*)start EndDay:(NSDate*)end Block:(WorkoutWalkingResultBlock)block;
-(void)setWorkoutWalkingWithDay:(NSDate*)date Block:(WorkoutWalkingResultBlock)block;


@end
