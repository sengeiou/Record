//
//  MainTableViewController.swift
//  angou
//
//  Created by ZippyZhao on 22/11/2016.
//  Copyright © 2016 ZippyZhao. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    
    @IBOutlet weak var timeLabel: UILabel!
    
    
    @IBOutlet weak var plateContainerView: UIView!
    
    @IBOutlet weak var expandButton: UIImageView!
    
    
    @IBOutlet weak var expandButtonContainer: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rotatePlateView = RotatePlateView(frame:CGRect(x: Constants.WIDTH_SCREEN/4, y: 0, width: Constants.WIDTH_SCREEN, height: Constants.WIDTH_SCREEN))
        rotatePlateView.addSubView(withSubView:[], andTitle:["第一个","第二个","第三个","第四个"], andSize:CGSize(width: 80.0, height: 80.0), andcenterImage:nil)
        self.plateContainerView.addSubview(rotatePlateView)
    }
    
    
    
}
