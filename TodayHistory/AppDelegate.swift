//
//  AppDelegate.swift
//  TodayHistory
//
//  Created by 谭伟 on 15/9/9.
//  Copyright (c) 2015年 谭伟. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let tabbarCtrl = self.window!.rootViewController
        let vc0 = tabbarCtrl?.childViewControllers[0]
        let vc1 = tabbarCtrl?.childViewControllers[1]
        let vc2 = tabbarCtrl?.childViewControllers[2]
        vc0?.tabBarItem.image = IonIcons.imageWithIcon(ion_ios_calculator, size: 27.0, color: UIColor.blackColor())
        vc0?.tabBarItem.selectedImage = IonIcons.imageWithIcon(ion_ios_calculator, size: 27.0, color: Colors.main)
        vc0?.tabBarItem.title = "日期计算"
        vc0?.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:Colors.main], forState: UIControlState.Selected)
        vc0?.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.blackColor()], forState: UIControlState.Normal)
        
        vc1?.tabBarItem.image = IonIcons.imageWithIcon(ion_ios_calendar, size: 27.0, color: UIColor.blackColor())
        vc1?.tabBarItem.selectedImage = IonIcons.imageWithIcon(ion_ios_calendar, size: 27.0, color: Colors.main)
        vc1?.tabBarItem.title = "历史今天"
        vc1?.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:Colors.main], forState: UIControlState.Selected)
        vc1?.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.blackColor()], forState: UIControlState.Normal)
        
        vc2?.tabBarItem.image = IonIcons.imageWithIcon(ion_ios_book_outline, size: 27.0, color: UIColor.blackColor())
        vc2?.tabBarItem.selectedImage = IonIcons.imageWithIcon(ion_ios_book_outline, size: 27.0, color: Colors.main)
        vc2?.tabBarItem.title = "词典"
        vc2?.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:Colors.main], forState: UIControlState.Selected)
        vc2?.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.blackColor()], forState: UIControlState.Normal)
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

