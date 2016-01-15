//
//  RootTVC.m
//  DateMethod
//
//  Created by 谭伟 on 15/7/22.
//  Copyright (c) 2015年 谭伟. All rights reserved.
//

#import "RootTVC.h"
#import "THDatePickerViewController.h"
#import "DMDate.h"
#import "NSString+DateValue.h"
#import "IonIcons.h"

#define GLOBAL_COLOR [UIColor lightGrayColor]

@interface RootTVC ()<THDatePickerDelegate,
UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lb_start;
@property (weak, nonatomic) IBOutlet UILabel *lb_end;
@property (weak, nonatomic) IBOutlet UITextField *tf_day;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segCtr;

@property (nonatomic, retain) DMDate *dm;
@property (nonatomic, strong) THDatePickerViewController *datePicker;

@end

@implementation RootTVC
-(THDatePickerViewController*)datePicker
{
    if (!_datePicker)
    {
        _datePicker = [THDatePickerViewController datePicker];
        _datePicker.date = [NSDate date];
        _datePicker.delegate = self;
        [_datePicker setAllowClearDate:NO];
        [_datePicker setClearAsToday:YES];
        [_datePicker setAutoCloseOnSelectDate:NO];
        [_datePicker setAllowSelectionOfSelectedDate:YES];
        [_datePicker setDisableHistorySelection:NO];
        [_datePicker setDisableFutureSelection:NO];
        [_datePicker setSelectedBackgroundColor:[UIColor colorWithRed:125/255.0 green:208/255.0 blue:0/255.0 alpha:1.0]];
        [_datePicker setCurrentDateColor:[UIColor colorWithRed:242/255.0 green:121/255.0 blue:53/255.0 alpha:1.0]];
    }
    return _datePicker;
}

-(DMDate*)dm
{
    if (!_dm)
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"yyyyMMdd";
        _dm = [DMDate newWithStartDate:[df dateFromString:@"20150530"] EndDate:[NSDate date]];
    }
    return _dm;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTintColor:GLOBAL_COLOR];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIImage *home = [IonIcons imageWithIcon:ion_ios_home_outline
                                       size:27
                                      color:GLOBAL_COLOR];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithImage:home
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(initView)];
    self.navigationItem.leftBarButtonItem = rightBar;
    
    [self.tf_day setDelegate:self];
    [self initView];
    
    
}

- (void)doA:(NSString *)A withB:(NSString *)B
{
    NSLog(@"A:%@ and B:%@", A, B);
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initView];
}

-(void)updateView
{
    self.lb_start.text = self.dm.start;
    self.lb_end.text = self.dm.end;
    self.tf_day.text = self.dm.day;
}

-(void)initView
{
    self.segCtr.selectedSegmentIndex = 0;
    [self OnSelectType:self.segCtr];
    _dm = nil;
    [self updateView];
}

#pragma mark - Table view data source

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tf_day resignFirstResponder];
    if (indexPath.section == 0 && indexPath.row == 0)
    {//选择开始日期
        self.lb_start.tag = 1;
        self.lb_end.tag = 0;
        self.datePicker.date = [self.lb_start.text dateValue];
        [self.datePicker setDateHasItemsCallback:^BOOL(NSDate *date) {
            return NO;
        }];
        //[self.datePicker slideUpInView:self.view withModalColor:[UIColor lightGrayColor]];
        [self presentSemiViewController:self.datePicker withOptions:@{
                                                                      KNSemiModalOptionKeys.pushParentBack    : @(NO),
                                                                      KNSemiModalOptionKeys.animationDuration : @(0.333),
                                                                      KNSemiModalOptionKeys.shadowOpacity     : @(0.3),
                                                                      }];
    }
    else if (indexPath.section == 1 && indexPath.row == 0 && self.segCtr.selectedSegmentIndex == 0)
    {//选择结束日期
        self.lb_start.tag = 0;
        self.lb_end.tag = 1;
        self.datePicker.date = [self.lb_end.text dateValue];
        [self.datePicker setDateHasItemsCallback:^BOOL(NSDate *date) {
            return NO;
        }];
        //[self.datePicker slideUpInView:self.view withModalColor:[UIColor lightGrayColor]];
        [self presentSemiViewController:self.datePicker withOptions:@{
                                                                      KNSemiModalOptionKeys.pushParentBack    : @(NO),
                                                                      KNSemiModalOptionKeys.animationDuration : @(0.333),
                                                                      KNSemiModalOptionKeys.shadowOpacity     : @(0.3),
                                                                      }];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)OnSelectType:(UISegmentedControl *)sender
{
    [self.tf_day resignFirstResponder];
    
    UITableViewCell *cellEnd = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    UITableViewCell *cellDay = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    
    if (sender.selectedSegmentIndex == 0)
    {//天数
        cellEnd.selectionStyle = UITableViewCellSelectionStyleDefault;
        cellEnd.backgroundColor = [UIColor whiteColor];
        [cellEnd.contentView.subviews[0] setTextColor:[UIColor blackColor]];
        cellDay.backgroundColor = GLOBAL_COLOR;
        [cellDay.contentView.subviews[0] setTextColor:[UIColor whiteColor]];
        [self.tf_day setEnabled:NO];
    }
    else
    {
        cellEnd.selectionStyle = UITableViewCellSelectionStyleNone;
        cellEnd.backgroundColor = GLOBAL_COLOR;
        [cellEnd.contentView.subviews[0] setTextColor:[UIColor whiteColor]];
        cellDay.backgroundColor = [UIColor whiteColor];
        [cellDay.contentView.subviews[0] setTextColor:[UIColor blackColor]];
        [self.tf_day setEnabled:YES];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string containsString:@"\n"])
    {
        [textField resignFirstResponder];
        __weak RootTVC *weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.dm = [DMDate newWithStartDate:[weakSelf.lb_start.text dateValue] Day:[weakSelf.tf_day.text integerValue]];
            [weakSelf updateView];
        });
        return NO;
    }
    const char *s = [string UTF8String];
    char *end = NULL;
    strtoll(s, &end, 10);
    if (end - s != string.length)
    {
        return NO;
    }
    return YES;
}

#pragma mark -DatePicker
-(void)datePickerDonePressed:(THDatePickerViewController *)datePicker
{
    if (self.lb_start.tag == 1)
    {
        if (self.segCtr.selectedSegmentIndex == 0)
        {//算天数
            self.dm = [DMDate newWithStartDate:datePicker.date EndDate:[self.lb_end.text dateValue]];
        }
        else if (self.segCtr.selectedSegmentIndex == 1)
        {
            self.dm = [DMDate newWithStartDate:datePicker.date Day:[self.tf_day.text integerValue]];
        }
    }
    else if (self.lb_end.tag == 1)
    {//只能算天数
        self.dm = [DMDate newWithStartDate:[self.lb_start.text dateValue] EndDate:datePicker.date];
    }
    [self updateView];
    [self.datePicker dismissSemiModalViewWithCompletion:^{
        self.datePicker = nil;
    }];
}

-(void)datePickerCancelPressed:(THDatePickerViewController *)datePicker
{
    [self.datePicker dismissSemiModalViewWithCompletion:^{
        self.datePicker = nil;
    }];
}
@end
