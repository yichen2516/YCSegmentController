//
//  YCSegmentPagesScrollEngine.swift
//  SegmentController
//
//  Created by LakesMac on 16/8/2.
//  Copyright © 2016年 iLakeYC. All rights reserved.
//

import UIKit
import SnapKit

class YCSegmentPagesScrollEngine: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAllViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupAllViews()
    }
    
    ///设置横向滚动距离
    ///
    ///自动设置contnetSize
    var contentSizeWidth: CGFloat {
        set {
            contentView.snp_updateConstraints { (make) in
                make.width.equalTo(newValue)
            }
            contentView.layoutIfNeeded()
        }
        get {
            return scrollView.contentSize.width
        }
    }
    
    let scrollView = YCScrollView(frame: .zero)

    func setupAllViews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        snp_layouts()
        baseStyles()
    }
    
    func baseStyles() {
        backgroundColor = .whiteColor()
        scrollView.pagingEnabled = true
        scrollView.contentInset = UIEdgeInsetsZero
        
    }
    
    
    let contentView: UIView = UIView(frame: .zero)
}

extension YCSegmentPagesScrollEngine {
    
    private func snp_layouts() {
        scrollView.snp_makeConstraints { (make) in
            make.size.equalTo(snp_size)
            make.center.equalTo(snp_center)
        }
        
        contentView.snp_makeConstraints(closure: { (make) in
            make.left.equalTo(self.scrollView.snp_left)
            make.right.equalTo(self.scrollView.snp_right)
            make.height.equalTo(self.scrollView.snp_height)
            make.centerY.equalTo(self.scrollView.snp_centerY)
            make.width.equalTo(1)
        })
    }
    
}


class YCScrollView : UIScrollView {
    
    var contentOffsetDidChange: ((CGPoint) -> Void)?
    
    override var contentOffset: CGPoint {
        didSet {
            self.contentOffsetDidChange?(contentOffset)
        }
    }
    
}