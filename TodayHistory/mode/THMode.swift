//
//  THMode.swift
//  TodayHistory
//
//  Created by 谭伟 on 15/9/10.
//  Copyright (c) 2015年 谭伟. All rights reserved.
//

import UIKit

class THMode: NSObject {
    var url : String?
    var title : String?
    var subTitle : String?
    var solarYear : String?
    var id : AnyObject?
    
    init(data: NSDictionary)
    {
        url = data["url"] as? String
        title = data["title"] as? String
        subTitle = data["description"] as? String
        solarYear = data["solaryear"] as? String
        id = data["id"] as? String
    }
    
    static func makeArrayWithData(arr: NSArray) -> NSArray
    {
        let mArr = NSMutableArray()
        for dic in arr
        {
            mArr.addObject(THMode(data: dic as! NSDictionary))
        }
        return mArr
    }
}
