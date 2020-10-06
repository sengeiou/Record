//
//  ViewControllerAppDelegate.swift
//  FD070+
//
//  Created by HaiQuan on 2019/4/22.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import UIKit
// 控制器处理
class ViewControllerAppDelegate: AppDelegateType {
   
}
extension AppDelegate {
    func changeRootViewController() {

        UIView.transition(with: (UIApplication.shared.keyWindow)!, duration: 0.35, options: .transitionCrossDissolve, animations: {
            self.window!.rootViewController = BaseTabBarController()
        }, completion: nil)


        self.window?.backgroundColor = .white
        self.window?.makeKeyAndVisible()
    }

    static func getDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}
