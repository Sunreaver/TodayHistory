//
//  ReadHeaderTableViewCell.m
//  TodayHistory
//
//  Created by 谭伟 on 15/12/31.
//  Copyright © 2015年 谭伟. All rights reserved.
//

#import "ReadHeaderTableViewCell.h"
#import "THReadList.h"
#import "THRead.h"

@interface ReadHeaderTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *v_readding;
@property (weak, nonatomic) IBOutlet UILabel *v_hadread;
@property (weak, nonatomic) IBOutlet UILabel *v_readprogress;

@end

@implementation ReadHeaderTableViewCell

-(void)awakeFromNib
{
    self.view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.view.layer.shadowOffset = CGSizeMake(3, 3);
    self.view.layer.shadowOpacity = 0.2;
    
    NSInteger readover = 0;
    NSInteger readding = 0;
    NSInteger readfast = 0;
    
    for (THRead *read in [THReadList books]) {
        //有没有阅读完毕
        if ([THReadList cuePageProgress:read.rID] >= read.page.unsignedIntegerValue)
        {
            ++readover;
            continue;
        }
        
        ++readding;
        //进度是否快
        NSUInteger cPage = [THReadList cuePageProgress:read.rID];
        NSUInteger cDay = [THReadList cueDayProgress:read.rID];
        if (cPage != 0 &&
            (cDay == 0 || (double)cPage / (double)cDay >= read.page.doubleValue / read.deadline.doubleValue)) {
            ++readfast;
        }
    }
    
    self.v_readding.text = [NSString stringWithFormat:@"正在阅读：%@本", @(readding)];
    self.v_hadread.text = [NSString stringWithFormat:@"已经阅毕：%@本", @(readover)];
    self.v_readprogress.text = [NSString stringWithFormat:@"进度快：%@本、进度慢：%@本", @(readfast), @(readding - readfast)];
}

@end
