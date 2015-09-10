//
//  THCell.swift
//  TodayHistory
//
//  Created by 谭伟 on 15/9/10.
//  Copyright (c) 2015年 谭伟. All rights reserved.
//

import UIKit

class THCell: UITableViewCell {
    @IBOutlet weak var lb_title: UILabel!
    @IBOutlet weak var lb_subTitle: UILabel!
    @IBOutlet weak var lb_year: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func refreshView(data: THMode)
    {
        lb_year.text = data.solarYear
        lb_title.text = data.title
        lb_subTitle.text = data.subTitle
    }

}
