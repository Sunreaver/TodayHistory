//
//  PushViewController+UINavigationController.h
//  SwanHotel
//
//  Created by 谭伟 on 13-7-25.
//  Copyright (c) 2013年 谭伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UINavigationController (pushViewController)


/**
 *  push动画
 *
 *  @param viewController vc
 *  @param tp             主动画
 *  @param subTp          kCATransitionFromLeft
 */
-(void)pushViewController:(UIViewController *)viewController TransitionType:(NSString*)tp SubType:(NSString*)subTp;
-(void)popViewControllerWithTransitionType:(NSString*)tp SubType:(NSString*)subTp;
-(void)popToRootViewControllerWithTransitionType:(NSString*)tp SubType:(NSString*)subTp;

@end
