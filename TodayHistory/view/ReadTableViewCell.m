//
//  ReadTableViewCell.m
//  TodayHistory
//
//  Created by 谭伟 on 15/12/29.
//  Copyright © 2015年 谭伟. All rights reserved.
//

#import "ReadTableViewCell.h"
#import "UserDef.h"
#import "UILabel+Roll.h"

//红橙黄绿青蓝紫
static unsigned int rainbow[7] =
{0xFFFF0000, 0xFFFFA500, 0xFFFFFF00, 0xFF00FF00, 0xFF007FFF, 0xFF0000FF, 0xFF8B00FF};

@interface ReadTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *v_headRainbow;
@property (weak, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIView *v_timeProgress;
@property (weak, nonatomic) IBOutlet UIView *v_readProgress;
@property (weak, nonatomic) IBOutlet UIImageView *iv_readover;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_w_constant;

@end

@implementation ReadTableViewCell

-(void)awakeFromNib
{
    self.iv_readover.transform = CGAffineTransformMakeRotation(10.0*M_PI/180);
    self.iv_readover.hidden = YES;
    
    self.view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.view.layer.shadowOffset = CGSizeMake(2, 2);
    self.view.layer.shadowOpacity = 0.2;
    self.view.layer.shadowRadius = 5;
    
//    [self.v_headRainbow setBackgroundColor:YEE_COLOR(rainbow[rand()%7])];
    [self.v_headRainbow setBackgroundColor:YEE_COLOR(0xBF2A363B)];
    
    self.preState = kCellStateCenter;
}

-(void)RollBookNameIfCan
{
    [self.lb_bookName RollIfCanWithOriWidth:self.view.frame.size.width - 8];
}

-(void)setReadProgress:(CGFloat)readProgress
{
    readProgress = MAX(0.01, MIN(1.0, readProgress));
    _readProgress = readProgress;
    
    [self removeConstraintForView:self.view WithID:@"1001"];
    
    NSLayoutConstraint *cns = [NSLayoutConstraint constraintWithItem:self.v_readProgress attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:_readProgress constant:0];
    cns.identifier = @"1001";
    
    [self.view addConstraint:cns];
    [self setColorForView:self.v_readProgress WithProgress:_readProgress];
    if (_readProgress >= 1.0)
    {
        self.v_headRainbow.hidden = NO;
    }
    else
    {
        self.v_headRainbow.hidden = YES;
        if (_readProgress > 0.25)
        {
            self.layout_w_constant.constant = 0;
        }
        else
        {
            self.layout_w_constant.constant = 15;
        }
    }
}

-(void)setTimeProgress:(CGFloat)timeProgress
{
    timeProgress = MAX(0.01, MIN(1.0, timeProgress));
    _timeProgress = timeProgress;
    
    [self removeConstraintForView:self.view WithID:@"1002"];
    
    NSLayoutConstraint *cns = [NSLayoutConstraint constraintWithItem:self.v_timeProgress attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:_timeProgress constant:0];
    cns.identifier = @"1002";
    
    [self.view addConstraint:cns];
    [self setColorForView:self.v_timeProgress WithProgress:_timeProgress];
}

-(void)removeConstraintForView:(UIView*)view WithID:(NSString*)ID
{
    NSMutableArray *ma = [NSMutableArray array];
    for (NSLayoutConstraint *cns in [view constraints]) {
        if ([cns.identifier isEqualToString:ID])
        {
            [ma addObject:cns];
        }
    }
    [view removeConstraints:ma];
}

-(void)setColorForView:(UIView*)v WithProgress:(CGFloat)progress
{
    if (progress < 0.25)
    {
        [v setBackgroundColor:Google_Color0];
    }
    else if (progress < 0.50)
    {
        [v setBackgroundColor:Google_Color1];
    }
    else if (progress < 0.75)
    {
        [v setBackgroundColor:Google_Color2];
    }
    else if (progress < 1.0)
    {
        [v setBackgroundColor:Google_Color3];
    }
    else
    {
        [v setBackgroundColor:YEE_COLOR(0xFF2A363B)];
    }
}

@end
