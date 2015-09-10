//
//  THData.swift
//  TodayHistory
//
//  Created by 谭伟 on 15/9/10.
//  Copyright (c) 2015年 谭伟. All rights reserved.
//

import UIKit

typealias netDataRefreshOver = (success:Bool, page:Int, newLine:Int)->Void

class THData: NSObject, NetWorkManagerDelegate {
    
    private var nets: NSMutableArray = NSMutableArray()
    private var lastPage: Int = 0
    private var refresh: netDataRefreshOver?
    private var _list: NSMutableArray! = NSMutableArray()
    var list: NSArray! {
        get
        {
            return _list;
        }
    }
    
    func destroy()
    {
        _list.removeAllObjects()
        self.refresh = nil
        self.lastPage = 0
        for net in nets
        {
            (net as! NetWorkManager).stopLoad()
        }
        nets.removeAllObjects()
    }
    
    func getTodayHistory(page: Int, dayNum:Int, refresh: netDataRefreshOver)
    {
        let cal = NSCalendar.currentCalendar()
        let flags: NSCalendarUnit = .CalendarUnitMonth | .CalendarUnitDay
        
        let secs = Double(dayNum)*24*60*60
        var date = NSDate(timeIntervalSinceNow: secs)
        let nowCom = cal.components(flags, fromDate: date)
        
        var net = NetWorkManager()
        net.delegate = self
        net.getTodayHistoryWithDay(nowCom.day, month: nowCom.month, page: page);
        
        nets.addObject(net)
        self.refresh = refresh
    }
    
    func todayHistoryRequestData(todays: NSArray, page: Int, sender: NetWorkManager)
    {
        nets.removeObject(sender)
        if (page > Globle.AutoPageLoadTag)
        {
            if (page == Globle.AutoPageLoadTag + 1)
            {
                _list.removeAllObjects()
            }
            lastPage = 1
            let modes = THMode.makeArrayWithData(todays)
            _list.addObjectsFromArray(modes as [AnyObject])
            
            self.refresh?(success: true, page: page, newLine:todays.count)
        }
        else if (lastPage == page - 1 || page == 1)
        {
            if todays.count == 0
            {
                self.refresh?(success: true, page: page, newLine:todays.count)
                return;
            }
            lastPage = page
            let modes = THMode.makeArrayWithData(todays)
            _list.addObjectsFromArray(modes as [AnyObject])
            
            self.refresh?(success: true, page: page, newLine:todays.count)
        }
        else
        {
            self.refresh?(success: false, page: page, newLine:todays.count)
        }
    }
}
