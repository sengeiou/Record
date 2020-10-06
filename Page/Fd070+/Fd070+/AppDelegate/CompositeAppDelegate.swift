//
//  CompositeAppDelegate.swift
//  FD070+
//
//  Created by HaiQuan on 2019/4/22.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import UIKit

typealias AppDelegateType = UIResponder & UIApplicationDelegate

class CompositeAppDelegate: AppDelegateType {
    private let appDelegates: [AppDelegateType]

    init(appDelegates: [AppDelegateType]) {
        self.appDelegates = appDelegates
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        appDelegates.forEach { _ = $0.application?(application, didFinishLaunchingWithOptions: launchOptions) }
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        appDelegates.forEach { _ = $0.application?(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken) }
    }


    func applicationDidEnterBackground(_ application: UIApplication) {
        appDelegates.forEach { _ = $0.applicationDidEnterBackground?(application)
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        appDelegates.forEach { _ = $0.applicationDidBecomeActive?(application)
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        appDelegates.forEach { _ = $0.applicationWillResignActive?(application)
        }
    }


    func applicationWillTerminate(_ application: UIApplication) {
        appDelegates.forEach { _ = $0.applicationWillTerminate?(application)
        }
    }
}
