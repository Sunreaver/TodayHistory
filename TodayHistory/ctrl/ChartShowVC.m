//
//  ChartShowVC.m
//  TodayHistory
//
//  Created by 谭伟 on 15/12/29.
//  Copyright © 2015年 谭伟. All rights reserved.
//

#import "ChartShowVC.h"
#import "THReadBook.h"
#import "THReadList.h"
#import "TodayHistory-Swift.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UserDef.h"
#import "NSDate+EarlyInTheMorning.h"
#import "StrongWeakSelf.h"

@import Charts;
@import ionicons;

typedef void (^SaveImageCompletion)(NSError *error);

static const CGFloat x_minScale = 11.f;
static const CGFloat y_minScale = 400.f;

@interface ChartShowVC()<ChartViewDelegate>
@property (weak, nonatomic) IBOutlet LineChartView *chartView;

@end

@implementation ChartShowVC

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //左右按钮
    UIImage *add = [IonIcons imageWithIcon:ion_ios_download_outline
                                      size:27
                                     color:[UIColor whiteColor]];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithImage:add
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(AddData)];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.chartView.backgroundColor = [UIColor clearColor];
    [self initChartView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIDevice currentDevice] setValue: [NSNumber numberWithInteger: UIInterfaceOrientationLandscapeLeft] forKey:@"orientation"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIDevice currentDevice] setValue: [NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey:@"orientation"];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setData];
}

-(void)AddData
{
    UIImage *image = [self snapshot:self.view];
    
    NSArray *activityItems = @[image];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    
    activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact,
                                         UIActivityTypeAddToReadingList,
                                         UIActivityTypePostToVimeo,
                                         UIActivityTypeOpenInIBooks];
    
    @weakify_self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            @strongify_self;
            //以模态的方式展现activityVC。
            [self presentViewController:activityVC animated:YES completion:nil];
        });
    });
}

#pragma mark - Private method
- (UIImage *)snapshot:(UIView *)view
{
    CGRect rt = [view bounds];
    UIGraphicsBeginImageContextWithOptions(rt.size, NO, 0.0);
    [view drawViewHierarchyInRect:rt afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(void)initChartView
{
    _chartView.delegate = self;
    
    _chartView.descriptionText = [NSString stringWithFormat:@"《%@》", self.read.bookName];;
    _chartView.noDataTextDescription = @"无阅读数据.";
    
    _chartView.dragEnabled = YES;
    [_chartView setScaleEnabled:YES];
    _chartView.pinchZoomEnabled = YES;
    _chartView.drawGridBackgroundEnabled = NO;
    
    BalloonMarker *marker = [[BalloonMarker alloc] initWithColor:self.navigationController.navigationBar.barTintColor font:[UIFont systemFontOfSize:11.0] insets: UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0)];
    marker.minimumSize = CGSizeMake(80.f, 40.f);
    _chartView.marker = marker;
    
    //右侧截止线
    ChartLimitLine *llXAxis = [[ChartLimitLine alloc] initWithLimit:self.read.deadline.doubleValue label:@""];
    llXAxis.lineWidth = 2.0;
    llXAxis.lineDashLengths = @[@(10.f), @(10.f), @(0.f)];
    llXAxis.labelPosition = ChartLimitLabelPositionRightBottom;
    llXAxis.valueFont = [UIFont systemFontOfSize:10.f];
    [_chartView.xAxis addLimitLine:llXAxis];
    
    //页数最大值
    ChartLimitLine *ll1 = [[ChartLimitLine alloc] initWithLimit:self.read.page.doubleValue label:@"总页码"];
    ll1.lineWidth = 2.0;
    ll1.lineColor = UIColor.blackColor;
    ll1.lineDashLengths = @[@5.f, @5.f];
    ll1.labelPosition = ChartLimitLabelPositionLeftBottom;
    ll1.valueFont = [UIFont systemFontOfSize:10.0];
    
    //配置x，y坐标属性
    ChartYAxis *leftAxis = _chartView.leftAxis;
    [leftAxis removeAllLimitLines];
    [leftAxis addLimitLine:ll1];
    leftAxis.customAxisMax = self.read.page.doubleValue * 1.1;
    leftAxis.customAxisMin = 0.0;
    leftAxis.startAtZeroEnabled = YES;
    leftAxis.gridLineDashLengths = @[@5.f, @5.f];
    leftAxis.drawLimitLinesBehindDataEnabled = YES;
    
    //不显示右侧坐标
    _chartView.rightAxis.enabled = NO;
    
    _chartView.legend.form = ChartLegendFormLine;
    [_chartView.viewPortHandler setMaximumScaleY: MAX(1.f, self.read.page.doubleValue / y_minScale)];
    [_chartView animateWithXAxisDuration:2.5 easingOption:ChartEasingOptionEaseInOutQuart];
}

- (void)setData
{
    NSArray<THReadProgress*> *data = [THReadList getReadProgressFromReadID:self.read.rID];
    if (!data)
    {
        return;
    }
    
    NSUInteger lastReadDay = data.lastObject.day.unsignedIntegerValue;
    lastReadDay = MAX(lastReadDay + 2, self.read.deadline.unsignedIntegerValue + 2);
    [_chartView.viewPortHandler setMaximumScaleX: (double)lastReadDay / x_minScale];
    
    NSUInteger today = ([[NSDate date] earlyInTheMorning].timeIntervalSince1970 - self.read.startDate.timeIntervalSince1970)/24/3600;
    if (today == data.lastObject.day.unsignedIntegerValue ||
        data.lastObject.page.unsignedIntegerValue >= self.read.page.unsignedIntegerValue)
    {//今天已经有数据
     //阅读已经完毕
        today = NSUIntegerMax;
    }
    
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < lastReadDay; i++)
    {
        [xVals addObject:[@(i) stringValue]];
    }
    
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < data.count; i++)
    {
        [yVals addObject:[[ChartDataEntry alloc] initWithValue:data[i].page.unsignedIntegerValue
                                                        xIndex:data[i].day.unsignedIntegerValue]];
    }
    
    if (today != NSUIntegerMax)
    {
        [yVals addObject:[[ChartDataEntry alloc] initWithValue:data.lastObject.page.unsignedIntegerValue
                                                        xIndex:today]];
    }
    
    LineChartDataSet *set1 = [[LineChartDataSet alloc] initWithYVals:yVals
                                                               label:[NSString stringWithFormat:@"实际进度(%@)", [self.read.startDate yyyyMMddStringValue]]];
    
    set1.lineDashLengths = @[@5.f, @2.5f];
    set1.highlightLineDashLengths = @[@5.f, @2.5f];
    [set1 setColor:Google_Color1];
    [set1 setCircleColor:UIColor.blackColor];
    set1.lineWidth = 2.0;
    set1.circleRadius = 3.0;
    set1.drawCircleHoleEnabled = NO;
    set1.valueFont = [UIFont systemFontOfSize:9.f];
    set1.fillAlpha = 65/255.0;
    set1.fillColor = UIColor.blackColor;
    
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    //起始点
    [yVals1 addObject:[[ChartDataEntry alloc] initWithValue:0.0
                                                     xIndex:0.0]];
    //今日应该到的点
    today = ([[NSDate date] earlyInTheMorning].timeIntervalSince1970 - self.read.startDate.timeIntervalSince1970)/24/3600;
    if (data.lastObject.page.unsignedIntegerValue < self.read.page.unsignedIntegerValue &&
        today < self.read.deadline.integerValue &&
        ABS(self.read.page.doubleValue * today / self.read.deadline.integerValue - data.lastObject.page.doubleValue) > 30)
    {//阅读未完毕
     //未超时
     //预期与实际差距在30页以上
        [yVals1 addObject:[[ChartDataEntry alloc] initWithValue:self.read.page.doubleValue * today / self.read.deadline.integerValue
                                                         xIndex:today]];
    }
    
    //完结点
    [yVals1 addObject:[[ChartDataEntry alloc] initWithValue:self.read.page.doubleValue
                                                     xIndex:self.read.deadline.integerValue]];
    
    LineChartDataSet *set2 = [[LineChartDataSet alloc] initWithYVals:yVals1
                                                               label:@"理论进度"];
    
    set2.lineDashLengths = @[@5.f, @2.5f];
    set2.highlightLineDashLengths = @[@5.f, @2.5f];
    [set2 setColor:Google_Color2];
    [set2 setCircleColor:Google_Color0];
    set2.lineWidth = 1.0;
    set2.circleRadius = 4.0;
    set2.drawCircleHoleEnabled = NO;
    set2.valueFont = [UIFont systemFontOfSize:9.f];
    set2.fillAlpha = 65/255.0;
    set2.fillColor = UIColor.blackColor;
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    [dataSets addObject:set2];
    
    LineChartData *chartData = [[LineChartData alloc] initWithXVals:xVals dataSets:dataSets];
    
    _chartView.data = chartData;
    
    [_chartView animateWithYAxisDuration:1.333 easingOption:ChartEasingOptionEaseInCubic];
}

@end
