//
//  YCSegmentAgent.swift
//  SegmentController
//
//  Created by LakesMac on 16/8/2.
//  Copyright © 2016年 iLakeYC. All rights reserved.
//

import UIKit

class YCSegmentAgent: NSObject {

    weak var segmentView   : YCSegmentView?
    weak var segmentHeader : YCSegmentPageControl?
    weak var segmentBody   : YCSegmentPagesScrollEngine?
    
    
    var pages: Array<UIViewController> = []
    
}


extension YCSegmentAgent: UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let view = segmentView else {
            return 0
        }
        guard let number = segmentView?.dataSource?.numberOfPagesInYCSegment?(view) else {
            return 0
        }
        if let pageWidth = segmentBody?.bounds.width {
            print("设置contentSize")
            segmentBody?.contentSizeWidth = CGFloat(number) * pageWidth
        }
        return number
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCellWithReuseIdentifier(YCSegmentPageControlItem.id, forIndexPath: indexPath) as! YCSegmentPageControlItem
        guard let view = segmentView else {
            return item
        }
        guard let model = segmentView?.dataSource?.ycSegment?(view, modelForItemAtPage: indexPath.item) else {
            return item
        }
        
        item.model = model
        
        return item
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        guard scrollView == segmentBody?.scrollView else {return}
        
        print(scrollView.contentOffset)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        guard scrollView == segmentBody?.scrollView else {return}
        
        print(scrollView.contentOffset)
    }
}