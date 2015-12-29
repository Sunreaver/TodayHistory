//
//  ReadTableViewCell.m
//  TodayHistory
//
//  Created by 谭伟 on 15/12/29.
//  Copyright © 2015年 谭伟. All rights reserved.
//

#import "ReadTableViewCell.h"
#import "UserDef.h"

@interface ReadTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *v_timeProgress;
@property (weak, nonatomic) IBOutlet UIView *v_readProgress;


@end

@implementation ReadTableViewCell

-(void)awakeFromNib
{
    self.v_timeProgress.backgroundColor = [UIColor colorWithRed:234.0/255.0 green:67.0/255.0 blue:53.0/255.0 alpha:1.0];
    self.v_readProgress.backgroundColor = [UIColor colorWithRed:52.0/255.0 green:168.0/255.0 blue:83.0/255.0 alpha:1.0f];
}

-(void)setReadProgress:(CGFloat)readProgress
{
    readProgress = MAX(0.01, MIN(1.0, readProgress));
    _readProgress = readProgress;
    
    [self removeConstraintForView:self.contentView WithID:@"1001"];
    
    NSLayoutConstraint *cns = [NSLayoutConstraint constraintWithItem:self.v_readProgress attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeHeight multiplier:_readProgress constant:0];
    cns.identifier = @"1001";
    
    [self.contentView addConstraint:cns];
    [self setColorForView:self.v_readProgress WithProgress:_readProgress];
}

-(void)setTimeProgress:(CGFloat)timeProgress
{
    timeProgress = MAX(0.01, MIN(1.0, timeProgress));
    _timeProgress = timeProgress;
    
    [self removeConstraintForView:self.contentView WithID:@"1002"];
    
    NSLayoutConstraint *cns = [NSLayoutConstraint constraintWithItem:self.v_timeProgress attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeHeight multiplier:_timeProgress constant:0];
    cns.identifier = @"1002";
    
    [self.contentView addConstraint:cns];
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
        [v setBackgroundColor:[UIColor blackColor]];
    }
}
@end
