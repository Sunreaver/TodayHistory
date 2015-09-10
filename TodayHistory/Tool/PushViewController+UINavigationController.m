//
//  PushViewController+UINavigationController.m
//  SwanHotel
//
//  Created by 谭伟 on 13-7-25.
//  Copyright (c) 2013年 谭伟. All rights reserved.
//

#import <QuartzCore/CAAnimation.h>
#import <QuartzCore/CAMediaTimingFunction.h>
#import "PushViewController+UINavigationController.h"

@implementation UINavigationController (pushViewController)

-(void)pushViewController:(UIViewController *)viewController TransitionType:(NSString*)tp SubType:(NSString*)subTp
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.333];
    [animation setType:tp];
    if(subTp && subTp.length > 0)
    {
        [animation setSubtype:subTp];
    }
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [self.view.layer addAnimation:animation forKey:nil];
    [self pushViewController:viewController animated:NO];
}

-(void)popViewControllerWithTransitionType:(NSString*)tp SubType:(NSString*)subTp
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.333];
    [animation setType:tp];
    if(subTp && subTp.length > 0)
    {
        [animation setSubtype:subTp];
    }
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [self.view.layer addAnimation:animation forKey:nil];
    [self popViewControllerAnimated:NO];
}

-(void)popToRootViewControllerWithTransitionType:(NSString *)tp SubType:(NSString *)subTp
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.333];
    [animation setType:tp];
    if(subTp && subTp.length > 0)
    {
        [animation setSubtype:subTp];
    }
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [self.view.layer addAnimation:animation forKey:nil];
    [self popToRootViewControllerAnimated:NO];
}
@end
