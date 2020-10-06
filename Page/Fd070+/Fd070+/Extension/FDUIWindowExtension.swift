//
//  UIWindow.swift
//  FD070+
//
//  Created by HaiQuan on 2018/12/13.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import Foundation
import UIKit

extension UIWindow {

    /// Get current viewController
    ///
    /// - Returns: Current viewcontroller
    public class func currentViewController() -> UIViewController {
        return self.findBestViewController(UIApplication.shared.keyWindow?.rootViewController)
    }

    /// Find top viewcontroller
    ///
    /// - Parameter vc: Root viewcontroller
    /// - Returns: The top viewcontoller
    private class func findBestViewController(_ vc: UIViewController?) -> UIViewController {
        if ((vc?.presentedViewController) != nil) {
            return self.findBestViewController(vc?.presentedViewController)
        } else if (vc?.isKind(of: UISplitViewController.classForCoder()) == true) {
            let masterVC = vc as! UISplitViewController
            if masterVC.viewControllers.count > 0 {
                return self.findBestViewController(masterVC.viewControllers.last)
            } else {
                return vc!
            }
        } else if (vc?.isKind(of: UINavigationController.classForCoder()) == true) {
            let nav = vc as! UINavigationController
            if nav.viewControllers.count > 0 {
                return self.findBestViewController(nav.topViewController)
            } else {
                return vc!
            }
        } else if (vc?.isKind(of: UITabBarController.classForCoder()) == true) {
            let tabBar = vc as! UITabBarController
            if (tabBar.viewControllers?.count)! > 0 {
                return self.findBestViewController(tabBar.selectedViewController)
            } else {
                return vc!
            }
        } else {
            return vc!
        }
    }
}

