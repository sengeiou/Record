//
//  FDDymanicConfigAPIManager.swift
//  FD070+
//
//  Created by HaiQuan on 2019/3/27.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import Foundation
import SwiftyJSON

struct DymanicConfigUrl {
    static let subUrl = "http://xlab-cloud.oss-cn-shenzhen.aliyuncs.com/config/fd070_plus.cfg"

}

struct FDDymanicConfigAPIManager {

    static func getDymanicConfigFile() {

        NetworkingTools.shared.get(url: DymanicConfigUrl.subUrl, parameters: nil) { (status, response, tip) in

            switch status {
            case .success:
                analyzeConfigFile(response)
            default:
                break
            }

        }
    }

    private static func analyzeConfigFile(_ response:Dictionary<String, Any>?) {

        FDLog("dymanic file json is:\(String(describing: response))")

        let json = JSON(response as Any)

        var keyWords = ""

        #if RELEASE
        keyWords = "release"
        #elseif BETA
        keyWords = "beta"
        #else // DEVElOP
        keyWords = "develop"
        #endif

        FDLog("current environmental keyWords: \(keyWords)")
        let environmental = json[keyWords].dictionaryValue

        analyzeAccountConfigFile(originalData: environmental)

        analyzeBusinessConfigFile(originalData: environmental)

        analyzeUpgradeConfigFile(originalData: environmental)

        analyzePunchConfigFile(originalData: environmental)

        //根据业务的需求，增加辅助功能
        analyzeOtherConfigFile(originalData: environmental)

    }
}
extension FDDymanicConfigAPIManager {

    private static func analyzeAccountConfigFile(originalData: [String: JSON]) {
        //取出账号的JSON文件
        guard let account = originalData["account"]  else {
            return
        }
        var accountScheme = "", accountHost = ""
        if account["ssl"].stringValue == "enable" {
            accountScheme = account["ssl-scheme"].stringValue
            accountHost = account["ssl-host"].stringValue
        }else {
            accountScheme = account["scheme"].stringValue
            accountHost = account["host"].stringValue
        }
        //设置账号的协议名称和主机名
        ServreAPICommone.ServreCommone.accountBaseUrl = accountScheme + "://" + accountHost

        //设置账号系统访问秘钥accessID 对应AES key值, 设置账号系统访问秘钥accessKey 对应AES iv值
        FDEncrytionInfo.APP_FD_AccountKey = account["aeskey"].stringValue
        FDEncrytionInfo.APP_FD_AccountIValue = account["aesiv"].stringValue

        //设置AppID
        ServreAPICommone.APPInfoCommone.APPID = account["appid"].stringValue
    }

    private static func analyzeBusinessConfigFile(originalData: [String: JSON]) {
        // 取出业务的JSON文件
        guard let api = originalData["api"] else {
            return
        }
        var businessScheme = "", businessHost = ""
        if api["ssl"].stringValue == "enable" {
            businessScheme.filterNetworkString(api["ssl-scheme"].stringValue)
            businessHost.filterNetworkString(api["ssl-host"].stringValue)
        }else {
            businessScheme.filterNetworkString(api["scheme"].stringValue)
            businessHost.filterNetworkString(api["host"].stringValue)
        }
        //设置业务的协议名称和主机名
        ServreAPICommone.ServreCommone.businessBaseUrl = businessScheme + "://" + businessHost

        //设置业务系统访问秘钥accessID 对应AES key值, 设置业务系统访问秘钥accessKey 对应AES iv值
        FDEncrytionInfo.APP_FD_BusinessKey.filterNetworkString(api["aeskey"].stringValue)
        FDEncrytionInfo.APP_FD_BusinessIValue.filterNetworkString(api["aesiv"].stringValue)

        //设置AppID
        ServreAPICommone.APPInfoCommone.APPID = api["appid"].stringValue
    }

    private static func analyzeUpgradeConfigFile(originalData: [String: JSON]) {

        // 取出升级模块的配置JSON文件
        guard let upgrade = originalData["upgrade"] else {
            return
        }
        var upgradeScheme = "", upgradeHost = ""
        if upgrade["ssl"].stringValue == "enable" {
            upgradeScheme.filterNetworkString(upgrade["ssl-scheme"].stringValue)
            upgradeHost.filterNetworkString(upgrade["ssl-host"].stringValue)
        }else {
            upgradeScheme.filterNetworkString(upgrade["scheme"].stringValue)
            upgradeHost.filterNetworkString(upgrade["host"].stringValue)
        }
        //设置业务的协议名称和主机名
        ServreAPICommone.ServreCommone.upgradeBaseUrl = upgradeScheme + "://" + upgradeHost

        //设置升级系统访问秘钥accessID 对应AES key值, 设置业务系统访问秘钥accessKey 对应AES iv值
        FDEncrytionInfo.APP_FD_UpgradeKey.filterNetworkString(upgrade["aeskey"].stringValue)
        FDEncrytionInfo.APP_FD_UpgradeIValue.filterNetworkString(upgrade["aesiv"].stringValue)

        //设置AppID
        ServreAPICommone.APPInfoCommone.APPID = upgrade["appid"].stringValue

    }

    private static func analyzePunchConfigFile(originalData: [String: JSON]) {

        // 取出打卡业务的配置JSON文件
        guard let punch = originalData["punch"] else {
            return
        }
        var punchScheme = "", punchHost = ""
        if punch["ssl"].stringValue == "enable" {
            punchScheme.filterNetworkString(punch["ssl-scheme"].stringValue)
            punchHost.filterNetworkString(punch["ssl-host"].stringValue)
        }else {
            punchScheme.filterNetworkString(punch["scheme"].stringValue)
            punchHost.filterNetworkString(punch["host"].stringValue)
        }
        //设置业务的协议名称和主机名
        ServreAPICommone.ServreCommone.punchBaseUrl = punchScheme + "://" + punchHost

        //设置打卡系统访问秘钥accessID 对应AES key值, 设置业务系统访问秘钥accessKey 对应AES iv值
        FDEncrytionInfo.APP_FD_UserHehaviorKey.filterNetworkString(punch["aeskey"].stringValue)
        FDEncrytionInfo.APP_FD_UserHehaviorIValue.filterNetworkString(punch["aesiv"].stringValue)

        //设置AppID
        ServreAPICommone.APPInfoCommone.APPID = punch["appid"].stringValue

    }

    private static func analyzeOtherConfigFile(originalData: [String: JSON]) {

        // 取出Other配置JSON文件
        guard let other = originalData["other"] else {
            return
        }

        FDDymanicConfigInfo.general_mode_interval = other["app_policy_cfg"]["general_mode_interval"].intValue
        FDDymanicConfigInfo.sleep_detail_interval = other["app_policy_cfg"]["sleep_detail_interval"].intValue
        FDDymanicConfigInfo.sport_detail_interval = other["app_policy_cfg"]["sport_detail_interval"].intValue
    }
}
