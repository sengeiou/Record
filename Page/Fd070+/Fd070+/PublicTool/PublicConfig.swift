//
//  PublicConfig.swift
//  FD070+
//
//  Created by WANG DONG on 2018/12/11.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import UIKit

// screen width
let SCREEN_WIDTH = UIScreen.main.bounds.size.width

// screen height
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

let MainColor = UIColor.RGB(r: 0, g: 122, b: 255)

let CLightBlueColor = UIColor.hexColor(0xd8d8d8)

/// Font Fit
///
/// - Parameter size: Original font
/// - Returns: Right font
func Font(size:CGFloat) -> CGFloat {
    
    if (SCREEN_WIDTH == 320) {
        return size - 2
    }else if (SCREEN_WIDTH == 375){
        return size
    }else{
        return size + 2
    }
}
var CurrentAppID: String {
    get {
        return "23518"
    }
}
var CurrentUserID: String {
    get {
        return UserDefaults.LoginSuccessUserDefault.Login_Userid.storedValue as? String ?? "123"
    }
}
var CurrentMacAddress: String {
    get {
        var macAddress = BleConnectState.getCurrentConnectMacAdress()
        //第一次登录，还没连接蓝牙的情况下，在网络请求的数据是存在数据库的
        if macAddress.isEmpty {
            let deviceStroed = try! DeviceInfoDataHelper.findAll()?.first ?? DeviceInfoModel()
            macAddress = deviceStroed.bt_mac
        }
        return macAddress

    }
}
var CurrentBandVersion: String {
    get {
        return UserDefaults.DeviceInfoUserDefault.Device_SoftVersion.storedValue as? String ?? "V00.00.00.190101_beta"

//        #if RELEASE
//        return "V00.00.01.190101_release"
//        #elseif BETA
//        return "V00.00.01.190101_beta"
//        #else // DEVElOP
//        return "V00.00.01.190101_rc"
//        #endif
    }
}
var CurrentPlatform: String {
    get {
        #if RELEASE
        return "release-iOS"
        #elseif BETA
        return "beta-iOS"
        #else // DEVElOP
        return "rc-iOS"
        #endif
    }
}

var CurrentTargetStep: String {
    get {
        //Query userinfor data
        let userModel = try! UserinfoDataHelper.findFirstRow(userID: CurrentUserID)

        //Update user target
        return userModel.goal
    }
}

struct DefaultValue {
    static let placeString = "---"
}

/// Get user major Version
///
/// - Returns: The user major Versiion
var CurrentAppVersion: String {
    get {
        let infoDictionary = Bundle.main.infoDictionary
        var majorVersion :String? = infoDictionary? ["CFBundleShortVersionString"] as? String//主程序版本号
        majorVersion = String(format: "V%@", majorVersion!)
        return majorVersion!
    }
}


