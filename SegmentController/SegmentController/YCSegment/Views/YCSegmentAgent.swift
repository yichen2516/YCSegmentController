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
    
    var currentSelectedItemAtIndex = 0
    var currentSpacing : CGFloat?
    
    
    func selected(page: Int) {
        guard page != 0 else {return}
        guard page <= maxCountOfPage else {return}
        segmentBody?.addViewController({[weak self] () -> UIViewController in
            var vc: UIViewController?
            if let view = self?.segmentView {
                let item = self?.segmentHeader?.collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: page - 1, inSection: 0)) as? YCSegmentPageControlItem
                vc = self?.segmentView?.dataSource?.ycSegment?(view, viewControllerAtPage: page, userInfo: item?.model?.userInfo ?? [:])
            }
            return vc ?? UIViewController()
            }, atPage: page)
        segmentHeader?.collectionView.selectItemAtIndexPath(NSIndexPath(forItem: page - 1, inSection: 0), animated: true, scrollPosition: UICollectionViewScrollPosition.CenteredHorizontally)
        segmentBody?.scrollTo(page)
    }
}


extension YCSegmentAgent: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard
            let view = segmentView
            else {
                return 0
        }
        guard
            let number = segmentView?.dataSource?.numberOfPagesInYCSegment?(view)
            else {
                return 0
        }
        
        if let pageWidth = segmentBody?.bounds.width {
            segmentBody?.contentSizeWidth = CGFloat(number) * pageWidth//在得到页数同时设置scrollView的contentSize
        }
        //        segmentBody?.numberOfPages = number
        maxCountOfPage = number
        return number
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCellWithReuseIdentifier(YCSegmentPageControlItem.id,
                                                                         forIndexPath: indexPath) as! YCSegmentPageControlItem
        guard
            let view = segmentView
            else {
                return item
        }
        guard
            let model = segmentView?.dataSource?.ycSegment?(view, modelForItemAtPage: indexPath.item)
            else {
                return item
        }
        
        item.model = model
        return item
    }
    
    func collectionView(
        collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath ) -> CGSize {
        guard
            let view = segmentView
            else {
                return .zero
        }
        guard
            let model = segmentView?.dataSource?.ycSegment?(view, modelForItemAtPage: indexPath.item)
            else {
                return .zero
        }
        let string = NSString(string: model.title ?? "")
        let width = string.boundingRectWithSize(CGSizeMake(UIScreen.mainScreen().bounds.width / 2, 100), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [
            NSFontAttributeName: YCSegmentConfiguration.globalConfig.pageControlItemConfig.font
            ], context: nil).size.width + YCSegmentConfiguration.globalConfig.pageControlItemConfig.selectedIndicatorPadding * 2
        return CGSizeMake(width, collectionView.frame.size.height)
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        print(collectionView.contentSize)
        if collectionView.contentSize == .zero {
            return YCSegmentConfiguration.globalConfig.pageControlItemConfig.itemSpacing
        }
        if YCSegmentConfiguration.globalConfig.pageControlItemConfig.needTileItems && collectionView.contentSize != .zero && collectionView.contentSize.width <= collectionView.frame.size.width {
            if currentSpacing == nil {
                currentSpacing = (collectionView.frame.size.width - collectionView.contentSize.width) / CGFloat(maxCountOfPage - 1) + YCSegmentConfiguration.globalConfig.pageControlItemConfig.itemSpacing
            }
            return currentSpacing!
        }
        return YCSegmentConfiguration.globalConfig.pageControlItemConfig.itemSpacing
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let page = indexPath.item + 1
        segmentBody?.scrollTo(page)
        if currentSelectedItemAtIndex != indexPath.item {
            currentSelectedItemAtIndex = indexPath.item
            collectionView.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: .CenteredHorizontally)
        }
        
        segmentBody?.addViewController({[weak self] () -> UIViewController in
            var vc: UIViewController?
            if let view = self?.segmentView {
                let item = self?.segmentHeader?.collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: page - 1, inSection: 0)) as? YCSegmentPageControlItem
                vc = self?.segmentView?.dataSource?.ycSegment?(view, viewControllerAtPage: page, userInfo: item?.model?.userInfo ?? [:])
            }
            return vc ?? UIViewController()
            }, atPage: page)
        print("选中")
    }
    
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        guard scrollView == segmentBody?.scrollView else {return}
        if currentSelectedItemAtIndex + 1 != currentPage() {
            currentSelectedItemAtIndex = currentPage() - 1
            segmentHeader?.collectionView.selectItemAtIndexPath(NSIndexPath(forItem: currentSelectedItemAtIndex, inSection: 0), animated: true, scrollPosition: UICollectionViewScrollPosition.CenteredHorizontally)
        }
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        guard scrollView == segmentBody?.scrollView else {return}
        let page = currentPage()
        if currentSelectedItemAtIndex != page - 1 {
            currentSelectedItemAtIndex = page - 1
            segmentHeader?.collectionView.selectItemAtIndexPath(NSIndexPath(forItem: page - 1, inSection: 0), animated: true, scrollPosition: UICollectionViewScrollPosition.CenteredHorizontally)
        }
        segmentBody?.addViewController({[weak self] () -> UIViewController in
            var vc: UIViewController?
            if let view = self?.segmentView {
                let item = self?.segmentHeader?.collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: page - 1, inSection: 0)) as? YCSegmentPageControlItem
                vc = self?.segmentView?.dataSource?.ycSegment?(view, viewControllerAtPage: page, userInfo: item?.model?.userInfo ?? [:])
            }
            return vc ?? UIViewController()
            }, atPage: page)
        print("减速结束：" + "\(scrollView.contentOffset)")
    }
    
    /// 当前页码
    ///
    /// page最小值为：1，最大值为：maxCountOfPage
    ///
    func currentPage() -> Int {
        guard let scrollView = segmentBody?.scrollView else {return 1}
        let width = scrollView.frame.size.width
        var p = Int(scrollView.contentOffset.x / width + 1 + 0.5)
        p = p <= 1 ? 1 : p
        p = p >= maxCountOfPage ? maxCountOfPage : p
        return p
    }
}