//
//  GetViewCtrlFromStoryboard.m
//  HomeCtrl
//
//  Created by 谭伟 on 15/3/19.
//  Copyright (c) 2015年 &#35885;&#20255;. All rights reserved.
//

#import "GetViewCtrlFromStoryboard.h"

@implementation GetViewCtrlFromStoryboard

+(UIViewController*)ViewCtrlWithStoryboard:(NSString *)StoryboardName Identifier:(NSString *)Identifier
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:StoryboardName bundle:nil];
    UIViewController *vc = [board instantiateViewControllerWithIdentifier:Identifier];
    return vc;
}

@end
