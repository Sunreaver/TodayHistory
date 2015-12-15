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
    
    override func viewWillAppear(animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        let urlEncode = url?.URLEncodedString()
        let request = NSURLRequest(URL: NSURL(string: urlEncode!)!)
        self.web.loadRequest(request)
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if (request.URL?.host == "www.todayonhistory.com" ||
            request.URL?.host == "m.zdic.net")
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

extension String {
    func URLEncodedString() -> String? {
        let customAllowedSet =  NSCharacterSet.URLQueryAllowedCharacterSet()
        let escapedString = self.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)
        return escapedString
    }
    static func queryStringFromParameters(parameters: Dictionary<String,String>) -> String? {
        if (parameters.count == 0)
        {
            return nil
        }
        var queryString : String? = nil
        for (key, value) in parameters {
            if let encodedKey = key.URLEncodedString() {
                if let encodedValue = value.URLEncodedString() {
                    if queryString == nil
                    {
                        queryString = "?"
                    }
                    else
                    {
                        queryString! += "&"
                    }
                    queryString! += encodedKey + "=" + encodedValue
                }
            }
        }
        return queryString
    }
}
