//
//  GetViewCtrlFromStoryboard.h
//  HomeCtrl
//
//  Created by 谭伟 on 15/3/19.
//  Copyright (c) 2015年 &#35885;&#20255;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define StoryboardVC(storyboardName, identifier) [GetViewCtrlFromStoryboard ViewCtrlWithStoryboard:storyboardName Identifier:identifier]

@interface GetViewCtrlFromStoryboard : NSObject

+(UIViewController*)ViewCtrlWithStoryboard:(NSString*)StoryboardName Identifier:(NSString*)Identifier;

@end
