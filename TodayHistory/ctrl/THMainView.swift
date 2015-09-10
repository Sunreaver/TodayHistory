//
//  THMainView.swift
//  TodayHistory
//
//  Created by 谭伟 on 15/9/10.
//  Copyright (c) 2015年 谭伟. All rights reserved.
//

import UIKit

class THMainView: UITableViewController {
    
    var header:MJRefreshHeader?
    var footer:MJRefreshFooter?
    private var data:THData!
    var page:Int = 0
    var dayNum = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        data = THData()
        self.createHeaderAndFooter()
        self.createRight2Btn()
    }
    
    override func viewWillAppear(animated: Bool) {
        if (data.list.count == 0)
        {
            self.header?.beginRefreshing();
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        var df = NSDateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        title = df.stringFromDate(NSDate(timeIntervalSinceNow: Double(dayNum)*24*60*60))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        data.destroy()
        page = 0
        dayNum = 0
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        return self.data.list.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("THCell", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        
        (cell as! THCell).refreshView(self.data.list[indexPath.row] as! THMode)

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var vc: THWebView = GetViewCtrlFromStoryboard.ViewCtrlWithStoryboard("Main", identifier: "THWebView") as! THWebView
        vc.url = (self.data.list[indexPath.row] as! THMode).url
        
        self.navigationController?.pushViewController(vc, transitionType: "cube", subType: "fromRight")
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
        let addImg = IonIcons.imageWithIcon(ion_ios_plus, size: 27.0, color: Colors.main)
        var add = UIBarButtonItem(image: addImg, style: .Plain, target: self, action: "addDay")
        
        let reduceImg = IonIcons.imageWithIcon(ion_ios_minus, size: 27.0, color: Colors.main)
        var reduce = UIBarButtonItem(image: reduceImg, style: .Plain, target: self, action: "reduceDay")
        
        self.navigationItem.setRightBarButtonItems([add, reduce], animated: true)
    }
    
    func addDay()
    {
        self.dayNum = self.dayNum + 1 > 5 ? 5 : self.dayNum + 1
        if(self.dayNum == 5)
        {
            let reduceImg = IonIcons.imageWithIcon(ion_ios_minus, size: 27.0, color: Colors.main)
            var reduce = UIBarButtonItem(image: reduceImg, style: .Plain, target: self, action: "reduceDay")
            self.navigationItem.setRightBarButtonItems([reduce], animated: true)
        }
        else if (self.dayNum == -4)
        {
            self.createRight2Btn()
        }
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) { () -> Void in
            self.header?.beginRefreshing()
        }
    }
    
    func reduceDay()
    {
        self.dayNum = self.dayNum - 1 < -5 ? -5 : self.dayNum - 1
        if(self.dayNum == -5)
        {
            let addImg = IonIcons.imageWithIcon(ion_ios_plus, size: 27.0, color: Colors.main)
            var add = UIBarButtonItem(image: addImg, style: .Plain, target: self, action: "addDay")
            self.navigationItem.setRightBarButtonItems([add], animated: true)
        }
        else if (self.dayNum == 4)
        {
            self.createRight2Btn()
        }
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) { () -> Void in
            self.header?.beginRefreshing()
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
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) { () -> Void in
            self.header?.beginRefreshing()
        }
    }
    
    func createHeaderAndFooter()
    {
        self.header = self.tableView.addLegendHeaderWithRefreshingTarget(self, refreshingAction: "refreshStart")
        self.header?.textColor = Colors.main
        self.footer = self.tableView.addLegendFooterWithRefreshingTarget(self, refreshingAction: "loadMoreData")
        self.footer?.textColor = Colors.main
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
                    self.header?.endRefreshing()
                    return
                }
                else if (page%5 == 0)
                {
                    self.tableView.reloadData()
                }
                self.refreshStart(page + 1)
            }
            else
            {
                self.loadDataOver(true, page: 1, newLine: 0)
                self.header?.endRefreshing()
            }
        })
    }
    
    func loadMoreData()
    {
        data.getTodayHistory(page+1, dayNum: self.dayNum, refresh: { (success, page, newLine) -> Void in
            self.loadDataOver(success, page: page, newLine: newLine)
            self.footer?.endRefreshing()
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
                    self.footer?.noticeNoMoreData()
                })
            }
            else if newLine > Globle.PageSize
            {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.footer?.resetNoMoreData()
                })
            }
            
        }
        
        self.viewDidAppear(false)
    }

}
