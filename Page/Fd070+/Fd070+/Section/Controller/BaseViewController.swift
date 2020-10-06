//
//  BaseViewController.swift
//  FD070+
//
//  Created by HaiQuan on 2018/12/17.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import RxSwift
import RxCocoa

class BaseViewController: UIViewController,NVActivityIndicatorViewable {

    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var maskBgView:UIView?
    var activityView = NVActivityIndicatorView.init(frame: CGRect.zero)

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = MainColor

        //设置全局导航栏样式
        self.navigationController?.navigationBar.backIndicatorImage = UIImage.init(named: "back_icon")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage.init(named: "back_icon")
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)

        //设置导航栏的内容的主题颜色
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = MainColor
        navigationController?.navigationBar.isTranslucent = false
        //隐藏导航栏最下面的横线
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")

        //
        self.activityView = NVActivityIndicatorView.init(frame: CGRect.init(x: view.centerX-25, y: view.centerY-25, width: 50, height: 50), type: NVActivityIndicatorType.lineScale, color: MainColor, padding: 1)
        maskBgView = UIView()
        maskBgView?.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        maskBgView?.backgroundColor = UIColor(white: 0, alpha: 0.5)
        maskBgView?.tag = 22222
        maskBgView?.addSubview(self.activityView)
        
        self.initDisplayData()
        self.initDisplayView()
        
        
    }
    
    func initDisplayView() {
        

    }
    
    func initDisplayData() {
        
    }
    
    /// Start mask animation
    ///
    /// - Parameter tipStr: Tip string
    func startMaskAnimation(tipStr:String) {
        
        if appDelegate.isMaskDisplay == false {
            appDelegate.isMaskDisplay = true
            self.activityView.startAnimating()
            UIApplication.shared.keyWindow?.addSubview(maskBgView!)
        }
        else
        {
            stopMaskAnimation();
            startMaskAnimation(tipStr: tipStr)
        }
    }
    
    /// Stop mask Animation
    func stopMaskAnimation() {
        
        appDelegate.isMaskDisplay = false
        self.activityView.stopAnimating()
        UIApplication.shared.keyWindow?.viewWithTag(22222)?.removeFromSuperview()
    }
    
    deinit {
        FDLog("deinit: \(type(of: self))")
    }
}
