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

    /// 控制标题间距
    ///
    /// 如果 needTileItems 属性为true，并且当标题宽度只和过短时
    /// 该属性将控制标题左右尽头内边距
    var itemSpacing: CGFloat = 20

    
    /// 当标题宽度只和过短时，是否需要将标题两端对齐
    ///
    /// 当标题宽度只和可以满足滚动时，该属性无效。
    var needTileItems = true
}

