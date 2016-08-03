//
//  YCSegmentItemModel.swift
//  SegmentController
//
//  Created by LakesMac on 16/8/3.
//  Copyright © 2016年 iLakeYC. All rights reserved.
//

import UIKit

class YCSegmentItemModel: NSObject {
    
    ///
    /// model的标识，默认为nil
    ///
    var tag : Int?
    
    ///
    /// 分页显示的标题，默认为nil
    ///
    var title : String?
    
    ///
    /// 携带自定义信息，默认为nil
    ///
    var userInfo: [String: AnyObject]?
    
    override init() {
        super.init()
    }
}
