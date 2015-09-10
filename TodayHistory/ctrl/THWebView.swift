//
//  THWebView.swift
//  TodayHistory
//
//  Created by 谭伟 on 15/9/10.
//  Copyright (c) 2015年 谭伟. All rights reserved.
//

import UIKit

class THWebView: UIViewController, UIWebViewDelegate {
    var url:String?
    @IBOutlet weak var web: UIWebView!
    @IBOutlet weak var loadding: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.web.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        let request = NSURLRequest(URL: NSURL(string: url!)!)
        self.web.loadRequest(request)
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if (request.URL?.host == "www.todayonhistory.com")
        {
            return true
        }
        return false
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        loadding.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        loadding.stopAnimating()
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
