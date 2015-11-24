//
//  HealthTVC.m
//  TodayHistory
//
//  Created by 谭伟 on 15/11/24.
//  Copyright © 2015年 谭伟. All rights reserved.
//

#import "HealthTVC.h"
#import "HealthStoreManager.h"
#import "NSDate+EarlyInTheMorning.h"

@interface HealthTVC ()
@property (weak, nonatomic) IBOutlet UIButton *btn_safe;
@property (weak, nonatomic) IBOutlet UIButton *btn_unsafe;
@property (weak, nonatomic) IBOutlet UIButton *btn_coffee;
@property (weak, nonatomic) IBOutlet UIButton *btn_walk;
@property (weak, nonatomic) IBOutlet UILabel *lb_coffee;
@property (weak, nonatomic) IBOutlet UILabel *lb_thing1;
@property (weak, nonatomic) IBOutlet UILabel *lb_walk;

@property (nonatomic, retain) HealthStoreManager *health;
@end

@implementation HealthTVC
-(HealthStoreManager*)health
{
    if (!_health)
    {
        _health = [[HealthStoreManager alloc] init];
    }
    return _health;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.btn_safe.layer.cornerRadius = 5;
    self.btn_unsafe.layer.cornerRadius = 5;
    self.btn_coffee.layer.cornerRadius = 5;
    self.btn_walk.layer.cornerRadius = 5;
    
    self.navigationItem.title = @"健康";
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.lb_thing1.textColor = [UIColor grayColor];
    self.lb_coffee.textColor = [UIColor grayColor];
    [self refreshNewData];
}

- (IBAction)OnAdd:(UIButton *)sender
{
    sender.enabled = NO;
    __weak __typeof(self)wself = self;
    [self.health setSexualActivityWithDay:[NSDate dateWithTimeIntervalSinceNow:-30*60] isSafe:sender.tag
            Block:^(BOOL success, NSInteger count, NSInteger safe, NSInteger unsafe, NSInteger today) {
                __typeof(wself)sself = wself;
                if (sself && success)
                {
                    NSArray *ar = [sself.lb_thing1.text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@",|"]];
                    NSInteger c = [ar[0] integerValue] + 1;
                    NSInteger s = [ar[1] integerValue] + safe;
                    NSInteger us = [ar[2] integerValue] + unsafe;
                    NSInteger to = [ar[3] integerValue] + today;
                    [sself performSelectorOnMainThread:@selector(setHealthDataWithString:)
                                            withObject:[NSString stringWithFormat:@"%@-%@-%@|%@", @(c), @(s), @(us), @(to)]
                                         waitUntilDone:NO];
                }
                else if (sself)
                {
                    [sself performSelectorOnMainThread:@selector(setHealthDataWithString:)
                                            withObject:nil
                                         waitUntilDone:NO];
                }
            }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
}

- (IBAction)OnAddCoffee:(UIButton *)sender
{
    __weak __typeof(self)wself = self;
    [self.health setCoffeeWithDay:[NSDate date] quantity:0.01 Block:^(BOOL success, NSInteger today, NSInteger sum) {
        __typeof(wself)sself = wself;
        if (sself && success)
        {
            NSString *nomg = [sself.lb_coffee.text substringToIndex:sself.lb_coffee.text.length - 2];
            NSArray *ar = [nomg componentsSeparatedByString:@"/"];
            NSInteger t = [ar[0] integerValue] + today;
            NSInteger s = [ar[1] integerValue] + today;
            [sself performSelectorOnMainThread:@selector(setCoffeeDataWithNum:)
                                    withObject:[NSString stringWithFormat:@"%@/%@mg", @(t), @(s)]
                                 waitUntilDone:NO];
        }
        else if (sself)
        {
            [sself performSelectorOnMainThread:@selector(setCoffeeDataWithNum:)
                                    withObject:nil
                                 waitUntilDone:NO];
        }
    }];
}

- (IBAction)OnSetWalk:(UIButton *)sender
{
    __weak __typeof(self)wself = self;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyyMMddHHmm";
    NSDate *date = [df dateFromString:[[[NSDate date] yyyyMMddStringValue] stringByAppendingString:@"1840"]];
    if (date.timeIntervalSinceNow > 0)
    {
        date = [NSDate dateWithTimeInterval:-24*3600 sinceDate:date];
    }
    
    [self.health setWorkoutWalkingWithDay:date
        Block:^(BOOL success, NSInteger today, NSInteger sum) {
            __typeof(wself)sself = wself;
            if (sself && success)
            {
                NSString *nomin = [sself.lb_walk.text substringToIndex:sself.lb_walk.text.length - 3];
                NSArray *ar = [nomin componentsSeparatedByString:@"/"];
                NSInteger t = [ar[0] integerValue];
                NSInteger s = [ar[1] integerValue];
                t += today;
                s += today;
                [sself performSelectorOnMainThread:@selector(setWalkingDataWithNum:)
                                        withObject:[NSString stringWithFormat:@"%@/%@min", @(t), @(s)]
                                     waitUntilDone:NO];
            }
            else if (sself)
            {
                [sself performSelectorOnMainThread:@selector(setWalkingDataWithNum:)
                                        withObject:nil
                                     waitUntilDone:NO];
            }
        }];
}

-(void)setHealthDataWithString:(NSString*)str
{
    if (str)
    {
        self.lb_thing1.text = str;
        self.lb_thing1.textColor = [UIColor blackColor];
    }
    else
    {
        self.lb_thing1.textColor = [UIColor orangeColor];
    }
}

-(void)setCoffeeDataWithNum:(id)num
{
    if (num)
    {
        self.lb_coffee.text = num;
        self.lb_coffee.textColor = [UIColor blackColor];
    }
    else
    {
        self.lb_coffee.textColor = [UIColor orangeColor];
    }
}

-(void)setWalkingDataWithNum:(id)num
{
    if (num)
    {
        self.lb_walk.text = num;
        self.lb_walk.textColor = [UIColor blackColor];
    }
    else
    {
        self.lb_walk.textColor = [UIColor orangeColor];
    }
}

-(void)refreshNewData
{
    __weak __typeof(self)wself = self;
    [self.health getCoffeeWithDay:[NSDate dateWithTimeIntervalSinceNow:-14 * 24 * 3600] EndDay:[NSDate date]
            Block:^(BOOL success, NSInteger today, NSInteger sum) {
                __typeof(wself)sself = wself;
                if (sself && success)
                {
                    [sself performSelectorOnMainThread:@selector(setCoffeeDataWithNum:)
                                            withObject:[NSString stringWithFormat:@"%@/%@mg", @(today), @(sum)]
                                         waitUntilDone:NO];
                }
                else if(sself)
                {
                    [sself performSelectorOnMainThread:@selector(setCoffeeDataWithNum:) withObject:nil waitUntilDone:NO];
                }
            }];
    
    [self.health getSexualActivityWithDay:[NSDate dateWithTimeIntervalSinceNow:-7 * 24 * 3600] EndDay:[NSDate date]
            Block:^(BOOL success, NSInteger count, NSInteger safe, NSInteger unsafe, NSInteger today) {
                __typeof(wself)sself = wself;
                if (sself && success)
                {
                    [self performSelectorOnMainThread:@selector(setHealthDataWithString:)
                                           withObject:[NSString stringWithFormat:@"%@-%@-%@|%@", @(count), @(safe), @(unsafe), @(today)]
                                        waitUntilDone:NO];
                }
                else if(sself)
                {
                    [self performSelectorOnMainThread:@selector(setHealthDataWithString:) withObject:nil waitUntilDone:NO];
                }
            }];
    
    [self.health getWorkoutWalkingWithDay:[NSDate dateWithTimeIntervalSinceNow:-7 * 24 * 3600]
           EndDay:[NSDate dateWithTimeIntervalSinceNow:24 * 3600]
            Block:^(BOOL success, NSInteger today, NSInteger sum) {
                __typeof(wself)sself = wself;
                if (sself && success)
                {
                    [self performSelectorOnMainThread:@selector(setWalkingDataWithNum:)
                                           withObject:[NSString stringWithFormat:@"%@/%@min", @(today), @(sum)]
                                        waitUntilDone:NO];
                }
                else if(sself)
                {
                    [self performSelectorOnMainThread:@selector(setWalkingDataWithNum:) withObject:nil waitUntilDone:NO];
                }
            }];
}

@end
