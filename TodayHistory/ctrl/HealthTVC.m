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
#import <EventKit/EventKit.h>
#import <IonIcons.h>
#import <MBProgressHUD.h>

@interface HealthTVC ()
@property (weak, nonatomic) IBOutlet UIButton *btn_safe;
@property (weak, nonatomic) IBOutlet UIButton *btn_unsafe;
@property (weak, nonatomic) IBOutlet UIButton *btn_coffee;
@property (weak, nonatomic) IBOutlet UIButton *btn_walk;
@property (weak, nonatomic) IBOutlet UILabel *lb_coffee;
@property (weak, nonatomic) IBOutlet UILabel *lb_thing1;
@property (weak, nonatomic) IBOutlet UILabel *lb_walk;

@property (weak, nonatomic) IBOutlet UIButton *btn_wow;
@property (weak, nonatomic) IBOutlet UIButton *btn_addwowtime;
@property (weak, nonatomic) IBOutlet UIButton *btn_reducewowtime;
@property (weak, nonatomic) IBOutlet UILabel *lb_wowtime;


@property (nonatomic, retain) HealthStoreManager *health;
@property (nonatomic, assign) NSInteger iWowTime;
@property (nonatomic, retain) EKEventStore* eventStore;
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

-(void)setIWowTime:(NSInteger)iWowTime
{
    self.lb_wowtime.text = [NSString stringWithFormat:@"%@min", @(iWowTime)];
    _iWowTime = iWowTime;
}

-(EKEventStore*)eventStore
{
    if (!_eventStore)
    {
        _eventStore = [[EKEventStore alloc] init];
    }
    return _eventStore;
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
    self.btn_wow.layer.cornerRadius = 5;
    
    [self.btn_addwowtime setImage:[IonIcons imageWithIcon:ion_plus size:27 color:[UIColor redColor]]
                         forState:UIControlStateNormal];
    [self.btn_reducewowtime setImage:[IonIcons imageWithIcon:ion_minus size:27 color:[UIColor redColor]]
                            forState:UIControlStateNormal];
    
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
                    NSArray *ar = [sself.lb_thing1.text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"-|"]];
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

- (IBAction)OnStartWow:(UIButton *)sender
{
    __weak __typeof(self)wself = self;
    [self.eventStore requestAccessToEntityType:EKEntityTypeReminder
           completion:^(BOOL granted, NSError * _Nullable error) {
               __typeof(wself)sself = wself;
               if (!granted)
               {
                   [sself showAlertWithTip:@"没权限"];
                   return ;
               }
               else if (sself)
               {
                   [sself performSelectorInBackground:@selector(setWowEvent) withObject:nil];
               }
           }];
}

- (IBAction)OnChangeWowTime:(UIButton *)sender
{
    NSInteger i = self.iWowTime;
    if (sender.tag == 1)
    {//add
        i += 30;
        i = i > 120 ? 120 : i;
    }
    else if (sender.tag == 2)
    {//reduce
        i -= 30;
        i = i < 30 ? 30 : i;
    }
    self.iWowTime = i;
}

-(void)setWowEvent
{
    EKReminder *reminder = [EKReminder reminderWithEventStore:self.eventStore];
    reminder.title = @"Wow Time!";
    reminder.priority = 3;
    reminder.calendar = self.eventStore.defaultCalendarForNewReminders;
    [reminder addAlarm:[EKAlarm alarmWithAbsoluteDate:[NSDate dateWithTimeIntervalSinceNow:self.iWowTime * 60]]];
    NSError *err;
    [self.eventStore saveReminder:reminder commit:YES error:&err];
//    EKEvent *event  = [EKEvent eventWithEventStore:self.eventStore];
//    event.title     = @"Wow Time!";
//    event.startDate = [NSDate date];
//    event.endDate   = [NSDate dateWithTimeIntervalSinceNow:self.iWowTime * 60];
//    [event addAlarm:[EKAlarm alarmWithRelativeOffset:self.iWowTime * 60]];
//    [event setCalendar:[self.eventStore defaultCalendarForNewEvents]];
//    NSError *err;
//    [self.eventStore saveEvent:event span:EKSpanThisEvent error:&err];
    if (err)
    {
        [self performSelectorOnMainThread:@selector(showAlertWithTip:) withObject:@"创建失败" waitUntilDone:NO];
    }
    else
    {
        [self performSelectorOnMainThread:@selector(showAlertWithTip:) withObject:@"Enjoy" waitUntilDone:NO];
    }
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
    self.iWowTime = 90;

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

-(void)showAlertWithTip:(NSString*)tip
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = tip;
    hud.detailsLabelText = @"提醒项目";
    hud.mode = MBProgressHUDModeText;
    [hud hide:YES afterDelay:1.0];
}

@end
