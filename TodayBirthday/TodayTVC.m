//
//  TodayTVC.m
//  TodayHistory
//
//  Created by 谭伟 on 15/11/19.
//  Copyright © 2015年 谭伟. All rights reserved.
//

#import "TodayTVC.h"
#import "UserDef.h"
#import <NotificationCenter/NotificationCenter.h>
#import "HealthStoreManager.h"

@interface TodayTVC ()<NCWidgetProviding>
@property (weak, nonatomic) IBOutlet UILabel *lb_xuan;
@property (weak, nonatomic) IBOutlet UILabel *lb_love;
@property (weak, nonatomic) IBOutlet UILabel *lb_coffee;
@property (weak, nonatomic) IBOutlet UILabel *lb_thing1;
@property (weak, nonatomic) IBOutlet UIButton *btn_safe;
@property (weak, nonatomic) IBOutlet UIButton *btn_unsafe;

@property (nonatomic, retain) HealthStoreManager *health;
@end

@implementation TodayTVC
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.btn_safe.layer.cornerRadius = 5;
    self.btn_unsafe.layer.cornerRadius = 5;
}
-(HealthStoreManager*)health
{
    if (!_health)
    {
        _health = [[HealthStoreManager alloc] init];
    }
    return _health;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    return v;
}

-(void)setHealthDataWithString:(NSString*)str
{
    if (str)
    {
        self.lb_thing1.text = str;
        self.lb_thing1.textColor = [UIColor whiteColor];
    }
    else
    {
        self.lb_thing1.textColor = [UIColor orangeColor];
    }
}

-(void)setCoffeeDataWithNum:(id)num
{
    if ([num integerValue] >= 0)
    {
        self.lb_coffee.text = [NSString stringWithFormat:@"%0.1lfmg", 1000.0 * [num doubleValue]];
        self.lb_coffee.textColor = [UIColor whiteColor];
    }
    else
    {
        self.lb_coffee.textColor = [UIColor orangeColor];
    }
}

- (IBAction)OnAdd:(UIButton *)sender
{
    sender.enabled = NO;
    __weak __typeof(self)wself = self;
    [self.health setSexualActivityWithDay:[NSDate dateWithTimeIntervalSinceNow:-30*60] EndDay:[NSDate date] isSafe:sender.tag Block:^(BOOL success, NSInteger count, NSInteger safe, NSInteger unsafe) {
        __typeof(wself)sself = wself;
        if (sself && success)
        {
            NSArray *ar = [sself.lb_thing1.text componentsSeparatedByString:@"-"];
            NSInteger c = [ar[0] integerValue] + 1;
            NSInteger s = [ar[1] integerValue] + safe;
            NSInteger us = [ar[2] integerValue] + unsafe;
            [sself performSelectorOnMainThread:@selector(setHealthDataWithString:)
                                    withObject:[NSString stringWithFormat:@"%@-%@-%@", @(c), @(s), @(us)]
                                 waitUntilDone:NO];
        }
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    return v;
}

-(UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
    return UIEdgeInsetsMake(defaultMarginInsets.top, 15, 0, defaultMarginInsets.right);
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyyMMdd";
    NSDate *xuan = [df dateFromString:@"20150530"];
    NSDate *love = [df dateFromString:@"20091115"];
    NSDate *end = [df dateFromString:[df stringFromDate:[NSDate date]]];
    
    NSTimeInterval ti = end.timeIntervalSince1970 - xuan.timeIntervalSince1970;
    ti += ti > 0 ? 3600 : -3600;
    NSInteger iDay = floor(ti/3600.0/24.0);
    self.lb_xuan.text = [@(iDay).stringValue stringByAppendingString:@".day"];
    
    ti = end.timeIntervalSince1970 - love.timeIntervalSince1970;
    ti += ti > 0 ? 3600 : -3600;
    iDay = floor(ti/3600.0/24.0);
    self.lb_love.text = [@(iDay).stringValue stringByAppendingString:@".day"];
    self.lb_thing1.textColor = [UIColor grayColor];
    self.lb_coffee.textColor = [UIColor grayColor];

    __weak __typeof(self)wself = self;
    [self.health getCoffeeWithDay:[NSDate dateWithTimeIntervalSinceNow:-14 * 24 * 3600] EndDay:[NSDate date]
        Block:^(BOOL success, double g) {
            __typeof(wself)sself = wself;
            if (sself && success)
            {
                [sself performSelectorOnMainThread:@selector(setCoffeeDataWithNum:) withObject:@(g) waitUntilDone:NO];
            }
            else if(sself)
            {
                [sself performSelectorOnMainThread:@selector(setCoffeeDataWithNum:) withObject:@(-1) waitUntilDone:NO];
            }
    }];
    
    [self.health getSexualActivityWithDay:[NSDate dateWithTimeIntervalSinceNow:-7 * 24 * 3600] EndDay:[NSDate date]
        Block:^(BOOL success, NSInteger count, NSInteger safe, NSInteger unsafe) {
            __typeof(wself)sself = wself;
            if (sself && success)
            {
                [self performSelectorOnMainThread:@selector(setHealthDataWithString:)
                                        withObject:[NSString stringWithFormat:@"%@-%@-%@", @(count), @(safe), @(unsafe)]
                                     waitUntilDone:NO];
            }
            else if(sself)
            {
                [self performSelectorOnMainThread:@selector(setHealthDataWithString:) withObject:nil waitUntilDone:NO];
            }
    }];
    self.preferredContentSize = self.tableView.contentSize;
    
    completionHandler(NCUpdateResultNewData);
}

@end
