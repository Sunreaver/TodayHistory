//
//  THTestVC.swift
//  TodayHistory
//
//  Created by 谭伟 on 15/9/14.
//  Copyright (c) 2015年 谭伟. All rights reserved.
//

import UIKit

class THTestVC: UIViewController {
    static var index:Int = 0
    @IBOutlet weak var iv_1: UIImageView!

    @IBAction func OnTap(sender: UITapGestureRecognizer)
    {
        let img:UIImage!
        
        if THTestVC.index++ % 2 == 0
        {
            img = UIImage(named: "12")
        }
        else
        {
            img = UIImage(named: "13")
        }
        
        let transition:CATransition = CATransition()
        transition.duration = 0.333
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        transition.type = "spewEffect"
        iv_1.layer.addAnimation(transition, forKey: "h")
        
        iv_1.image = img
    }
}
