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
    
    var viewControllers: [Int: UIViewController] = [:]
    var leftVC : UIViewController?
    var rightVC : UIViewController?
    var currentVC : UIViewController?
    
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
    ///通过设置contentView的宽度，自动设置contnetSize
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

    private func setupAllViews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        snp_layouts()
        baseStyles()
    }
    
    private func baseStyles() {
        backgroundColor = .whiteColor()
        scrollView.pagingEnabled = true
        scrollView.scrollsToTop  = false
        scrollView.contentInset  = UIEdgeInsetsZero
        
    }
    
    func scrollTo(page: Int) {
        let needsContentOffsetX = scrollView.frame.size.width * CGFloat(page - 1)
        scrollView.setContentOffset(CGPointMake(needsContentOffsetX, 0), animated: false)
    }
    
    let contentView: UIView = UIView(frame: .zero)
    
    var currentPage: Int?
    /// 添加一个视图控制器，如果需要
    func addViewController(
        need: () -> UIViewController,
        atPage: Int
        ) {
        var _vc = viewControllers[atPage]
        if _vc == nil {
            _vc = need()
            if let view = _vc?.view {
                contentView.addSubview(view)
            }
            viewControllers[atPage] = _vc
        }
        currentPage = atPage
        remove(atPage)
        layoutViewController(atPage)
    }
    
    private func remove(
        atPage: Int
        ) {
        let left = atPage - 3
        let right = atPage + 3
        print("释放 \(left)")
        print("释放 \(right)")
        viewControllers[left]?.view.removeFromSuperview()
        viewControllers[left] = nil
        viewControllers[right]?.view.removeFromSuperview()
        viewControllers[right] = nil
    }
    
    private func layoutViewController(
        atPage: Int
        ) {
        let vc      = viewControllers[atPage]
        let vcLeft  = viewControllers[atPage - 1]
        let vcRight = viewControllers[atPage + 1]
        
        if var frame = vc?.view.frame {
            if atPage >= 1 {
                frame.origin.x = scrollView.frame.size.width * CGFloat(atPage - 1)
                frame.size     = scrollView.frame.size
                frame.origin.y = 0
                vc?.view.frame = frame
            }
        }
        if var frame = vcLeft?.view.frame {
            if atPage >= 1 {
                frame.origin.x = scrollView.frame.size.width * CGFloat(atPage - 2)
                frame.size     = scrollView.frame.size
                frame.origin.y = 0
                vcLeft?.view.frame = frame
            }
        }
        if var frame = vcRight?.view.frame {
            frame.origin.x = scrollView.frame.size.width * CGFloat(atPage)
            frame.size     = scrollView.frame.size
            frame.origin.y = 0
            vcRight?.view.frame = frame
        }
    }
    
    override func layoutSubviews() {
        guard currentPage != nil else {return}
        layoutViewController(currentPage!)
    }
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