//
//  AppDelegate.swift
//  FD070+
//
//  Created by WANG DONG on 2018/12/11.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var isMaskDisplay:Bool = false //处理多次出现弹出框
    //血压的开始测试时间，用于血压当前是否正在测试，以及测试是否到5分钟
    //开始测试血压时设置当前的时间戳，测试完成设置改时间戳为0，判断非零为测试中，为另择为未测试。
    var BloodStartTestTime = 0     //血压的开始测试时间，用于血压当前是否正在测试，以及测试是否到5分钟

    let appDelegate = AppDelegateFactory.makeDefault()
    enum AppDelegateFactory {
        static func makeDefault() -> AppDelegateType {

            return CompositeAppDelegate(appDelegates: [
                PushNotificationsAppDelegate(),
                ViewControllerAppDelegate(),
                ThirdPartiesConfiguratorAppDelegate(),
                OtherAppDelegate()
                ]
            )
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        _ = appDelegate.application?(application, didFinishLaunchingWithOptions: launchOptions)

        guard UserDefaults.LoginSuccessUserDefault.Login_Token.storedValue != nil else {
            let rootViewController = UIStoryboard(name: "Main", bundle: nil)
                .instantiateInitialViewController() as! LaunchingViewController
            let navigationCon = UINavigationController(rootViewController: rootViewController)

            navigationCon.setNavigationBarHidden(true, animated: true)
            self.window!.rootViewController = navigationCon

            return true
        }

        //直接设置Myday页为根视图
        self.window!.rootViewController = BaseTabBarController()
        self.window?.backgroundColor = .white
        self.window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        appDelegate.applicationWillResignActive?(application)
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        appDelegate.application?(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        appDelegate.applicationDidBecomeActive?(application)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        appDelegate.applicationDidEnterBackground?(application)
    }
    func applicationWillTerminate(_ application: UIApplication) {
        appDelegate.applicationWillTerminate?(application)
    }

}
    


