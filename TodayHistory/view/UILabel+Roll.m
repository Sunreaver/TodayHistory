//
//  UILabel.m
//  TodayHistory
//
//  Created by 谭伟 on 16/1/15.
//  Copyright © 2016年 谭伟. All rights reserved.
//

#import "UILabel+Roll.h"

@implementation UILabel (AnimationRoll)

-(void)RollIfCanWithOriWidth:(CGFloat)oriWidth
{
    [self.layer removeAllAnimations];
    //取消、停止所有的动画
    CGSize textSize = [self.text sizeWithAttributes:@{NSFontAttributeName:self.font}];
    if (textSize.width > oriWidth) {
        float offset = textSize.width - oriWidth;
        [UIView transitionWithView:self
                          duration:5.0
                           options:UIViewAnimationOptionCurveLinear
                        animations:^{
                            self.transform = CGAffineTransformMakeTranslation(-offset, 0);
                        }
                        completion:^(BOOL finished) {
                            if (finished)
                            {
            [UIView transitionWithView:self
                              duration:5.0
                               options:UIViewAnimationOptionCurveLinear
                            animations:^{
                                self.transform = CGAffineTransformIdentity;
                            }
                            completion:^(BOOL finished) {
                            }];
                            }
                        }];
    }
}

@end
