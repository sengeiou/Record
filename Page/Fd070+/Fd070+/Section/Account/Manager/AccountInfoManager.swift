//
//  AccountInfoManager.swift
//  FD070+
//
//  Created by WANG DONG on 2018/12/17.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import Foundation


/// 区分不同的第三方登录
///
/// - wechat: 微信登录
/// - facebook: facebook登录
/// - Idle: 空闲状态
public enum loginThirdType:String {
    
    case wechat = "wechat"
    
    case facebook = "facebook"
    
    case Idle = "Idle"
}


/// 处理登录成功或者登录失败之后的数据。
struct AccountInfoManager {
    static let accountSynUrl = ServreAPICommone.ServerSpecify.rootDomain + "fd070_plus_web/index.html#/login"
    static let accountLoginCallBack = "login"
    static let accountThirdLoginCallBack = "loginOther"

    
    /// 处理非第三方登录对应的数据
    /////            self.navigationController?.pushViewController(DeviceSelectDevcieViewController(), animated: true)
    /// - Parameter loginDic: 返回的数据
    static func handleLoginInfo(_ loginDic:[String:String],_ logBlock:(_ isSuccess:Bool)->()) {
        
        print(loginDic)
        
        if loginDic["key"] == "success" {
            if let loginSuccessStr = loginDic["value"] {
                let LoginSuccessDic = FDJsonManager.getDictionaryFromJSONString(jsonString: loginSuccessStr)

                if let token = LoginSuccessDic["token"] {
                    
                    UserDefaults.LoginSuccessUserDefault.Login_Token.store(value: token)
                }
                
                if let params = LoginSuccessDic["params"] {
                    let str = FDEncrytionManager.Decryption_AES_BCB(strToEncode: params as! String, type: .AES_128_Account)
                    print(str)
                    let LoginparamsDic = FDJsonManager.getDictionaryFromJSONString(jsonString: str)
                    if LoginparamsDic.allKeys.count > 0  {
                        UserDefaults.LoginSuccessUserDefault.Login_Appid.store(value: LoginparamsDic["appid"])
                        UserDefaults.LoginSuccessUserDefault.Login_Userid.store(value: LoginparamsDic["userid"])
                        UserDefaults.LoginSuccessUserDefault.Login_Account.store(value: LoginparamsDic["account"])
                        UserDefaults.LoginSuccessUserDefault.Login_Password.store(value: LoginparamsDic["password"])
                        
                        logBlock(true)
                        return
                    }
                }
                print(LoginSuccessDic)
            }
        }
        logBlock(false)

    }
    
    
    /// 处理第三方登录
    ///
    /// - Parameter LoginType: 对应第三方登录的类型
    static func handleThirdLogin(LoginType:loginThirdType) {
        
        switch LoginType {
        case .wechat:
            print(LoginType)
        case .facebook:
            print(LoginType)
        case .Idle:
            print(LoginType)
        }
    }
}


//Custom UserDefaults Kes
extension UserDefaults {
    
        enum LoginSuccessUserDefault: String, UserDefaultSettable {
            case Login_Token
            case Login_Params
            case Login_ExpireIn
            
            case Login_Appid
            case Login_Userid
            case Login_Account
            case Login_Password
        }
}
