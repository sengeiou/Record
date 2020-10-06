//
//  OtherAppDelegate.swift
//  FD070+
//
//  Created by HaiQuan on 2019/4/22.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import UIKit
//其他的一些AppDelegate设置
class OtherAppDelegate: AppDelegateType {

    func applicationDidEnterBackground(_ application: UIApplication) {
       NetworkDataSyncManager.applicationDidEnterBackground()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
       NetworkDataSyncManager.applicationWillEnterForeground()
    }

}
