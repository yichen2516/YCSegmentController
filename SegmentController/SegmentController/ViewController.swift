//
//  ViewController.swift
//  SegmentController
//
//  Created by LakesMac on 16/8/2.
//  Copyright © 2016年 iLakeYC. All rights reserved.
//

import UIKit

class ViewController: UIViewController, YCSegmentDelegate, YCSegmentDataSource {

    @IBAction func barbuttonAction(sender: AnyObject) {
        ycview.scrollEngine.scrollView.setContentOffset(CGPointMake(300, 0), animated: false)
    }
    
    
    @IBOutlet weak var ycview: YCSegmentView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        ycview.delegate = self
        ycview.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        ycview.reloadData()
    }

    func numberOfPagesInYCSegment(segment: YCSegmentView) -> Int {
        return 40
    }
    func ycSegment(segment: YCSegmentView, modelForItemAtPage: Int) -> YCSegmentItemModel! {
        let model = YCSegmentItemModel()
        model.title = "测试"
        return model
    }


}

