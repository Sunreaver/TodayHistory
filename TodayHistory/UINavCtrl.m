//
//  UINavCtrl.m
//  HomeCtrl
//
//  Created by 谭伟 on 15/3/18.
//  Copyright (c) 2015年 &#35885;&#20255;. All rights reserved.
//

#import "UINavCtrl.h"

@interface UINavCtrl ()

@end

@implementation UINavCtrl

-(UIViewController*)childViewControllerForStatusBarStyle
{
    return self.topViewController;
}

-(UIViewController*)childViewControllerForStatusBarHidden
{
    return self.topViewController;
}

@end
