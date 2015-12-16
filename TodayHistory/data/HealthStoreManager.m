//
//  HealthStoreManager.m
//  TodayHistory
//
//  Created by 谭伟 on 15/11/20.
//  Copyright © 2015年 谭伟. All rights reserved.
//

#import "HealthStoreManager.h"
#import <HealthKit/HealthKit.h>
#import "NSDate+EarlyInTheMorning.h"

@interface HealthStoreManager()
@property (nonatomic, retain) HKHealthStore *health;

@end

@implementation HealthStoreManager
-(HKHealthStore*)health
{
    static HKHealthStore *h = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        h = [[HKHealthStore alloc] init];
    });
    return h;
}

-(void)regHealthData:(HealthStoreCompetence)block
{
    if (![HKHealthStore isHealthDataAvailable]) {
        block(NO);
        return ;
    }
    NSMutableSet *w = [NSMutableSet set];
    [w addObject:[HKCategoryType categoryTypeForIdentifier:HKCategoryTypeIdentifierSexualActivity]];
    [w addObject:[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryCaffeine]];
    [w addObject:[HKWorkoutType workoutType]];
    
    [self.health requestAuthorizationToShareTypes:[w copy] readTypes:[w copy] completion:^(BOOL success, NSError * _Nullable error)
     {
         block(success);
     }];
    return ;
}

-(void)getSexualActivityWithDay:(NSDate*)start EndDay:(NSDate*)end Block:(SexualActivityResultBlock)block
{
    if (![HKHealthStore isHealthDataAvailable]) {
        block(NO, 0, 0, 0, 0);
        return;
    }
    
    NSMutableSet *w = [NSMutableSet set];
    [w addObject:[HKCategoryType categoryTypeForIdentifier:HKCategoryTypeIdentifierSexualActivity]];
    
    [self.health requestAuthorizationToShareTypes:nil readTypes:w completion:^(BOOL success, NSError * _Nullable error)
     {
         if (!success)
         {
             block(NO, 0, 0, 0, 0);
             return ;
         }
         NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:start endDate:end options:HKQueryOptionNone];
         NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierStartDate ascending:YES];
         HKSampleQuery *sexual = [[HKSampleQuery alloc]
              initWithSampleType:[HKCategoryType categoryTypeForIdentifier:HKCategoryTypeIdentifierSexualActivity]
              predicate:predicate
              limit:HKObjectQueryNoLimit
              sortDescriptors:@[sort]
              resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
                  NSInteger safe = 0, unsafe = 0, today = 0;
                  for (HKCategorySample *sam in results)
                  {
                      if ([sam.metadata[@"HKSexualActivityProtectionUsed"] integerValue] == SexualActivity_Safe)
                      {
                          ++safe;
                      }
                      else if ([sam.metadata[@"HKSexualActivityProtectionUsed"] integerValue] == SexualActivity_UnSafe)
                      {
                          ++unsafe;
                      }
                      
                      if (sam.startDate.timeIntervalSinceNow > -24 * 3600) {
                          ++today;
                      }
                  }
                  block(YES, results.count, safe, unsafe, today);
              }];
         [self.health executeQuery:sexual];
     }];
}

-(void)setSexualActivityWithDay:(NSDate*)date
                         isSafe:(SexualActivity_Type)type
                          Block:(SexualActivityResultBlock)block
{
    if (![HKHealthStore isHealthDataAvailable]) {
        block(NO, 0, 0, 0, 0);
        return;
    }
    
    NSMutableSet *w = [NSMutableSet set];
    [w addObject:[HKCategoryType categoryTypeForIdentifier:HKCategoryTypeIdentifierSexualActivity]];
    
    NSInteger safe = type == SexualActivity_Safe ? 1 : 0;
    NSInteger unsafe = type == SexualActivity_UnSafe ? 1 : 0;
    [self.health requestAuthorizationToShareTypes:w readTypes:nil completion:^(BOOL success, NSError * _Nullable error)
     {
         if (!success) {
             block(NO, 0, safe, unsafe, 0);
             return ;
         }
         HKCategorySample *quan = [HKCategorySample
                                   categorySampleWithType:[HKCategoryType categoryTypeForIdentifier:HKCategoryTypeIdentifierSexualActivity]
                                   value:0
                                   startDate:date
                                   endDate:[NSDate date]
                                   metadata:@{@"HKSexualActivityProtectionUsed":@(type), @"HKWasUserEntered":@(1)}];
         [self.health saveObject:quan withCompletion:^(BOOL success, NSError * _Nullable error) {
             block(success, 0, safe, unsafe, 1);
         }];
     }];
}

-(void)getCoffeeWithDay:(NSDate*)start EndDay:(NSDate*)end Block:(CoffeeResultBlock)block
{
    if (![HKHealthStore isHealthDataAvailable]) {
        block(NO, 0, 0);
        return;
    }
    
    NSMutableSet *w = [NSMutableSet set];
    [w addObject:[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryCaffeine]];
    
    [self.health requestAuthorizationToShareTypes:nil readTypes:w completion:^(BOOL success, NSError * _Nullable error)
     {
         if (!success)
         {
             block(NO, 0, 0);
             return ;
         }
         NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:start endDate:end options:HKQueryOptionNone];
         NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierStartDate ascending:YES];
         
         HKSampleQuery *caffee = [[HKSampleQuery alloc]
              initWithSampleType:[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryCaffeine]
              predicate:predicate
              limit:HKObjectQueryNoLimit
              sortDescriptors:@[sort]
              resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
                  double g = 0.0, sum = 0.0;
                  for (HKQuantitySample *sam in results)
                  {
                      sum += [sam.quantity doubleValueForUnit:[HKUnit gramUnit]];
                      if ([[sam.startDate yyyyMMddStringValue] isEqualToString:[[NSDate date] yyyyMMddStringValue]]) {
                          g += [sam.quantity doubleValueForUnit:[HKUnit gramUnit]];
                      }
                  }
                  block(YES, g*1000, sum*1000);
              }];
         [self.health executeQuery:caffee];
     }];
}

-(void)setCoffeeWithDay:(NSDate*)date
               quantity:(double)g
                  Block:(CoffeeResultBlock)block
{
    if (![HKHealthStore isHealthDataAvailable]) {
        block(NO, 0.01, 0.01);
        return;
    }
    
    NSMutableSet *w = [NSMutableSet set];
    [w addObject:[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryCaffeine]];
    
    [self.health requestAuthorizationToShareTypes:w readTypes:nil completion:^(BOOL success, NSError * _Nullable error)
     {
         if (!success) {
             block(NO, 0, 0);
         }
         HKQuantity *q = [HKQuantity quantityWithUnit:[HKUnit gramUnit] doubleValue:g];
         HKQuantitySample *quan = [HKQuantitySample
           quantitySampleWithType:[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryCaffeine]
           quantity:q
           startDate:date
           endDate:date
           metadata:@{@"HKWasUserEntered":@(1)}];
         [self.health saveObject:quan withCompletion:^(BOOL success, NSError * _Nullable error) {
             block(success, 10, 10);
         }];
     }];
}

-(void)getWorkoutWalkingWithDay:(NSDate*)start EndDay:(NSDate*)end Block:(WorkoutWalkingResultBlock)block
{
    if (![HKHealthStore isHealthDataAvailable]) {
        block(NO, 0, 0, nil);
        return;
    }
    
    NSMutableSet *w = [NSMutableSet set];
    [w addObject:[HKWorkoutType workoutType]];
    
    [self.health requestAuthorizationToShareTypes:nil readTypes:w completion:^(BOOL success, NSError * _Nullable error)
     {
         if (!success)
         {
             block(NO, 0, 0, nil);
             return ;
         }
         NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:start endDate:end options:HKQueryOptionNone];
         NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierStartDate ascending:YES];
         HKSampleQuery *sexual = [[HKSampleQuery alloc]
              initWithSampleType:[HKWorkoutType workoutType]
              predicate:predicate
              limit:HKObjectQueryNoLimit
              sortDescriptors:@[sort]
              resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
                  NSInteger time = 0, today = 0;
                  NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:0];
                  for (HKWorkout *sam in results)
                  {
                      if (sam.workoutActivityType == HKWorkoutActivityTypeWalking) {
                          ++time;
                          if (-sam.startDate.timeIntervalSinceNow < 7 * 24 * 3600) {
                              ++today;
                          }
                          
                          lastDate = lastDate.timeIntervalSince1970 < sam.startDate.timeIntervalSince1970 ? sam.startDate : lastDate;
                      }
                  }
                  block(YES, today, time, lastDate);
              }];
         [self.health executeQuery:sexual];
     }];
}

-(void)setWorkoutWalkingWithDay:(NSDate*)date
                          Block:(WorkoutWalkingResultBlock)block
{
    if (![HKHealthStore isHealthDataAvailable]) {
        block(NO, 0, 0, nil);
        return ;
    }
    
    NSMutableSet *w = [NSMutableSet set];
    [w addObject:[HKWorkoutType workoutType]];
    
    [self.health requestAuthorizationToShareTypes:w readTypes:nil completion:^(BOOL success, NSError * _Nullable error)
     {
         if (!success) {
             block(NO, 0, 0, nil);
             return ;
         }
         HKWorkout *wo = [HKWorkout
              workoutWithActivityType:HKWorkoutActivityTypeWalking
              startDate:date
              endDate:[date dateByAddingTimeInterval:1*3600]
              duration:0
              totalEnergyBurned:[HKQuantity quantityWithUnit:[HKUnit kilocalorieUnit] doubleValue:234.0]
              totalDistance:[HKQuantity quantityWithUnit:[HKUnit meterUnit] doubleValue:4700.0]
              metadata:@{@"回家":@"今天走回家"}];
         
         [self.health saveObject:wo withCompletion:^(BOOL success, NSError * _Nullable error) {
             block(success, 1, 0, [NSDate date]);
         }];
     }];
}

@end
