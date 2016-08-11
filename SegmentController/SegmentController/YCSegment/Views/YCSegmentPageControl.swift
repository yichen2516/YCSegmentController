//
//  YCSegmentPageControl.swift
//  SegmentController
//
//  Created by LakesMac on 16/8/2.
//  Copyright © 2016年 iLakeYC. All rights reserved.
//

import UIKit

class YCSegmentPageControl: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAllViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupAllViews()
    }
    

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    func setupAllViews() {
        addSubview(collectionView)
        collectionView.registerClass(YCSegmentPageControlItem.self, forCellWithReuseIdentifier: YCSegmentPageControlItem.id)
        snp_layouts()
        baseStyles()
    }
    
    func baseStyles(){
        backgroundColor = .whiteColor()
        if let collectionViewLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            collectionViewLayout.scrollDirection   = .Horizontal
            collectionViewLayout.sectionInset      = UIEdgeInsetsMake(0,
                                                                      YCSegmentConfiguration.globalConfig.pageControlItemConfig.itemsInsetLeft ??
                                                                      YCSegmentConfiguration.globalConfig.pageControlItemConfig.itemSpacing,
                                                                      0,
                                                                      YCSegmentConfiguration.globalConfig.pageControlItemConfig.itemsInsetRight ??
                                                                      YCSegmentConfiguration.globalConfig.pageControlItemConfig.itemSpacing)
        }
        collectionView.scrollsToTop = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator   = false
        collectionView.backgroundColor = .whiteColor()
    }
    
    
    lazy var shadowImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        self.addSubview(view)
        view.snp_makeConstraints(closure: { (make) in
            make.left.equalTo(self.snp_left)
            make.left.equalTo(self.snp_right)
            make.top.equalTo(self.snp_bottom)
        })
        return view
    }()
    

}

extension YCSegmentPageControl {
    
    private func snp_layouts() {
        collectionView.snp_makeConstraints { (make) in
            make.size.equalTo(snp_size)
            make.center.equalTo(snp_center)
        }
    }
}

class YCSegmentPageControlItem : UICollectionViewCell {
    
    static let id = "cellReuseIdentifiy"
    
    let label             = UILabel(frame: .zero)
    let selectedIndicator = UIView(frame: .zero)
    
    var model: YCSegmentItemModel? {
        didSet {
            guard let _model = model else {
                print("没有找到model")
                return
            }
            label.text = _model.title
            setupConfig()
        }
    }
    
    override var selected: Bool {
        didSet {
            if selected {
                label.textColor = YCSegmentConfiguration.globalConfig.pageControlItemConfig.highlightTextColor
            } else {
                label.textColor = YCSegmentConfiguration.globalConfig.pageControlItemConfig.textColor
            }
            selectedIndicator.hidden = !selected
        }
    }
    
    private func setupConfig() {
        label.textColor = YCSegmentConfiguration.globalConfig.pageControlItemConfig.textColor
        label.font      = YCSegmentConfiguration.globalConfig.pageControlItemConfig.font
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAllViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupAllViews()
    }
    
    func setupAllViews() {
        backgroundColor = .clearColor()
        contentView.backgroundColor = .clearColor()
        label.textAlignment = .Center
        
        
        contentView.snp_makeConstraints { (make) in
            make.size.equalTo(snp_size)
            make.center.equalTo(snp_center)
        }
        contentView.addSubview(label)
        label.snp_makeConstraints { (make) in
            make.center.equalTo(contentView.snp_center)
            make.width.equalTo(contentView.snp_width)
            make.height.equalTo(contentView.snp_height)
        }
        
        contentView.addSubview(selectedIndicator)
        selectedIndicator.backgroundColor = YCSegmentConfiguration.globalConfig.pageControlItemConfig.highlightTextColor
        selectedIndicator.hidden = true
        selectedIndicator.snp_makeConstraints { (make) in
            make.left.equalTo(contentView.snp_left).offset(-YCSegmentConfiguration.globalConfig.pageControlItemConfig.selectedIndicatorPadding)
            make.right.equalTo(contentView.snp_right).offset(YCSegmentConfiguration.globalConfig.pageControlItemConfig.selectedIndicatorPadding)
            make.bottom.equalTo(contentView.snp_bottom)
            make.height.equalTo(YCSegmentConfiguration.globalConfig.pageControlItemConfig.selectedindicatorHeight)
        }
    }
}