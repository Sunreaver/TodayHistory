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
#import "NSDate+EarlyInTheMorning.h"

@interface TodayTVC ()<NCWidgetProviding>
@property (weak, nonatomic) IBOutlet UILabel *lb_xuan;
@property (weak, nonatomic) IBOutlet UILabel *lb_love;
@property (weak, nonatomic) IBOutlet UIButton *btn_refresh;

@end

@implementation TodayTVC
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.btn_refresh.layer.cornerRadius = 5;
    self.btn_refresh.layer.borderWidth = 1;
    self.btn_refresh.layer.borderColor = [UIColor greenColor].CGColor;
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

- (IBAction)OnRefresh:(UIButton *)sender
{
//    [self.extensionContext openURL:[NSURL URLWithString:@"SwissArmyKnifeToday://action=refreshBadgeNumber"] completionHandler:^(BOOL success) {
//    }];
    [self refreshNewData];
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
    
    [self refreshNewData];
    
    completionHandler(NCUpdateResultNewData);
}

-(void)refreshNewData
{
    NSDate *xuan = [@"20150530" yyyyMMddString2Date];
    NSDate *love = [@"20091115" yyyyMMddString2Date];
    NSDate *end = [[NSDate date] earlyInTheMorning];
    
    NSTimeInterval ti = end.timeIntervalSince1970 - xuan.timeIntervalSince1970;
    ti += ti > 0 ? 3600 : -3600;
    NSInteger iDay = floor(ti/3600.0/24.0);
    self.lb_xuan.text = [@(iDay).stringValue stringByAppendingString:@".day"];
    
    ti = end.timeIntervalSince1970 - love.timeIntervalSince1970;
    ti += ti > 0 ? 3600 : -3600;
    iDay = floor(ti/3600.0/24.0);
    self.lb_love.text = [@(iDay).stringValue stringByAppendingString:@".day"];
    
    self.preferredContentSize = self.tableView.contentSize;
}

@end
