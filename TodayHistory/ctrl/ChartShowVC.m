//
//  ChartShowVC.m
//  TodayHistory
//
//  Created by 谭伟 on 15/12/29.
//  Copyright © 2015年 谭伟. All rights reserved.
//

#import "ChartShowVC.h"
#import "THRead.h"
#import "THReadList.h"
#import "TodayHistory-Swift.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UserDef.h"

@import Charts;
@import ionicons;

typedef void (^SaveImageCompletion)(NSError *error);

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
    
    WEAK_SELF(weakself);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            STRONG_SELF(weakself, sself);
            //以模态的方式展现activityVC。
            [sself presentViewController:activityVC animated:YES completion:nil];
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
    ChartLimitLine *llXAxis = [[ChartLimitLine alloc] initWithLimit:self.read.deadline.doubleValue label:@"止"];
    llXAxis.lineWidth = 2.0;
    llXAxis.lineDashLengths = @[@(10.f), @(10.f), @(0.f)];
    llXAxis.labelPosition = ChartLimitLabelPositionRightBottom;
    llXAxis.valueFont = [UIFont systemFontOfSize:10.f];
    
    [_chartView.xAxis addLimitLine:llXAxis];
    
    
    //配置x，y坐标属性
    ChartYAxis *leftAxis = _chartView.leftAxis;
    [leftAxis removeAllLimitLines];
    leftAxis.customAxisMax = self.read.page.doubleValue;
    leftAxis.customAxisMin = 0.0;
    leftAxis.startAtZeroEnabled = YES;
    leftAxis.gridLineDashLengths = @[@5.f, @5.f];
    leftAxis.drawLimitLinesBehindDataEnabled = YES;
    
    //不显示右侧坐标
    _chartView.rightAxis.enabled = NO;
    
    [_chartView.viewPortHandler setMaximumScaleY: 2.f];
    [_chartView.viewPortHandler setMaximumScaleX: 2.f];
    
    _chartView.legend.form = ChartLegendFormLine;
    
    [_chartView animateWithXAxisDuration:2.5 easingOption:ChartEasingOptionEaseInOutQuart];
}

- (void)setData
{
    NSArray<THReadProgress*> *data = [THReadList getReadProgressFromReadID:self.read.rID];
    if (!data)
    {
        return;
    }
    
    NSUInteger curDay = data.lastObject.curDay.unsignedIntegerValue;
    curDay = MAX(curDay + 2, self.read.deadline.unsignedIntegerValue + 2);
    
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < curDay; i++)
    {
        [xVals addObject:[@(i) stringValue]];
    }
    
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < data.count; i++)
    {
        [yVals addObject:[[ChartDataEntry alloc] initWithValue:data[i].curPage.unsignedIntegerValue
                                                        xIndex:data[i].curDay.unsignedIntegerValue]];
    }
    
    LineChartDataSet *set1 = [[LineChartDataSet alloc] initWithYVals:yVals label:@"阅读进度"];
    
    set1.lineDashLengths = @[@5.f, @2.5f];
    set1.highlightLineDashLengths = @[@5.f, @2.5f];
    [set1 setColor:UIColor.blackColor];
    [set1 setCircleColor:UIColor.blackColor];
    set1.lineWidth = 1.0;
    set1.circleRadius = 3.0;
    set1.drawCircleHoleEnabled = NO;
    set1.valueFont = [UIFont systemFontOfSize:9.f];
    set1.fillAlpha = 65/255.0;
    set1.fillColor = UIColor.blackColor;
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    
    LineChartData *chartData = [[LineChartData alloc] initWithXVals:xVals dataSets:dataSets];
    
    _chartView.data = chartData;
    
    [_chartView animateWithXAxisDuration:1.0];

}

@end
