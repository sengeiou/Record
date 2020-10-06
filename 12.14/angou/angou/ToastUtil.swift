//
//  ToastUtil.swift
//  costpang
//
//  Created by FENGBOLAI on 16/2/3.
//  Copyright © 2016年 FENGBOLAI. All rights reserved.
//

import UIKit
//import MBProgressHUD

class ToastUtil{
    
    static func textTop(_ inView: UIView, text: String){
        textTopOrBottom(inView, text: text, position: 1)
    }
    
    static func textBottom(_ inView: UIView, text: String){
        textTopOrBottom(inView, text: text, position: -1)
    }
    
    fileprivate static func textTopOrBottom(_ inView: UIView, text: String, position: Int){
        
        DispatchQueue.global().async(execute: {
            DispatchQueue.main.async(execute: {
                
                let hud = MBProgressHUD.showAdded(to: inView, animated: true)
                hud?.color = UIColor.gray
                hud?.mode = MBProgressHUDMode.text
                hud?.labelText = text
                hud?.labelFont = FontUtil.bigBoldFont()
                if position == 1{
                    hud?.yOffset = -Float(Constants.HEIGHT_SCREEN / CGFloat(4))
                }
                else{
                    hud?.yOffset = Float(Constants.HEIGHT_SCREEN / CGFloat(4))
                }
                hud?.hide(true, afterDelay: 1)
            })
        })
    }
    
    static func customView(_ inView: UIView, text: String){

        DispatchQueue.global().async(execute: {
            DispatchQueue.main.async(execute: {
                
                let hud = MBProgressHUD.showAdded(to: inView, animated: true)
                hud?.color = UIColor.darkGray
                
                hud?.mode = MBProgressHUDMode.customView
                hud?.labelText = text
                hud?.labelFont = FontUtil.biggerFont()
                hud?.yOffset = Float(Constants.HEIGHT_SCREEN / CGFloat(4))
                
                if let image = UIImage(named: "checkmark.png") {
                    hud?.customView = UIImageView(image: image)
                    hud?.isSquare = true
                }
                
                hud?.hide(true, afterDelay: 1)
            })
        })
    }
    
    // Covers the entire screen.
    
    /**
    加载界面
    - parameter inView:  ViewController的view
    - parameter coverMe: 是否用空白view盖住
    */
    static func showCover(_ inView: UIView, coverMe: Bool){
        DispatchQueue.global().async(execute: {
            DispatchQueue.main.async(execute: {
                // 覆盖一个view
                if coverMe{
                    let coverView = UIView()
                    if let naviBar = inView.viewWithTag(99999){
                        coverView.frame = CGRect(x: 0, y: naviBar.frame.height + 1, width: Constants.WIDTH_SCREEN, height: Constants.HEIGHT_SCREEN - naviBar.frame.height)
                    }
                    else{
                        coverView.frame = CGRect(x: 0, y: 0, width: Constants.WIDTH_SCREEN, height: Constants.HEIGHT_SCREEN)
                    }
                    coverView.tag = 88888
                    coverView.backgroundColor = UIColor.white
                    inView.addSubview(coverView)
                
                    let hud = MBProgressHUD.showAdded(to: coverView, animated: true)
                    //        hud.graceTime = 0.1 // If the task finishes before the grace time runs out, the HUD will not be shown at all
                    //        hud.minShowTime = 2 // This avoids the problem of the HUD being shown and than instantly hidden
                    hud?.color = UIColor.lightGray
                }
                else{
                    MBProgressHUD.showAdded(to: inView, animated: true)
                }
            })
        })
    }
    
    // hide Covers the entire screen.
    static func hideCover(_ inView: UIView){
        DispatchQueue.global().async(execute: {
            DispatchQueue.main.async(execute: {
                // 去除覆盖的view
                if let coverView = inView.viewWithTag(88888){
                    // coverMe为false时，不执行
                    coverView.removeFromSuperview()
                }
                MBProgressHUD.hideAllHUDs(for: inView, animated: true)
            })
        })
    }
    
    // 网络异常
    static func netError(_ inView: UIView){
        DispatchQueue.global().async(execute: {
            DispatchQueue.main.async(execute: {
                
                let hud = MBProgressHUD.showAdded(to: inView, animated: true)
                hud?.color = UIColor.lightGray
                
                hud?.mode = MBProgressHUDMode.text
                hud?.labelText = LocaleString("networkNotAvailable")
                hud?.labelFont = FontUtil.biggerFont()
                
                hud?.hide(true, afterDelay: 1)
            })
        })
    }
}
