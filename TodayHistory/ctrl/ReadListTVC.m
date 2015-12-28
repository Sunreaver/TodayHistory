//
//  ReadListTVC.m
//  TodayHistory
//
//  Created by 谭伟 on 15/12/28.
//  Copyright © 2015年 谭伟. All rights reserved.
//

#import "ReadListTVC.h"
#import "THReadList.h"
#import "THRead.h"

@import DGElasticPullToRefresh_CanStartLoading;
@import ionicons;
@import SWTableViewCell;

@interface ReadListTVC()<SWTableViewCellDelegate>

@property (nonatomic, retain) NSString *curRID;
@property (nonatomic, assign) NSInteger curPage;

@end

@implementation ReadListTVC

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //左右按钮
    UIImage *add = [IonIcons imageWithIcon:ion_ios_plus
                                       size:27
                                      color:[UIColor whiteColor]];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithImage:add
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(AddData)];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    
    UIImage *graph = [IonIcons imageWithIcon:ion_arrow_graph_up_right
                                       size:27
                                      color:[UIColor whiteColor]];
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:graph
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(AddData)];
    self.navigationItem.leftBarButtonItem = leftBar;
    
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
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [sself.tableView dg_stopLoading];
            });
        }
    } loadingView:loading];
    [self.tableView dg_setPullToRefreshBackgroundColor:self.tableView.backgroundColor];
    [self.tableView dg_setPullToRefreshFillColor:self.navigationController.navigationBar.barTintColor];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView dg_startLoading];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)AddData
{
    [self performSegueWithIdentifier:@"showAddBook" sender:self];
}

-(void)ShowGraph
{
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [THReadList data].count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SWTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"read_cell" forIndexPath:indexPath];
    
    THRead *read = [THReadList data][indexPath.row];
    
    [cell.textLabel setText:[NSString stringWithFormat:@"《%@》", read.bookName]];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@/%@", @([THReadList cuePageProgress:read.rID]), read.page]];
    
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
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:153.0/255.0 green:241.0/255.0 blue:88.0/255.0 alpha:1.0f]
                                                title:@"+1"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:160.0/255.0 green:216.0/255.0 blue:120.0/255.0 alpha:1.0]
                                                title:@"+10"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:140.0/255.0 green:179.0/255.0 blue:62.0/255.0 alpha:1.0f]
                                                title:@"+100"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:155.0/255.0 green:155.0/255.0 blue:6.0/255.0 alpha:1.0f]
                                                title:@"CA"];
    
    return rightUtilityButtons;
}

- (NSArray *)leftButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor redColor]
                                                icon:[IonIcons imageWithIcon:ion_ios_trash size:27 color:[UIColor whiteColor]]];
    
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
{//删除
    [cell hideUtilityButtonsAnimated:YES];
    
    NSIndexPath *ip = [self.tableView indexPathForCell:cell];
    THRead *read = [THReadList data][ip.row];
    [THReadList DelData:read.rID];
    [self.tableView deleteRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{//
    self.curPage += index == 0 ? 1 : (index == 1 ? 10 : 100);
    
    if (index == 3) {
        self.curPage = [THReadList cuePageProgress:self.curRID];
    }
    
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"+%@", @(self.curPage)]];
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state
{
    if (state == kCellStateRight)
    {
        NSIndexPath *ip = [self.tableView indexPathForCell:cell];
        THRead *read = [THReadList data][ip.row];
        self.curRID = read.rID;
        self.curPage = [THReadList cuePageProgress:read.rID];
    }
    else if (state == kCellStateCenter && self.curRID)
    {//有改变
        if (self.curPage > 0) {
            [THReadList EditPage:self.curPage ReadID:self.curRID];
        }
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@/%@", @(self.curPage), @([THReadList cuePageProgress:self.curRID])]];
        self.curRID = nil;
        self.curPage = 0;
    }
    else
    {
        self.curRID = nil;
        self.curPage = 0;
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    return YES;
}

@end
