//
//  YCSegmentView.swift
//  SegmentController
//
//  Created by LakesMac on 16/8/2.
//  Copyright © 2016年 iLakeYC. All rights reserved.
//

import UIKit
import SnapKit

@objc protocol YCSegmentDelegate {
    
}

@objc protocol YCSegmentDataSource {
    
    @objc optional func numberOfPagesInYCSegment(segment: YCSegmentView) -> Int
    
    @objc optional func ycSegment(segment: YCSegmentView, modelForItemAtPage: Int) -> YCSegmentItemModel!
    
    @objc optional func ycSegment(segment: YCSegmentView, viewControllerAtPage: Int, userInfo: [String: AnyObject]) -> UIViewController!
    
}

class YCSegmentView: UIView {
    
    func reloadData() {
        pageControl.collectionView.reloadData()
    }
    
    func selected(page: Int) {
        agent.selected(page)
    }

    weak var delegate  : YCSegmentDelegate? {
        didSet {
            scrollEngine.scrollView.delegate    = agent
            pageControl.collectionView.delegate = agent
        }
    }
    weak var dataSource: YCSegmentDataSource? {
        didSet {
            pageControl.collectionView.dataSource = agent
        }
    }
    
    let agent         : YCSegmentAgent             = YCSegmentAgent()
    let pageControl   : YCSegmentPageControl       = YCSegmentPageControl(frame: .zero)
    let scrollEngine  : YCSegmentPagesScrollEngine = YCSegmentPagesScrollEngine(frame: .zero)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAllViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupAllViews()
    }
    
    
}

extension YCSegmentView {
    
    
    private func setupAllViews() {
        addSubview(scrollEngine)
        addSubview(pageControl)
        
        agent.segmentView   = self
        agent.segmentHeader = pageControl
        agent.segmentBody   = scrollEngine
        
        snp_layouts()
    }
    
    
    private func snp_layouts() {
        pageControl.snp_makeConstraints { (make) in
            make.left.equalTo(snp_left)
            make.right.equalTo(snp_right)
            make.top.equalTo(snp_top)
            make.height.equalTo(44)
        }
        scrollEngine.snp_makeConstraints { (make) in
            make.left.equalTo(snp_left)
            make.right.equalTo(snp_right)
            make.bottom.equalTo(snp_bottom)
            make.top.equalTo(pageControl.snp_bottom)
        }
    }
    
}