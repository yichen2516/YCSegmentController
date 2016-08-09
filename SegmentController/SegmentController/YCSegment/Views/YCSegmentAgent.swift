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
    
    ///最大页数, 由collectionView numberOfItems控制
    private var maxCountOfPage = 1
    
    var pages: Array<UIViewController> = []
    
    var currentSelectedItemAtIndex = 0
    var currentSpacing : CGFloat?
}


extension YCSegmentAgent: UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let view = segmentView else { return 0 }
        guard let number = segmentView?.dataSource?
            .numberOfPagesInYCSegment?(view) else { return 0 }
        
        if let pageWidth = segmentBody?.bounds.width {
            segmentBody?.contentSizeWidth = CGFloat(number) * pageWidth//在得到页数同时设置scrollView的contentSize
        }
        maxCountOfPage = number
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
        item.selected = currentSelectedItemAtIndex == indexPath.item
        return item
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        guard let view = segmentView else {
            return .zero
        }
        guard let model = segmentView?.dataSource?.ycSegment?(view, modelForItemAtPage: indexPath.item) else {
            return .zero
        }
        let string = NSString(string: model.title ?? "")
        let width = string.boundingRectWithSize(CGSizeMake(UIScreen.mainScreen().bounds.width / 2, 100), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [
            NSFontAttributeName: YCSegmentConfiguration.globalConfig.pageControlItemConfig.font
            ], context: nil).size.width
        return CGSizeMake(width, collectionView.frame.size.height)
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        print(collectionView.contentSize)
        if collectionView.contentSize == .zero {
            return YCSegmentConfiguration.globalConfig.pageControlItemConfig.itemSpacing
        }
        if YCSegmentConfiguration.globalConfig.pageControlItemConfig.needTileItems && collectionView.contentSize != .zero && collectionView.contentSize.width <= collectionView.frame.size.width {
            if currentSpacing != nil {
                return currentSpacing!
            }
            currentSpacing = (collectionView.frame.size.width - collectionView.contentSize.width) / CGFloat(maxCountOfPage - 1) + YCSegmentConfiguration.globalConfig.pageControlItemConfig.itemSpacing
            return currentSpacing!
        }
        return YCSegmentConfiguration.globalConfig.pageControlItemConfig.itemSpacing
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
        segmentBody?.scrollTo(indexPath.item + 1)
        if currentSelectedItemAtIndex != indexPath.item {
            currentSelectedItemAtIndex = indexPath.item
            collectionView.reloadData()
        }
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        guard scrollView == segmentBody?.scrollView else {return}
        let page = currentPage()
        
        print(page)
//        print(scrollView.contentOffset)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        guard scrollView == segmentBody?.scrollView else {return}
        let page = currentPage()
        if currentSelectedItemAtIndex != page - 1 {
            currentSelectedItemAtIndex = page - 1
            segmentHeader?.collectionView.reloadData()
            segmentHeader?.collectionView.selectItemAtIndexPath(NSIndexPath(forItem: page - 1, inSection: 0), animated: true, scrollPosition: UICollectionViewScrollPosition.CenteredHorizontally)
        }
        print("减速结束：" + "\(scrollView.contentOffset)")
    }
    
    /// 当前页码
    ///
    /// page最小值为：1，最大值为：maxCountOfPage
    ///
    func currentPage() -> Int {
        guard let scrollView = segmentBody?.scrollView else {return 1}
        let width = scrollView.frame.size.width
        var page = Int(scrollView.contentOffset.x / width + 1 + 0.5)
        if page <= 1 {
            page = 1
        }
        if page >= maxCountOfPage {
            page = maxCountOfPage
        }
        return page
    }
    
}