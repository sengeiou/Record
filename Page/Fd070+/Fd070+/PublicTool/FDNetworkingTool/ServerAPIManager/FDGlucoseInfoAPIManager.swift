//
//  FDGlucoseInfoAPIManager.swift
//  FD070+
//
//  Created by WANG DONG on 2019/1/2.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import UIKit

struct glucoseInfoSubUrl {
    static let getGlucoseDetailUrl = "/glucose/get_detail/"
    static let setGlucoseDetailUrl = "/glucose/set_detail/"
}

struct FDBloodSugarInfoAPIManager {

    static func bloodSugarDetailSetManager(bloodSugarDetailDic:[String:String],returnBlock:@escaping (_ paramData:[String:Any],_ result:Bool)->()) {

        let url = ServreAPICommone.ServreCommone.businessBaseUrl + glucoseInfoSubUrl.setGlucoseDetailUrl
        NetworkingTools.shared.postFdEncrayp(url: url, paramter: bloodSugarDetailDic, encraypType: .AES_128_Business, token: UserDefaults.LoginSuccessUserDefault.Login_Token.storedValue as! String) { (type, respondDic,tipDescript) in
            if type == .success {
                returnBlock(respondDic!,true)
                return
            }
            returnBlock([:],false)
        }

    }

    static func bloodSugarDetailGetManager(bloodSugarDetailDic:[String:String],returnBlock:@escaping (_ paramData:[String:Any],_ result:Bool)->()) {

        let url = ServreAPICommone.ServreCommone.businessBaseUrl + glucoseInfoSubUrl.getGlucoseDetailUrl
        NetworkingTools.shared.postFdEncrayp(url: url, paramter: bloodSugarDetailDic, encraypType: .AES_128_Business, token: UserDefaults.LoginSuccessUserDefault.Login_Token.storedValue as! String) { (type, respondDic,tipDescript) in
            if type == .success {
                returnBlock(respondDic!,true)
                return
            }
            returnBlock([:],false)
        }

    }
}
