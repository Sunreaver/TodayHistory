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
        
        self.regNotification()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        application.applicationIconBadgeNumber = self.calculateBadgeNum()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        if identifier == "refreshDay"
        {
            application.applicationIconBadgeNumber = self.calculateBadgeNum()
        }
    }
    
    func regNotification()
    {
        //注册消息
        let action:UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        action.title = "刷新"
        action.identifier = "refreshDay"
        action.activationMode = UIUserNotificationActivationMode.Background
        
        let categorys:UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
        categorys.identifier = "DateCalculate"
        categorys.setActions([action], forContext: UIUserNotificationActionContext.Default)
        //创建UIUserNotificationSettings，并设置消息的显示类类型
        let uns:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: UIUserNotificationType.Badge, categories: NSSet(object: categorys) as? Set<UIUserNotificationCategory>)
        UIApplication.sharedApplication().registerUserNotificationSettings(uns)
        
        //创建消息
        let df:NSDateFormatter = NSDateFormatter()
        df.dateFormat = "yyyyMMdd"
        let ds0:NSString = df.stringFromDate(NSDate())
        df.dateFormat = "yyyyMMdd HH:mm:ss"
        let notification:UILocalNotification = UILocalNotification()
        let fireString:String = ds0.stringByAppendingString(" 08:00:00")
        notification.fireDate = df.dateFromString(fireString)
        notification.repeatInterval = NSCalendarUnit.Day;//循环次数，kCFCalendarUnitWeekday一周一次
//      notification.soundName = UILocalNotificationDefaultSoundName;//声音，可以换成alarm.soundName = @"myMusic.caf"
        notification.alertBody = "日期该更新啦";//提示信息 弹出提示框
//        notification.alertAction = "打开APP";  //提示框按钮
//        notification.hasAction = true; //是否显示额外的按钮，为no时alertAction消失
        notification.category = "DateCalculate";
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func calculateBadgeNum () ->NSInteger
    {
        let df:NSDateFormatter = NSDateFormatter()
        df.dateFormat = "yyyyMMdd"
        let start:NSDate = df.dateFromString("20150530")!
        let end:NSDate = df.dateFromString(df.stringFromDate(NSDate()))!
        var ti:NSTimeInterval = end.timeIntervalSince1970 - start.timeIntervalSince1970
        ti += ti > 0 ? 3600 : -3600
        let iDay:NSInteger = NSInteger(floor(ti/3600.0/24.0))
        return iDay
    }


}

