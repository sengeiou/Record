//
//  FDHRInfoAPIManager.swift
//  FD070+
//
//  Created by WANG DONG on 2019/1/2.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import UIKit


struct HRInfoSubUrl {
    static let getHRDetailUrl = "/rate/get_detail/"
    static let setHRDetailUrl = "/rate/set_detail/"
}

struct FDHRInfoAPIManager {

    static func heartRateDetailSetManager(heartRateDetailDic:[String:String],returnBlock:@escaping (_ paramData:[String:Any],_ result:Bool)->()) {
        let url =  ServreAPICommone.ServreCommone.businessBaseUrl + HRInfoSubUrl.setHRDetailUrl
        NetworkingTools.shared.postFdEncrayp(url: url, paramter: heartRateDetailDic, encraypType: .AES_128_Business, token: UserDefaults.LoginSuccessUserDefault.Login_Token.storedValue as! String) { (type, respondDic,tipDescript) in
            if type == .success {
                returnBlock(respondDic!,true)
                return
            }
            returnBlock([:],false)
        }

    }

    static func heartRateDetailGetManager(heartRateDetailDic:[String:String],returnBlock:@escaping (_ paramData:[String:Any],_ result:Bool)->()) {
        let url =  ServreAPICommone.ServreCommone.businessBaseUrl + HRInfoSubUrl.getHRDetailUrl
        NetworkingTools.shared.postFdEncrayp(url: url, paramter: heartRateDetailDic, encraypType: .AES_128_Business, token: UserDefaults.LoginSuccessUserDefault.Login_Token.storedValue as! String) { (type, respondDic,tipDescript) in
            if type == .success {
                returnBlock(respondDic!,true)
                return
            }
            returnBlock([:],false)
        }

    }
}
