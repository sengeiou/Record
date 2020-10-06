//
//  NotificationExtension.swift
//  FD070+
//
//  Created by HaiQuan on 2018/12/17.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

/// Notification enum
enum FDNotification: String {

    case DBTableUpdate
    case ReachabilityChanged
    case reloadIconData

    var notificationName: NSNotification.Name {
        return NSNotification.Name(rawValue)
    }
}

// MARK: - Post notification
extension NotificationCenter {
    static func post(custom name: FDNotification, object: Any? = nil) {
        NotificationCenter.default.post(name: name.notificationName, object: object)
    }
}


// MARK: - Monitor notification
extension Reactive where Base: NotificationCenter {
    func notification(custom name: FDNotification,object: AnyObject? = nil) -> Observable<Notification> {
        return notification(name.notificationName, object: object)
    }
}
