//
//  ThirdPartiesConfiguratorAppDelegate.swift
//  FD070+
//
//  Created by HaiQuan on 2019/4/22.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import UIKit
import FendaBLESwiftLib

// 第三方库
class ThirdPartiesConfiguratorAppDelegate: AppDelegateType {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        //网络监听
        FDReachability.shared.startNetworkReachabilityObserver()
        FDReachability.shared.reachabilityBlock = { status in
            if status {
                //动态配置
                FDDymanicConfigAPIManager.getDymanicConfigFile()
            }
        }

        //设置App语言
        setDefaultLanguage()

        //DB Configurator
        DBMigrate()

        //初始化蓝牙模块
        let _ = BleOperatorManager.instance

        return true
    }

}
extension ThirdPartiesConfiguratorAppDelegate {
    /// Data base migrate
    func DBMigrate() {

        if FDFileManager.dataBaseIsExists() {
            //Migrate if needed
            try? SQLiteDataStore.sharedInstance?.migrateIfNeeded()

            FDLog(SQLiteDataStore.sharedInstance?.description)
        }

    }

    /// Set default language.frist login is system Language
    func setDefaultLanguage() {

        if FDLanguageChangeTool.shared.defaultLanguage == .unknown {
            FDLanguageChangeTool.shared.defaultLanguage = FDLanguageChangeTool.shared.currentSystemLanguage

        }
    }
}

