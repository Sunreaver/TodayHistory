//
//  THCollectionViewLayout.swift
//  TodayHistory
//
//  Created by 谭伟 on 15/9/18.
//  Copyright © 2015年 谭伟. All rights reserved.
//

import UIKit

class THCollectionViewLayout: UICollectionViewLayout {

    // 这个方法返回每个单元格的位置和大小
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath)
        -> UICollectionViewLayoutAttributes? {
            //当前单元格布局属性
            let attribute =  UICollectionViewLayoutAttributes(forCellWithIndexPath:indexPath)
            
            let size = collectionView!.bounds.size.width/3
            let frame:CGRect = CGRectMake(0, 0, size, size)
            attribute.frame = frame
            attribute.center = CGPointMake((CGFloat(indexPath.row%3) + 0.5) * size, (CGFloat(indexPath.row/3) + 0.5) * size)
            
            return attribute
    }
    
    // 内容区域总大小，不是可见区域
    override func collectionViewContentSize() -> CGSize {
        
        let size = collectionView!.bounds.size.width/3
        
        return CGSizeMake(collectionView!.bounds.size.width,
            CGFloat((CGFloat(collectionView!.numberOfItemsInSection(0))/3 + 1) * size))
    }
    
    // 所有单元格位置属性
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var attributesArray = [UICollectionViewLayoutAttributes]()
        let cellCount = self.collectionView!.numberOfItemsInSection(0)
        for i in 0..<cellCount {
            let indexPath =  NSIndexPath(forItem:i, inSection:0)
            
            let attributes =  self.layoutAttributesForItemAtIndexPath(indexPath)
            
            if let a = attributes
            {
                attributesArray.append(a)
            }
            
        }
        return attributesArray
    }
}
