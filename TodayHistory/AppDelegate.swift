//
//  AppDelegate.swift
//  TodayHistory
//
//  Created by 谭伟 on 15/9/9.
//  Copyright (c) 2015年 谭伟. All rights reserved.
//

import UIKit
import ionicons

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UIAlertViewDelegate {

    var window: UIWindow?
    let health:HealthStoreManager = {
        return HealthStoreManager()
    }()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let tabbarCtrl = self.window!.rootViewController
        let vc0 = tabbarCtrl?.childViewControllers[0]
        let vc1 = tabbarCtrl?.childViewControllers[1]
        let vc2 = tabbarCtrl?.childViewControllers[2]
        let vc3 = tabbarCtrl?.childViewControllers[3]
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
        
        vc3?.tabBarItem.image = IonIcons.imageWithIcon(ion_ios_body, size: 27.0, color: UIColor.blackColor())
        vc3?.tabBarItem.selectedImage = IonIcons.imageWithIcon(ion_ios_body, size: 27.0, color: Colors.main)
        vc3?.tabBarItem.title = "健康"
        vc3?.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:Colors.main], forState: UIControlState.Selected)
        vc3?.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.blackColor()], forState: UIControlState.Normal)
                
        (tabbarCtrl as! UITabBarController).selectedIndex = 3
        
        self.window?.layer.masksToBounds = true
        self.window?.layer.cornerRadius = 5.0

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

        let date = UserDef.getUserDefValue(BadgeNumberDate)
        if let _ = date
        {
            application.applicationIconBadgeNumber = self.calculateBadgeNum(date as! String)
        }
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//        application.applicationIconBadgeNumber = self.calculateBadgeNum()
        self.regNotification()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        if url.absoluteString.hasPrefix("SwissArmyKnifeToday://action=refreshBadgeNumber")
        {
            let date = UserDef.getUserDefValue(BadgeNumberDate)
            if let _ = date
            {
                application.applicationIconBadgeNumber = self.calculateBadgeNum(date as! String)
            }
        }
        return false;
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        if let _ = identifier
        {
            let refreshDay:NSString = "refreshDay_"
            let ide:NSString = identifier!
            if ide.hasPrefix(refreshDay as String)
            {
                UserDef.setUserDefValue(ide.substringFromIndex(refreshDay.length), keyName: BadgeNumberDate)
                application.applicationIconBadgeNumber = self.calculateBadgeNum(ide.substringFromIndex(refreshDay.length))
            }
            else if identifier == "Drinkcoffee"
            {
                self.health.setCoffeeWithDay(NSDate(), quantity: 0.03, block: { (success, g, sum) -> Void in
                    
                });
            }
            else if identifier == "NoDrinkcoffee"
            {
                let av:UIAlertView = UIAlertView(title: "今天多少", message: "加油", delegate: self, cancelButtonTitle: "0mg", otherButtonTitles: "10mg", "20mg", "40mg", "50mg");
                av.tag = 999
                av.show()
            }
            else if identifier == "WalkHome"
            {
                let df = NSDateFormatter();
                df.dateFormat = "yyyyMMddHHmm";
                var date = df.dateFromString(NSDate().yyyyMMddStringValue().stringByAppendingString("1840"))
                if (date?.timeIntervalSinceNow > 0)
                {
                    date = NSDate(timeInterval: -24*3600, sinceDate: date!)
                }
                self.health.setWorkoutWalkingWithDay(date, block: { (success, today, sum, date) -> Void in
                })
            }
        }
        completionHandler()
    }
    
    func regNotification()
    {
        //DateCalculate 消息类型
        let action01:UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        action01.title = "轩轩"
        action01.identifier = "refreshDay_20150530"
        action01.activationMode = UIUserNotificationActivationMode.Background
        let action03:UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        action03.title = "小北"
        action03.identifier = "refreshDay_20091115"
        action03.activationMode = UIUserNotificationActivationMode.Background
        
        let categorys0:UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
        categorys0.identifier = "DateCalculate"
        categorys0.setActions([action01, action03], forContext: UIUserNotificationActionContext.Default)
        
        //CoffeeTime 消息类型
        let action0:UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        action0.title = "30mg"
        action0.identifier = "Drinkcoffee"
        action0.activationMode = UIUserNotificationActivationMode.Background
        let action1:UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        action1.title = "其它"
        action1.identifier = "NoDrinkcoffee"
        action1.activationMode = UIUserNotificationActivationMode.Foreground
        action1.authenticationRequired = false
        action1.destructive = true
        
        let categorys1:UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
        categorys1.identifier = "CoffeeTime"
        categorys1.setActions([action0, action1], forContext: UIUserNotificationActionContext.Default)
        
        //WorkoutWalk 消息类型
        let action001:UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        action001.title = "走回家了？"
        action001.identifier = "WalkHome"
        action001.activationMode = UIUserNotificationActivationMode.Background
        
        let categorys001:UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
        categorys001.identifier = "WorkoutWalk"
        categorys001.setActions([action001], forContext: UIUserNotificationActionContext.Default)
        
        let unsCoffee:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: [.Sound, .Badge], categories: NSSet(array: [categorys0, categorys1, categorys001]) as? Set<UIUserNotificationCategory>)
        UIApplication.sharedApplication().registerUserNotificationSettings(unsCoffee)
        
        //取消已经添加的DateCalculate提醒
        /*
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications!
        {
            if let type = notification.userInfo?["type"] where
                type as! String == "DateCalculate" || type as! String == "CoffeeTime"
            {
                UIApplication.sharedApplication().cancelLocalNotification(notification)
            }
        }
        */
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        //注册DateCalculate
        let df:NSDateFormatter = NSDateFormatter()
        df.dateFormat = "yyyyMMdd"
        var ds0:NSString = df.stringFromDate(NSDate())
        df.dateFormat = "yyyyMMdd HH:mm:ss"
        let notification:UILocalNotification = UILocalNotification()
        var fireString:String = ds0.stringByAppendingString(" 08:00:00")
        notification.fireDate = df.dateFromString(fireString)
        notification.repeatInterval = NSCalendarUnit.Day;//循环次数，kCFCalendarUnitWeekday一周一次
        notification.soundName = "nosound.caf";//声音，可以换成alarm.soundName = @"myMusic.caf"
        notification.alertTitle = "日期该更新啦";//提示信息 弹出提示框
        notification.alertBody = "美好生活，从这里开始";//提示信息 弹出提示框
//        notification.alertAction = "刷新日期";  //提示框按钮
//        notification.hasAction = true; //是否显示额外的按钮，为no时alertAction消失
        notification.category = "DateCalculate"
        notification.userInfo = ["type":"DateCalculate"]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
        //注册CoffeeTime
        df.dateFormat = "yyyyMMdd"
        ds0 = df.stringFromDate(NSDate())
        df.dateFormat = "yyyyMMdd HH:mm:ss"
        let notification1:UILocalNotification = UILocalNotification()
        fireString = ds0.stringByAppendingString(" 16:00:00")
        notification1.fireDate = df.dateFromString(fireString)
        notification1.repeatInterval = NSCalendarUnit.Day//循环次数，kCFCalendarUnitWeekday一周一次
        notification1.soundName = "No05.caf";//声音，可以换成alarm.soundName = @"myMusic.caf"
        notification1.alertTitle = "Rest Awhile Fat BOY!"
        notification1.alertBody = "Coffee Time";//提示信息 弹出提示框
//        notification1.hasAction = true
        notification1.userInfo = ["type":"CoffeeTime"]
        notification1.category = "CoffeeTime"
        UIApplication.sharedApplication().scheduleLocalNotification(notification1)
        
        //注册WorkoutWalk
        df.dateFormat = "yyyyMMdd"
        ds0 = df.stringFromDate(NSDate())
        df.dateFormat = "yyyyMMdd HH:mm:ss"
        let notification2:UILocalNotification = UILocalNotification()
        fireString = ds0.stringByAppendingString(" 19:20:10")
        notification2.fireDate = df.dateFromString(fireString)
        notification2.repeatInterval = NSCalendarUnit.Day//循环次数，kCFCalendarUnitWeekday一周一次
        notification2.soundName = "nosound.caf";//声音，可以换成alarm.soundName = @"myMusic.caf"
        notification2.alertTitle = "今天走回家了吗？"
        notification2.alertBody = "Commmmme on Boy!";//提示信息 弹出提示框
        notification2.userInfo = ["type":"WorkoutWalk"]
        notification2.category = "WorkoutWalk"
        UIApplication.sharedApplication().scheduleLocalNotification(notification2)
    }
    
    func calculateBadgeNum (birthday:String) ->NSInteger
    {
        let df:NSDateFormatter = NSDateFormatter()
        df.dateFormat = "yyyyMMdd"
        let start:NSDate = df.dateFromString(birthday)!
        let end:NSDate = df.dateFromString(df.stringFromDate(NSDate()))!
        var ti:NSTimeInterval = end.timeIntervalSince1970 - start.timeIntervalSince1970
        ti += ti > 0 ? 3600 : -3600
        let iDay:NSInteger = NSInteger(floor(ti/3600.0/24.0))
        return iDay
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int)
    {
        if alertView.tag == 999
        {
            var g = 0.0
            if buttonIndex == 1
            {
                g = 0.01
            }
            else if buttonIndex == 2
            {
                g = 0.02
            }
            else if buttonIndex == 3
            {
                g = 0.04
            }
            else if buttonIndex == 4
            {
                g = 0.05
            }
            self.health.setCoffeeWithDay(NSDate(timeIntervalSinceNow: -2*60), quantity: g, block: { (s, g, sum) -> Void in
                if s,
                let tabbarCtrl = self.window?.rootViewController,
                let rootvc = tabbarCtrl.childViewControllers[3] as? UINavigationController,
                let roottvc = rootvc.topViewController as? UITableViewController
                {
                    roottvc.viewDidAppear(false)
                }
            })
        }
    }

}

