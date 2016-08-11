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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        ycview.agent.selected(4)
    }
    
    override func viewDidLayoutSubviews() {
        ycview.reloadData()
    }

    func numberOfPagesInYCSegment(segment: YCSegmentView) -> Int {
        return 50
    }
    func ycSegment(segment: YCSegmentView, modelForItemAtPage: Int) -> YCSegmentItemModel! {
        let model = YCSegmentItemModel()
        let string = "测试"
        model.title = string
        return model
    }

    func ycSegment(segment: YCSegmentView, viewControllerAtPage: Int, userInfo: [String: AnyObject]) -> UIViewController! {
        print("\(viewControllerAtPage) 需要控制器")
        let vc = TestTableViewController(style: UITableViewStyle.Plain)
        let r = CGFloat(arc4random() % 255)
        let g = CGFloat(arc4random() % 255)
        let b = CGFloat(arc4random() % 255)
        let color = UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1)
        vc.view.backgroundColor = color
        return vc
    }

}

