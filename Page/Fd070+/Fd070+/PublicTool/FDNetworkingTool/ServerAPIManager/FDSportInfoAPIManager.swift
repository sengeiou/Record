//
//  FDSportInfoAPIManager.swift
//  FD070+
//
//  Created by WANG DONG on 2019/1/2.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import UIKit

struct sportInfoSubUrl {
    static let getSportSummaryUrl = "/sport/get_summary/"
    static let setSportSummaryUrl = "/sport/set_summary/"
    static let getSportDetailUrl = "/sport/get_detail/"
    static let setSportDetailUrl = "/sport/set_detail/"
}

struct FDSportInfoAPIManager {
    
    static func sportDetailSetManager(sportDetailDic:[String:String],returnBlock:@escaping (_ paramData:[String:Any],_ result:Bool)->()) {
        let url = ServreAPICommone.ServreCommone.businessBaseUrl + sportInfoSubUrl.setSportDetailUrl
        NetworkingTools.shared.postFdEncrayp(url: url, paramter: sportDetailDic, encraypType: .AES_128_Business, token: UserDefaults.LoginSuccessUserDefault.Login_Token.storedValue as! String) { (type, respondDic,tipDescript) in
            if type == .success {
                returnBlock(respondDic!,true)
                return
            }
            returnBlock([:],false)
        }

    }

    static func sportDetailGetManager(sportDetailDic:[String:String],returnBlock:@escaping (_ paramData:[String:Any],_ result:Bool)->()) {
        let url = ServreAPICommone.ServreCommone.businessBaseUrl + sportInfoSubUrl.getSportDetailUrl
        NetworkingTools.shared.postFdEncrayp(url: url, paramter: sportDetailDic, encraypType: .AES_128_Business, token: UserDefaults.LoginSuccessUserDefault.Login_Token.storedValue as! String) { (type, respondDic,tipDescript) in
            if type == .success {
                returnBlock(respondDic!,true)
                return
            }
            returnBlock([:],false)
        }

    }

    static func sportSummarySetManager(sportSummaryDic:[String:String],returnBlock:@escaping (_ paramData:[String:Any],_ result:Bool)->()) {
        let url = ServreAPICommone.ServreCommone.businessBaseUrl + sportInfoSubUrl.setSportSummaryUrl
        NetworkingTools.shared.postFdEncrayp(url: url, paramter: sportSummaryDic, encraypType: .AES_128_Business, token: UserDefaults.LoginSuccessUserDefault.Login_Token.storedValue as! String) { (type, respondDic,tipDescript) in
            if type == .success {
                returnBlock(respondDic!,true)
                return
            }
            returnBlock([:],false)
        }

    }

    static func sportSummaryGetManager(sportSummaryDic:[String:String],returnBlock:@escaping (_ paramData:[String:Any],_ result:Bool)->()) {
        let url = ServreAPICommone.ServreCommone.businessBaseUrl + sportInfoSubUrl.getSportSummaryUrl
        NetworkingTools.shared.postFdEncrayp(url: url, paramter: sportSummaryDic, encraypType: .AES_128_Business, token: UserDefaults.LoginSuccessUserDefault.Login_Token.storedValue as! String) { (type, respondDic,tipDescript) in
            if type == .success {
                returnBlock(respondDic!,true)
                return
            }
            returnBlock([:],false)
        }

    }
}


struct mainPageSubUrl {
    static let getRate = "/main/get_rate/"
    static let getIndexData = "/main/index_data/"
    static let getSteps = "/main/steps/"

}

//主页相关
extension FDSportInfoAPIManager {

    static func getHearRateDataLately(paramterDic:[String:String],returnBlock:@escaping (_ paramData:[String:Any],_ result:Bool)->()) {
        let url = ServreAPICommone.ServreCommone.businessBaseUrl + mainPageSubUrl.getRate
        NetworkingTools.shared.postFdEncrayp(url: url, paramter: paramterDic, encraypType: .AES_128_Business, token: UserDefaults.LoginSuccessUserDefault.Login_Token.storedValue as! String) { (type, respondDic,tipDescript) in
            if type == .success {
                returnBlock(respondDic!,true)
                return
            }
            returnBlock([:],false)
        }
    }

    static func getSportAndSleepSummary(paramterDic:[String:String],returnBlock:@escaping (_ paramData:[String:Any],_ result:Bool)->()) {
        let url = ServreAPICommone.ServreCommone.businessBaseUrl + mainPageSubUrl.getIndexData
        NetworkingTools.shared.postFdEncrayp(url: url, paramter: paramterDic, encraypType: .AES_128_Business, token: UserDefaults.LoginSuccessUserDefault.Login_Token.storedValue as! String) { (type, respondDic,tipDescript) in
            if type == .success {
                returnBlock(respondDic!,true)
                return
            }
            returnBlock([:],false)
        }
    }

    static func getSummaryOfSevenDaySteps(paramterDic:[String:String],returnBlock:@escaping (_ paramData:[String:Any],_ result:Bool)->()) {
        let url = ServreAPICommone.ServreCommone.businessBaseUrl + mainPageSubUrl.getSteps
        NetworkingTools.shared.postFdEncrayp(url: url, paramter: paramterDic, encraypType: .AES_128_Business, token: UserDefaults.LoginSuccessUserDefault.Login_Token.storedValue as! String) { (type, respondDic,tipDescript) in
            if type == .success {
                returnBlock(respondDic!,true)
                return
            }
            returnBlock([:],false)
        }
    }
}

