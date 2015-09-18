//
//  THTestVC.swift
//  TodayHistory
//
//  Created by 谭伟 on 15/9/14.
//  Copyright (c) 2015年 谭伟. All rights reserved.
//

import UIKit

class THTestVC: UIViewController, UINavigationBarDelegate {
    static var index:Int = 0
    private var navBarAlpha:CGFloat! = 0.0
    @IBOutlet weak var iv_1: UIImageView!
    
    private lazy var navBar:UINavigationBar = {
        let bar:UINavigationBar = UINavigationBar(frame: CGRectMake(0, 0, self.view.bounds.size.width, 100))
        bar.alpha = 5.0
        
        let item:UINavigationItem = UINavigationItem()
        item.titleView = UIImageView(image: UIImage(named: "13"))
        item.leftBarButtonItem = UIBarButtonItem(title: "<", style: .Plain, target: self, action: "OnBack")
        bar.pushNavigationItem(item, animated: true)
        return bar
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        self.navigationController?.navigationBar.clipsToBounds = true
        self.view.addSubview(navBar)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navBarAlpha = self.navigationController?.navigationBar.alpha
        self.navigationController?.navigationBar.alpha = 0.0
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.alpha = navBarAlpha
    }

    @IBAction func OnTap(sender: UITapGestureRecognizer)
    {
        let img:UIImage!
        
        if THTestVC.index++ % 2 == 0
        {
            img = UIImage(named: "12")
            
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                self.navBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 20)
                let titleView = self.navBar.topItem?.titleView
                titleView?.frame = CGRectMake(0, 0, 20, 20)
                titleView?.center = CGPointMake(self.view.frame.size.width/2, 10)
            })
        }
        else
        {
            img = UIImage(named: "13")
            
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                self.navBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 100)
                let titleView = self.navBar.topItem?.titleView
                let img:UIImage = UIImage(named: "13")!
                titleView?.frame = CGRectMake(0, 0, img.size.width, img.size.height)
                titleView?.center = CGPointMake(self.view.frame.size.width/2, 100 - img.size.height/2)
            })
        }
        
        let transition:CATransition = CATransition()
        transition.duration = 2
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        transition.type = "oglFlip"
        transition.subtype = kCATransitionFromBottom
        iv_1.layer.addAnimation(transition, forKey: "h")
        
        iv_1.image = img
        
    }
    
    func OnBack()
    {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}
