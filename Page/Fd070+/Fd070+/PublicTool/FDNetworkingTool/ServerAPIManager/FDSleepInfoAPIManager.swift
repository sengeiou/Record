//
//  FDSleepInfoAPIManager.swift
//  FD070+
//
//  Created by HaiQuan on 2019/3/22.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import Foundation

struct sleepInfoSubUrl {
    static let getSleepSummaryUrl = "/sleep/get_summary/"
    static let setSleepSummaryUrl = "/sleep/set_summary/"
    static let getSleepDetailUrl = "/sleep/get_detail/"
    static let getSleepChunklUrl = "/sleep/get_detail_new/"
    static let setSleepDetailUrl = "/sleep/set_detail/"
    static let setSleepChunklUrl = "/sleep/set_detail_new/"
}

struct FDSleepInfoAPIManager {


    static func sleepDetailSetManager(sleepDetailDic:[String:String],returnBlock:@escaping (_ paramData:[String:Any],_ result:Bool)->()) {
        let url = ServreAPICommone.ServreCommone.businessBaseUrl + sleepInfoSubUrl.setSleepDetailUrl
        NetworkingTools.shared.postFdEncrayp(url: url, paramter: sleepDetailDic, encraypType: .AES_128_Business, token: UserDefaults.LoginSuccessUserDefault.Login_Token.storedValue as! String) { (type, respondDic,tipDescript) in
            if type == .success {
                returnBlock(respondDic!,true)
                return
            }
            returnBlock([:],false)
        }

    }

    static func sleepChunkSetManager(sleepDetailDic:[String:String],returnBlock:@escaping (_ paramData:[String:Any],_ result:Bool)->()) {
        let url = ServreAPICommone.ServreCommone.businessBaseUrl + sleepInfoSubUrl.setSleepChunklUrl
        NetworkingTools.shared.postFdEncrayp(url: url, paramter: sleepDetailDic, encraypType: .AES_128_Business, token: UserDefaults.LoginSuccessUserDefault.Login_Token.storedValue as! String) { (type, respondDic,tipDescript) in
            if type == .success {
                returnBlock(respondDic!,true)
                return
            }
            returnBlock([:],false)
        }

    }

    static func sleepDetailGetManager(sleepDetailDic:[String:String],returnBlock:@escaping (_ paramData:[String:Any],_ result:Bool)->()) {
        let url = ServreAPICommone.ServreCommone.businessBaseUrl + sleepInfoSubUrl.getSleepDetailUrl
        NetworkingTools.shared.postFdEncrayp(url: url, paramter: sleepDetailDic, encraypType: .AES_128_Business, token: UserDefaults.LoginSuccessUserDefault.Login_Token.storedValue as! String) { (type, respondDic,tipDescript) in
            if type == .success {
                returnBlock(respondDic!,true)
                return
            }
            returnBlock([:],false)
        }

    }
    static func sleepChunkGetManager(sleepDetailDic:[String:String],returnBlock:@escaping (_ paramData:[String:Any],_ result:Bool)->()) {
        let url = ServreAPICommone.ServreCommone.businessBaseUrl + sleepInfoSubUrl.getSleepChunklUrl
        NetworkingTools.shared.postFdEncrayp(url: url, paramter: sleepDetailDic, encraypType: .AES_128_Business, token: UserDefaults.LoginSuccessUserDefault.Login_Token.storedValue as! String) { (type, respondDic,tipDescript) in
            if type == .success {
                returnBlock(respondDic!,true)
                return
            }
            returnBlock([:],false)
        }

    }


    static func sleepSummarySetManager(sleepDetailDic:[String:String],returnBlock:@escaping (_ paramData:[String:Any],_ result:Bool)->()) {
        let url = ServreAPICommone.ServreCommone.businessBaseUrl + sleepInfoSubUrl.setSleepSummaryUrl
        NetworkingTools.shared.postFdEncrayp(url: url, paramter: sleepDetailDic, encraypType: .AES_128_Business, token: UserDefaults.LoginSuccessUserDefault.Login_Token.storedValue as! String) { (type, respondDic,tipDescript) in
            if type == .success {
                returnBlock(respondDic!,true)
                return
            }
            returnBlock([:],false)
        }

    }

    static func sleepSummaryGetManager(sleepDetailDic:[String:String],returnBlock:@escaping (_ paramData:[String:Any],_ result:Bool)->()) {
        let url = ServreAPICommone.ServreCommone.businessBaseUrl + sleepInfoSubUrl.getSleepSummaryUrl
        NetworkingTools.shared.postFdEncrayp(url: url, paramter: sleepDetailDic, encraypType: .AES_128_Business, token: UserDefaults.LoginSuccessUserDefault.Login_Token.storedValue as! String) { (type, respondDic,tipDescript) in
            if type == .success {
                returnBlock(respondDic!,true)
                return
            }
            returnBlock([:],false)
        }

    }
}
