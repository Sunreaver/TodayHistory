//
//  THCollectionViewCell.swift
//  TodayHistory
//
//  Created by 谭伟 on 15/9/18.
//  Copyright © 2015年 谭伟. All rights reserved.
//

import UIKit

class THCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = Colors.blue
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var backImage:UIImage?{
        willSet{
            let backImageView = UIImageView(frame: self.frame)
            backImageView.image = newValue
            self.backgroundView = backImageView
        }
    }
}
