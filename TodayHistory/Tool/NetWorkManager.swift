//
//  NetWorkManager.swift
//  TodayHistory
//
//  Created by 谭伟 on 15/9/9.
//  Copyright (c) 2015年 谭伟. All rights reserved.
//

import UIKit

@objc protocol NetWorkManagerDelegate:class
{
    optional func todayHistoryRequestData(todays:NSArray, page:Int, sender:NetWorkManager)
}

class NetWorkManager: NSObject {
    weak var delegate:NetWorkManagerDelegate?
    var afnetworks = NSMutableArray()
    
    func stopLoad()
    {
        for af in afnetworks
        {
            (af as! AFHTTPRequestOperationManager).operationQueue.cancelAllOperations()
        }
    }
    
    func getTodayHistoryWithDay(day:Int, month:Int, page:Int)
    {
        let sPage = page
        let manager = AFHTTPRequestOperationManager()
        manager.responseSerializer = AFHTTPResponseSerializer()
        
        var pagesize = Globle.PageSize
        var p = page
        if (page > Globle.AutoPageLoadTag)
        {
            pagesize = 1
            p -= Globle.AutoPageLoadTag
        }
        let params = ["m":"content","c":"index","a":"json_event","page":p,"pagesize":pagesize,"month":month,"day":day]
        
        manager.GET("http://www.todayonhistory.com/index.php",
            parameters: params,
            success:
            { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                
                self.afnetworks.removeObject(manager)
                
                let responseData = responseObject as! NSData!
                let responseDict: AnyObject! = responseData.objectFromJSONData()
                if (responseDict == nil)
                {
                    self.delegate?.todayHistoryRequestData!(NSArray(), page: sPage, sender: self)
                }
                else
                {
                    self.delegate?.todayHistoryRequestData!(responseDict as! NSArray, page: sPage, sender: self)
                }
                
            },
            failure:
            { (operation: AFHTTPRequestOperation!, error: NSError!) in
                self.afnetworks.removeObject(manager)
        })
        
        afnetworks.addObject(manager)
    }
}
