//
//  ReadListTVC.m
//  TodayHistory
//
//  Created by 谭伟 on 15/12/28.
//  Copyright © 2015年 谭伟. All rights reserved.
//

#import "ReadListTVC.h"
#import "THReadList.h"
#import "THBook.h"
#import "ReadTableViewCell.h"
#import "NSDate+EarlyInTheMorning.h"
#import "UserDef.h"
#import "ChartShowVC.h"
#import "GetViewCtrlFromStoryboard.h"
#import "ReadHeaderTableViewCell.h"

@import DGElasticPullToRefresh_CanStartLoading;
@import ionicons;
@import SWTableViewCell;

@interface ReadListTVC()<SWTableViewCellDelegate,
UIAlertViewDelegate>
@property (nonatomic, retain) UITableViewCell *curCell;//删除记录
@property (nonatomic, assign) BOOL needRefresh;

@end

@implementation ReadListTVC

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"在读图书";
    
    //左右按钮
    UIImage *add = [IonIcons imageWithIcon:ion_ios_plus
                                       size:27
                                      color:[UIColor whiteColor]];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithImage:add
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(AddData)];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    
    //左右按钮
    UIImage *share = [IonIcons imageWithIcon:ion_share
                                      size:27
                                     color:[UIColor whiteColor]];
    UIBarButtonItem *leftbar = [[UIBarButtonItem alloc] initWithImage:share
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(ShareData)];
    self.navigationItem.leftBarButtonItem = leftbar;
    
    //去除shadowImage
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    //下拉刷新
    DGElasticPullToRefreshLoadingViewCircle *loading = [[DGElasticPullToRefreshLoadingViewCircle alloc] init];
    [loading setTintColor:[UIColor whiteColor]];
    
    __weak __typeof(self)wself = self;
    [self.tableView dg_addPullToRefreshWithActionHandler:^{
        __typeof(wself)sself = wself;
        if (sself) {
            [sself.tableView reloadData];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [sself.tableView dg_stopLoading];
            });
        }
    } loadingView:loading];
    [self.tableView dg_setPullToRefreshBackgroundColor:[UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0]];
    [self.tableView dg_setPullToRefreshFillColor:self.navigationController.navigationBar.barTintColor];
    
    self.needRefresh = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.needRefresh) {
        [self.tableView reloadData];
        self.needRefresh = NO;
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)AddData
{
    self.needRefresh = YES;
    [self performSegueWithIdentifier:@"showAddBook" sender:self];
}

-(void)ShareData
{
    //添加数据
    NSString *textToShare = [self makeShareData];
    
    NSArray *activityItems = @[textToShare];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    
    activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact,
                                         UIActivityTypeSaveToCameraRoll,
                                         UIActivityTypeAddToReadingList,
                                         UIActivityTypePostToFlickr,
                                         UIActivityTypePostToVimeo,
                                         UIActivityTypeOpenInIBooks,
                                         UIActivityTypePostToTwitter,
                                         UIActivityTypePostToFacebook,
                                         UIActivityTypePostToWeibo,
                                         UIActivityTypePostToTencentWeibo];
    
    WEAK_SELF(weakself);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            STRONG_SELF(weakself, sself);
            //以模态的方式展现activityVC。
            [sself presentViewController:activityVC animated:YES completion:nil];
        });
    });
}

-(NSString*)makeShareData
{
    NSMutableString *data = [NSMutableString stringWithFormat:@"\n************(%@)************", [[[NSDate date] earlyInTheMorning] yyyyMMddStringValue]];
    for (THBook *read in [THReadList books])
    {
        [data appendString:@"\n\n"];
        [data appendFormat:@"《%@》（%@）\n", read.bookName, [read.startDate yyyyMMddStringValue]];
        [data appendFormat:@"进度: %@/%@页;\n", @([THReadList lastPageProgressForReadID:read.rID]), read.page];
        [data appendFormat:@"用时: %@/%@天; ", @([THReadList lastDayProgressForReadID:read.rID]), read.deadline];
    }
    [data appendString:@"\n************************************"];
    return data;
}

#pragma mark -tableview

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    return [THReadList books].count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 100;
    }
    return 64;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        ReadHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"readheader_cell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0];
        return cell;
    }
    ReadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"read_cell" forIndexPath:indexPath];
    
    THBook *read = [THReadList books][indexPath.row];
    
    [cell.lb_bookName setText:[NSString stringWithFormat:@"《%@》", read.bookName]];
    [cell.lb_readPage setText:[NSString stringWithFormat:@"%@/%@", @([THReadList lastPageProgressForReadID:read.rID]), read.page]];
    
    cell.readProgress = (double)[THReadList lastPageProgressForReadID:read.rID] / [read.page doubleValue];
    NSInteger day = [[NSDate date] earlyInTheMorning].timeIntervalSince1970 - read.startDate.timeIntervalSince1970;
    day = day / 24 / 3600;
    cell.timeProgress = (double)day / [read.deadline doubleValue];
    
    if (!(indexPath.row % 2))
    {
        [cell setBackgroundColor:self.tableView.backgroundColor];
    }
    else
    {
        [cell setBackgroundColor:[UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0]];
    }
    
    [cell setLeftUtilityButtons:[self leftButtons] WithButtonWidth:64];
    [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:64];
    cell.delegate = self;
    
    return cell;
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:Google_Color0
                                                title:@"+1"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:Google_Color1
                                                title:@"+10"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:Google_Color2
                                                title:@"+50"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:Google_Color3
                                                title:@"CA"];
    
    return rightUtilityButtons;
}

- (NSArray *)leftButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:Google_Color1
                                                icon:[IonIcons imageWithIcon:ion_ios_trash size:27 color:[UIColor whiteColor]]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:Google_Color2
                                                icon:[IonIcons imageWithIcon:ion_ios_undo_outline size:27 color:[UIColor whiteColor]]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:Google_Color0
                                                icon:[IonIcons imageWithIcon:ion_arrow_graph_up_right size:27 color:[UIColor whiteColor]]];
    
    return leftUtilityButtons;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    return v;
}

#pragma mark -SWTableviewCell
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *ip = [self.tableView indexPathForCell:cell];
    THBook *read = [THReadList books][ip.row];
    if (index == 0)
    {//删除
        [cell hideUtilityButtonsAnimated:YES];
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"删除"
                                                     message:[NSString stringWithFormat:@"确认删除《%@》",read.bookName]
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                           otherButtonTitles:@"删除", nil];
        [av show];
        av.tag = 999;
        self.curCell = cell;
    }
    else if (index == 1)
    {//撤销本日阅读
        [cell hideUtilityButtonsAnimated:YES];
        [THReadList DelReadProgressDataForLast:read];
        
        NSUInteger curPage = [THReadList lastPageProgressForReadID:read.rID];
        [((ReadTableViewCell*)cell).lb_readPage setText:[NSString stringWithFormat:@"%@/%@", @(curPage), read.page]];
        ((ReadTableViewCell*)cell).readProgress = (double)(curPage) / [read.page doubleValue];
    }
    else if (index == 2)
    {//查看阅读曲线
        [cell hideUtilityButtonsAnimated:NO];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            ChartShowVC *vc = (ChartShowVC*)StoryboardVC(@"Main", @"ChartShowVC");
            vc.read = read;
            [self.navigationController pushViewController:vc animated:YES];
        });
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{//
    NSIndexPath *ip = [self.tableView indexPathForCell:cell];
    THBook *read = [THReadList books][ip.row];
    
    NSInteger curPage = [((ReadTableViewCell*)cell).lb_readPage.text integerValue];

    curPage += index == 0 ? 1 : (index == 1 ? 10 : 50);
    
    if (index == 3) {
        curPage = [THReadList lastPageProgressForReadID:read.rID];
    }
    
    [((ReadTableViewCell*)cell).lb_readPage setText:[NSString stringWithFormat:@"%@", @(curPage)]];
    ((ReadTableViewCell*)cell).readProgress = (double)curPage / [read.page doubleValue];
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state
{
    static SWCellState preState = kCellStateLeft;
    if (state == kCellStateCenter && preState == kCellStateRight)
    {//有改变
        NSIndexPath *ip = [self.tableView indexPathForCell:cell];
        THBook *read = [THReadList books][ip.row];
        
        NSUInteger curPage = [((ReadTableViewCell*)cell).lb_readPage.text integerValue];
        if (curPage > [THReadList lastPageProgressForReadID:read.rID])
        {//有编辑过
            [THReadList EditPage:curPage Read:read];
        }
        [((ReadTableViewCell*)cell).lb_readPage setText:[NSString stringWithFormat:@"%@/%@", @(curPage), read.page]];
        ((ReadTableViewCell*)cell).readProgress = (double)curPage / [read.page doubleValue];
    }
    else if(state == kCellStateRight)
    {
        NSIndexPath *ip = [self.tableView indexPathForCell:cell];
        THBook *read = [THReadList books][ip.row];
        [((ReadTableViewCell*)cell).lb_readPage setText:[NSString stringWithFormat:@"%@", @([THReadList lastPageProgressForReadID:read.rID])]];
    }
    preState = state;
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    return YES;
}

-(BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    if (state == kCellStateRight)
    {
        NSIndexPath *ip = [self.tableView indexPathForCell:cell];
        THBook *read = [THReadList books][ip.row];
        if ([THReadList lastPageProgressForReadID:read.rID] >= read.page.unsignedIntegerValue)
        {
            return NO;
        }
    }
    return YES;
}

#pragma mark -alertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 999)
    {
        if (buttonIndex == 1)
        {
            NSIndexPath *ip = [self.tableView indexPathForCell:self.curCell];
            THBook *read = [THReadList books][ip.row];
            [THReadList DelData:read];
            [self.tableView deleteRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}
@end
