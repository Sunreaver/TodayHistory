//
//  THDictionaryVC.swift
//  TodayHistory
//
//  Created by 谭伟 on 15/11/17.
//  Copyright © 2015年 谭伟. All rights reserved.
//

import UIKit

class THDictionaryVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var tf_text: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.tintColor = Colors.red
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func OnSearch(sender: UIButton) {
        if self.tf_text.text!.isEmpty
        {
            self.tf_text.becomeFirstResponder()
            return
        }
        self.tf_text.resignFirstResponder()
        let vc = GetViewCtrlFromStoryboard.ViewCtrlWithStoryboard("Main", identifier: "THWebView") as! THWebView
        vc.url = "http://m.zdic.net/s/?q=".stringByAppendingString(self.tf_text.text!)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, transitionType: "cube", subType: "fromRight")
    }
    @IBAction func OnHideKeyboard(sender: UITapGestureRecognizer) {
        self.tf_text.resignFirstResponder()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
