//
//  FDUserStatisticsAPIManager.swift
//  FD070+
//
//  Created by WANG DONG on 2019/1/11.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import UIKit

struct userBehaviorStatic {
    static let behaviorSubUrl = "monitorsys/backend/back/upload.php"
}

struct FDUserStatisticsAPIManager {
    
    public static func getAppActiveData() {

        let softwareV:String = UserDefaults.DeviceInfoUserDefault.Device_SoftVersion.storedValue as? String ?? ""
        let userModel = try! UserinfoDataHelper.findFirstRow(userID: CurrentUserID) 

        let APPDic:Dictionary = [
            "appid": ServreAPICommone.APPInfoCommone.APPID,
            "userid":UserDefaults.LoginSuccessUserDefault.Login_Userid.storedValue as! String,
            "nickname":"\(userModel.firstname) \(userModel.lastname)",
            "deviceid":FDPhoneInfoManager().deviceUUID,
            "mac_addr": BleConnectState.getCurrentConnectMacAdress(),
            "phone_type":FDPhoneInfoManager().modelName,
            "phone_os":FDPhoneInfoManager().sysName,
            "serial_number":"123",
            "os_ver":"v\(FDPhoneInfoManager().sysVersion)",
            "app_ver":FDAppInfoManager.getMajorVersion(),
            "bt_ver":softwareV,
            "icon":userModel.icon,
            "vendor":"iphone",
            "os_lang":FDPhoneInfoManager().iphone_languagle
            ]as [String : Any]


        let url = ServreAPICommone.ServreCommone.punchBaseUrl
        NetworkingTools.shared.postFdEncrayp(url: url, paramter: APPDic as! [String : String], encraypType: .AES_128_UserHehavior, token: UserDefaults.LoginSuccessUserDefault.Login_Token.storedValue as! String) { (type, respondDic,tipDescript) in
            if type == .success {
                print("用户行为统计提交成功")
                return
            }
            print("用户行为统计提交失败")
        }

        FDLog("+>>APPID>>\(ServreAPICommone.APPInfoCommone.APPID)")
    }
    
}
