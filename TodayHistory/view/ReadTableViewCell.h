//
//  ReadTableViewCell.h
//  TodayHistory
//
//  Created by 谭伟 on 15/12/29.
//  Copyright © 2015年 谭伟. All rights reserved.
//

@import SWTableViewCell;

@interface ReadTableViewCell : SWTableViewCell

@property(nonatomic, assign) CGFloat readProgress;
@property(nonatomic, assign) CGFloat timeProgress;
@property (weak, nonatomic) IBOutlet UILabel *lb_bookName;
@property (weak, nonatomic) IBOutlet UILabel *lb_readPage;
@property (weak, nonatomic) IBOutlet UILabel *lb_readSpeed;

@property (nonatomic, assign) SWCellState preState;

-(void)RollBookNameIfCan;
@end
