//
//  UserInfoAPIManager.swift
//  FD070+
//
//  Created by WANG DONG on 2019/1/2.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import UIKit

struct userInfoSubUrl {
    static let getUserinfoUrl = "/user/get_userinfo/"
    static let setUserinfoUrl = "/user/set_userinfo/"
}

struct FDUserInfoAPIManager {

    static func userInfoSetManager(userinfoDic:[String:String],returnBlock:@escaping (_ paramData:[String:Any],_ result:Bool)->()) {
        let url = ServreAPICommone.ServreCommone.businessBaseUrl + userInfoSubUrl.setUserinfoUrl
        NetworkingTools.shared.postFdEncrayp(url: url, paramter: userinfoDic, encraypType: .AES_128_Business, token: UserDefaults.LoginSuccessUserDefault.Login_Token.storedValue as! String) { (type, respondDic,tipDescript) in
            if type == .success {
                returnBlock(respondDic!,true)
                return
            }
            returnBlock([:],false)
        }
        
    }
    
    static func userInfoGetManager(userinfoDic:[String:String],returnBlock:@escaping (_ paramData:[String:Any],_ result:Bool)->()) {
        let url = ServreAPICommone.ServreCommone.businessBaseUrl + userInfoSubUrl.getUserinfoUrl
        NetworkingTools.shared.postFdEncrayp(url: url, paramter: userinfoDic, encraypType: .AES_128_Business, token: UserDefaults.LoginSuccessUserDefault.Login_Token.storedValue as! String) { (type, respondDic,tipDescript) in
            if type == .success {
                returnBlock(respondDic!,true)
                return
            }
            returnBlock([:],false)
        }
    }
    
}
