//
//  NetWorkManager.swift
//  TodayHistory
//
//  Created by 谭伟 on 15/9/9.
//  Copyright (c) 2015年 谭伟. All rights reserved.
//

import UIKit
import AFNetworking
import JSONKit

@objc protocol NetWorkManagerDelegate:class
{
    optional func todayHistoryRequestData(todays:NSArray, page:Int, sender:NetWorkManager)
    optional func dictionaryRequestData(word:NSDictionary, sender:NetWorkManager)
    optional func uploadReadProcess(Result:NSDictionary, sender:NetWorkManager)
}

class NetWorkManager: NSObject {
    /// 超时
    static let TimeOutInterval:NSTimeInterval = 10.0
    weak var delegate:NetWorkManagerDelegate?
    var afnetworks = NSMutableArray()
    
    func stopLoad()
    {
//        for af in afnetworks
//        {
//            (af as! AFHTTPRequestOperationManager).operationQueue.cancelAllOperations()
//        }
        afnetworks.map{ ($0 as? AFHTTPRequestOperationManager)?.operationQueue.cancelAllOperations() }
    }
    
    /**
    获取历史今天
    
    - parameter day:   日
    - parameter month: 月
    - parameter page:  分页
    */
    func getTodayHistoryWithDay(Day d:Int, Month m:Int, var page:Int)
    {
        let sPage = page
        let manager = AFHTTPRequestOperationManager()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.requestSerializer.timeoutInterval = NetWorkManager.TimeOutInterval

        var pagesize = Globle.PageSize
        if (page > Globle.AutoPageLoadTag)
        {
            pagesize = 1
            page -= Globle.AutoPageLoadTag
        }
        let params = ["m":"content","c":"index","a":"json_event","page":page,"pagesize":pagesize,"month":m,"day":d]
        
        manager.GET("http://www.todayonhistory.com/index.php",
            parameters: params,
            success:
            { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                
                self.afnetworks.removeObject(manager)
                
                if let responseData = responseObject as? NSData,
                    let responseDict = responseData.objectFromJSONData(),
                    let _ = responseDict as? NSArray
                {
                    self.delegate?.todayHistoryRequestData?(responseDict as! NSArray, page: sPage, sender: self)
                }
                else
                {
                    self.delegate?.todayHistoryRequestData?(NSArray(), page: sPage, sender: self)
                }
            },
            failure:
            { (operation: AFHTTPRequestOperation!, error: NSError!) in
                self.afnetworks.removeObject(manager)
                self.delegate?.todayHistoryRequestData?(NSArray(), page: sPage, sender: self)
        })
        
        afnetworks.addObject(manager)
    }
    
    func SaveReadProcess(Data d:NSString, Host h:NSString)
    {
        let manager = AFHTTPRequestOperationManager()
        
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        manager.requestSerializer.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        manager.requestSerializer.timeoutInterval = NetWorkManager.TimeOutInterval
        
        let url = String(format: "http://%@/uploadreadprocess", h)
        
        manager.POST(url,
            parameters: ["readprocess":d, "bb":"b", "cc":(1)],
            success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
                
                self.afnetworks.removeObject(manager)
                if let result = responseObject as? NSDictionary
                {
                    self.delegate?.uploadReadProcess?(result, sender: self)
                }
                else
                {
                    self.delegate?.uploadReadProcess?(["status":500, "msg":"上传失败"], sender: self)
                }
            }) { (op, er) -> Void in
                self.delegate?.uploadReadProcess?(["status":404, "msg":"没有服务器"], sender: self)
        }
        afnetworks.addObject(manager)
    }
    
    
    /**
     获取词典
     
     - parameter day:   日
     - parameter month: 月
     - parameter page:  分页
     */
    func getDictionaryWithWords(Words w:NSString)
    {
        let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        manager.requestSerializer.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        manager.requestSerializer.timeoutInterval = NetWorkManager.TimeOutInterval
        
        var url = "http://brisk.eu.org/api/xhzd.php"
        if w.length > 1
        {
            url = "http://brisk.eu.org/api/hycd.php"
        }
        
        let params = ["word":w]
        
        manager.GET(url,
            parameters: params,
            success:
            { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                
                self.afnetworks.removeObject(manager)
                
                if let responseData = responseObject as? NSData,
                    let responseDict = responseData.objectFromJSONData(),
                    let _ = responseDict as? NSDictionary
                {
                    self.delegate?.dictionaryRequestData?(responseDict as! NSDictionary, sender: self)
                }
                else
                {
                    self.delegate?.dictionaryRequestData?(NSDictionary(), sender: self)
                }
            },
            failure:
            { (operation: AFHTTPRequestOperation!, error: NSError!) in
                self.afnetworks.removeObject(manager)
                self.delegate?.dictionaryRequestData?(NSDictionary(), sender: self)
        })
        
        afnetworks.addObject(manager)
    }
}
