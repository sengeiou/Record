//
//  FDToastTool.swift
//  FD070+
//
//  Created by WANG DONG on 2018/12/24.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import UIKit
import Foundation

struct AlertTool {
    
    /// Show alertView
    ///
    /// - Parameters:
    ///   - message: Message details
    ///   - cancalTitle: CancalTitle
    ///   - action: Action
    static func showAlertView(message: String, cancalTitle: String,action: @escaping () -> Void) {
        
        let alertManager = AlertManager.alertManager(withStyle: .alert, title: nil, messgae: message)
        alertManager.configue(withCancelTitle: cancalTitle, destructiveIndex: 0, otherTitles: [])
        alertManager.showAlertController(fromVC: UIWindow.currentViewController(), actionBlock: { (manager, index, _) in
            action()
        })
    }
    
    /// Show alertview
    ///
    /// - Parameters:
    ///   - title: Title
    ///   - message: Message details
    ///   - cancalTitle: Cancal title
    ///   - action: Action
    static func showAlertView(title:String, message: String, cancalTitle: String,action: @escaping () -> Void) {
        
        let alertManager = AlertManager.alertManager(withStyle: .alert, title: title, messgae: message)
        alertManager.configue(withCancelTitle: cancalTitle, destructiveIndex: 0, otherTitles: [])
        alertManager.showAlertController(fromVC: UIWindow.currentViewController(), actionBlock: { (manager, index, _) in
            action()
        })
    }
    
    /// Show aletView
    ///
    /// - Parameters:
    ///   - title: Title
    ///   - message: Message details
    ///   - action: Action
    static func showAlertView(title:String, message: String, action: @escaping (_ actionIndex: Int) -> Void) {
        
        let alertManager = AlertManager.alertManager(withStyle: .alert, title: title, messgae: message)
        alertManager.configue(withCancelTitle: "Cancel".localiz(), destructiveIndex: 0, otherTitles: ["Ok".localiz()])
        alertManager.showAlertController(fromVC: UIWindow.currentViewController(), actionBlock: { (manager, index, _) in
            action(index)
        })
    }
}
