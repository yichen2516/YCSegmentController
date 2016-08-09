//
//  YCSegmentConfiguration.swift
//  SegmentController
//
//  Created by LakesMac on 16/8/3.
//  Copyright © 2016年 iLakeYC. All rights reserved.
//

import UIKit

class YCSegmentConfiguration {

    static let globalConfig = YCSegmentConfiguration()
    
    var pageControlItemConfig = YCSegmentPageControlItemConfig()
    
    
}

struct YCSegmentPageControlItemConfig {
    
    var font: UIFont                = UIFont.systemFontOfSize(15)

    var textColor: UIColor          = UIColor(red: 149/255, green: 152/255, blue: 154/255, alpha: 1)

    var highlightTextColor: UIColor = UIColor(red: 255/255, green: 101/255, blue: 121/255, alpha: 1)
    
    var itemSpacing: CGFloat        = 10
}

