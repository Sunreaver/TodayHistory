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

@interface TodayTVC ()<NCWidgetProviding>
@property (weak, nonatomic) IBOutlet UILabel *lb_xuan;
@property (weak, nonatomic) IBOutlet UILabel *lb_love;
@property (weak, nonatomic) IBOutlet UILabel *lb_coffee;

@end

@implementation TodayTVC

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

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    return v;
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
    
    id count = [UserDef getUserDefValue:CoffeeTimeCount];
    count = count == nil ? @(0) : count;
    self.lb_coffee.text = [[count stringValue] stringByAppendingString:@".次"];
    
    self.preferredContentSize = self.tableView.contentSize;
    
    completionHandler(NCUpdateResultNewData);
}

@end
