//
//  AdaptiveClass.swift
//  Orangetheory
//
//  Created by HaiQuan on 2018/5/31.
//  Copyright © 2018年 WANG DONG. All rights reserved.
//

import UIKit

public class Adaptive: NSObject {
    
}

/// Screen with adaptation
///
/// - Returns: Screen width
private func screenW() -> CGFloat {
    let size:CGRect = UIScreen.main.bounds
    
    return CGFloat(size.width)
}
/// Screen height adaptation
///
/// - Returns: Screen height
private func screenH() -> CGFloat {
    let size:CGRect = UIScreen.main.bounds
    return CGFloat(size.height)
}

/// Screen with scaling ratio
///
/// - Returns: Zoom size (width) after comparing with the Ip6 screen
private func rateW() -> CGFloat{
    return (screenW()/375)
}

/// Screen scaling ratio
///
/// - Returns: Zoom size (height) after comparing with the Ip6 screen
private func rateH() -> CGFloat{
    var heighttmp:CGFloat = 0.0
    if screenH() == 480 {
        heighttmp = 568
    }else{
        heighttmp = screenH()
    }
    return heighttmp/812
}

/// Scaling of controls
/// - Parameter W: Input widths of control
/// - Returns:  The size of the input control is proportional to the size (width).
func adaptW(W: CGFloat) -> CGFloat {
    return W*rateW()
}

/// Scaling of controls
/// - Parameter H: Input control height
/// - Returns: The size of the input control is proportional to the size (height).
func adaptH(H: CGFloat) -> CGFloat {
    if H == 667 && screenH() == 480 {
        return 480
    }else{
        return H*rateH()
    }
}

// iPhone4

let isIphone4 = SCREEN_HEIGHT < 568 ? true : false

// iPhone 5

let isIphone5 = SCREEN_HEIGHT == 568 ? true : false

// iPhone 6

let isIphone6 = SCREEN_HEIGHT == 667 ? true : false

// iphone 6P

let isIphone6P = SCREEN_HEIGHT == 736 ? true : false

// iphone X

//let isIphoneXSeries = SCREEN_HEIGHT == 812 ? true : false

// navigationBarHeight

let navigationBarHeight : CGFloat = isIphoneXSeries ? 88 : 64

// tabBarHeight

let tabBarHeight : CGFloat = isIphoneXSeries ? 49 + 34 : 49

//statusBar_Height
let statusBarHeight : CGFloat = isIphoneXSeries ? 44 : 20

// NavigationbarHeight
let  NavigationBar : CGFloat = 44

// TabbarBottom
let TabbarSafeBottomMargin_Height : CGFloat = isIphoneXSeries ? 34 : 0

//Status bar height




var isIphoneXSeries: Bool {

    var iPhoneXSeries = false
    let window = UIApplication.shared.keyWindow ?? UIWindow()
    if UIDevice.current.userInterfaceIdiom != UIUserInterfaceIdiom.phone {
        return iPhoneXSeries
    }

    if #available(iOS 11.0, *) {
        if window.safeAreaInsets.bottom > CGFloat(0) {
            iPhoneXSeries = true

        }
    }
    return iPhoneXSeries

}
