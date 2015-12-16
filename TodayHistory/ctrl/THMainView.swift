//
//  THMainView.swift
//  TodayHistory
//
//  Created by 谭伟 on 15/9/10.
//  Copyright (c) 2015年 谭伟. All rights reserved.
//

import UIKit
import SafariServices
import MJRefresh
import ionicons
import StarWars
import DGElasticPullToRefresh_CanStartLoading

class THMainView: UIViewController,
UITableViewDelegate,
UITableViewDataSource,
HolderViewDelegate,
UIViewControllerTransitioningDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    private lazy var footer:MJRefreshFooter = {
        let tmp:MJRefreshFooter = self.tableView.addLegendFooterWithRefreshingTarget(self, refreshingAction: "loadMoreData")
        tmp.textColor = Colors.main
        return tmp
    }()
    private lazy var data:THData = THData()
    private var page:Int = 0
    private var dayNum = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.createRight2Btn()
//        self.showLoaddingPage()
        tableView.frame = self.view.bounds
        tableView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        //下拉刷新
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor.whiteColor()
        self.tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self?.refreshStart()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor((self.navigationController?.navigationBar.barTintColor)!)
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        
        //去除shadowImage
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        self.navigationController!.view.backgroundColor = self.navigationController!.navigationBar.barTintColor
    }
    
    override func viewDidAppear(animated: Bool) {
        let df = NSDateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        self.navigationItem.title = df.stringFromDate(NSDate(timeIntervalSinceNow: Double(dayNum)*24*60*60))
        
        if (data.list.count == 0)
        {
            self.tableView.dg_startLoading()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        data.destroy()
        page = 0
        dayNum = 0
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    deinit
    {
        self.tableView.dg_removePullToRefresh()
    }
    
    func showLoaddingPage()
    {
        let maskView: UIView = NSBundle.mainBundle().loadNibNamed("LaunchScreen", owner: self, options: nil).last as! UIView
        let rt: CGRect = UIScreen.mainScreen().bounds
        maskView.frame = rt
        maskView.tag = 1999
        let loadding = THLoaddingPage(frame: CGRectMake((rt.size.width-100)/2, (rt.size.height-100)/2, 100, 100))
        loadding.parentFrame = rt
        loadding.delegate = self
        maskView.insertSubview(loadding, atIndex: 0)
        self.view.addSubview(maskView)
        loadding.addOval()
    }
    
    func hideLoaddingPage()
    {
        let maskView = self.view.viewWithTag(1999)
        UIView.animateWithDuration(0.666, animations: { () -> Void in
            maskView?.alpha = 0.0
            }) { (finish) -> Void in
                maskView?.removeFromSuperview()
        }
    }

    // MARK: - Table view data source

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        return self.data.list.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("THCell", forIndexPath: indexPath) 

        // Configure the cell...
        
        (cell as! THCell).refreshView(self.data.list[indexPath.row] as! THMode)

        return cell
    }
    
    
//    @available(iOS 9.0, *)
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var vc: UIViewController?
        
        let url:NSURL = NSURL(string: (self.data.list[indexPath.row] as! THMode).url!)!
        if #available(iOS 9.0, *) {
            vc = SFSafariViewController(URL: url)
            self.presentViewController(vc!, animated: true) { () -> Void in }
            
        } else {
            vc = GetViewCtrlFromStoryboard.ViewCtrlWithStoryboard("Main", identifier: "THWebView") as! THWebView
            (vc as! THWebView).url = (self.data.list[indexPath.row] as! THMode).url
            self.navigationController?.pushViewController(vc, transitionType: "cube", subType: "fromRight")
        }
        
        vc?.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        vc?.hidesBottomBarWhenPushed = true
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        vc!.transitioningDelegate = self
        
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return StarWarsGLAnimator()
    }
    
    func animateOver() {
        self.hideLoaddingPage()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    func createRight2Btn()
    {
        let addImg = IonIcons.imageWithIcon(ion_ios_plus, size: 27.0, color: UIColor.whiteColor())
        let add = UIBarButtonItem(image: addImg, style: .Plain, target: self, action: "addDay")
        
        let reduceImg = IonIcons.imageWithIcon(ion_ios_minus, size: 27.0, color: UIColor.whiteColor())
        let reduce = UIBarButtonItem(image: reduceImg, style: .Plain, target: self, action: "reduceDay")
        
        self.navigationItem.setRightBarButtonItems([add, reduce], animated: true)
    }
    
    func addDay()
    {
        self.dayNum = self.dayNum + 1 > 5 ? 5 : self.dayNum + 1
        if(self.dayNum == 5)
        {
            let reduceImg = IonIcons.imageWithIcon(ion_ios_minus, size: 27.0, color: Colors.main)
            let reduce = UIBarButtonItem(image: reduceImg, style: .Plain, target: self, action: "reduceDay")
            self.navigationItem.setRightBarButtonItems([reduce], animated: true)
        }
        else if (self.dayNum == -4)
        {
            self.createRight2Btn()
        }
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) { () -> Void in
            self.tableView.dg_startLoading()
        }
    }
    
    func reduceDay()
    {
        self.dayNum = self.dayNum - 1 < -5 ? -5 : self.dayNum - 1
        if(self.dayNum == -5)
        {
            let addImg = IonIcons.imageWithIcon(ion_ios_plus, size: 27.0, color: Colors.main)
            let add = UIBarButtonItem(image: addImg, style: .Plain, target: self, action: "addDay")
            self.navigationItem.setRightBarButtonItems([add], animated: true)
        }
        else if (self.dayNum == 4)
        {
            self.createRight2Btn()
        }
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) { () -> Void in
            self.tableView.dg_startLoading()
        }
    }
    
    @IBAction func OnGoToday(sender: UIBarButtonItem)
    {
        if (self.dayNum == 0)
        {
            return
        }
        self.dayNum = 0
        self.createRight2Btn()
        self.tableView.dg_stopLoading()
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) { () -> Void in
            self.tableView.dg_startLoading()
        }
    }
    
    func refreshStart()
    {
        refreshStart(Globle.AutoPageLoadTag + 1)
    }
    
    func refreshStart(page:Int)
    {
        data.getTodayHistory(page, dayNum: self.dayNum, refresh: { (success, page, newLine) -> Void in
            if (success)
            {
                if (page == Globle.AutoPageLoadTag + Globle.PageSize - 1)
                {
                    self.loadDataOver(true, page: 0, newLine: Int.max)
                    self.tableView.dg_stopLoading()
                    self.hideLoaddingPage()
                    return
                }
                else if (page%5 == 0)
                {
                    self.tableView.reloadData()
                    self.hideLoaddingPage()
                }
                self.refreshStart(page + 1)
            }
            else
            {
                self.hideLoaddingPage()
                self.loadDataOver(true, page: 1, newLine: 0)
                self.tableView.dg_stopLoading()
            }
        })
    }
    
    func loadMoreData()
    {
        data.getTodayHistory(page+1, dayNum: self.dayNum, refresh: { (success, page, newLine) -> Void in
            self.loadDataOver(success, page: page, newLine: newLine)
            self.footer.endRefreshing()
        })
    }
    
    func loadDataOver(success:Bool, page:Int, newLine:Int)
    {
        if (success)
        {
            if newLine > 0
            {
                self.page = page;
                self.tableView.reloadData()
            }
            if newLine < Globle.PageSize
            {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.footer.noticeNoMoreData()
                })
            }
            else if newLine > Globle.PageSize
            {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.footer.resetNoMoreData()
                })
            }
            
        }
        
        self.viewDidAppear(false)
    }

}
