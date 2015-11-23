//
//  THDictionaryDetailVC.swift
//  TodayHistory
//
//  Created by 谭伟 on 15/11/17.
//  Copyright © 2015年 谭伟. All rights reserved.
//

import UIKit

class THDictionaryDetailVC: UIViewController, NetWorkManagerDelegate {
    @IBOutlet weak var tv_text: UITextView!
    @IBOutlet weak var aiv_loadding: UIActivityIndicatorView!
    
    var forSearchWord:NSString!
//    private lazy var net:NetWorkManager = {
//        let n:NetWorkManager = NetWorkManager()
//        n.delegate = self
//        return n
//    }()
    private var net:NetWorkManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        let n:NetWorkManager = NetWorkManager()
        n.delegate = self
        n.getDictionaryWithWords(Words: self.forSearchWord)
        self.net = n
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func dictionaryRequestData(word: NSDictionary, sender: NetWorkManager) {
        self.aiv_loadding.stopAnimating()
        
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
