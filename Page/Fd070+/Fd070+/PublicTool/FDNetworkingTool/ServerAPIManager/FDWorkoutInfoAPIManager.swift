//
//  FDWorkoutInfoAPIManager.swift
//  FD070+
//
//  Created by HaiQuan on 2019/3/22.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import Foundation

struct workoutInfoSubUrl {
    static let setWorkoutDetailUrl = "/sport/set_workout/"
    static let getWorkoutDetailUrl = "/sport/get_workout/"
    static let setWorkoutSummaryUrl = "/sport/set_sportlist/"
    static let getWorkoutSummaryUrl = "/sport/get_sportlist/"
}

struct FDWorkoutInfoAPIManager {

    static func workoutDetailSetManager(workoutDetailDic:[String:String],returnBlock:@escaping (_ paramData:[String:Any],_ result:Bool)->()) {
        let url = ServreAPICommone.ServreCommone.businessBaseUrl + workoutInfoSubUrl.setWorkoutDetailUrl
        NetworkingTools.shared.postFdEncrayp(url: url, paramter: workoutDetailDic, encraypType: .AES_128_Business, token: UserDefaults.LoginSuccessUserDefault.Login_Token.storedValue as! String) { (type, respondDic,tipDescript) in
            if type == .success {
                returnBlock(respondDic!,true)
                return
            }
            returnBlock([:],false)
        }

    }

    static func workoutDetailGetManager(workoutDetailDic:[String:String],returnBlock:@escaping (_ paramData:[String:Any],_ result:Bool)->()) {
        let url = ServreAPICommone.ServreCommone.businessBaseUrl + workoutInfoSubUrl.getWorkoutDetailUrl
        NetworkingTools.shared.postFdEncrayp(url: url, paramter: workoutDetailDic, encraypType: .AES_128_Business, token: UserDefaults.LoginSuccessUserDefault.Login_Token.storedValue as! String) { (type, respondDic,tipDescript) in
            if type == .success {
                returnBlock(respondDic!,true)
                return
            }
            returnBlock([:],false)
        }

    }

    static func workoutSummarySetManager(workoutDetailDic:[String:String],returnBlock:@escaping (_ paramData:[String:Any],_ result:Bool)->()) {
        let url = ServreAPICommone.ServreCommone.businessBaseUrl + workoutInfoSubUrl.setWorkoutSummaryUrl
        NetworkingTools.shared.postFdEncrayp(url: url, paramter: workoutDetailDic, encraypType: .AES_128_Business, token: UserDefaults.LoginSuccessUserDefault.Login_Token.storedValue as! String) { (type, respondDic,tipDescript) in
            if type == .success {
                returnBlock(respondDic!,true)
                return
            }
            returnBlock([:],false)
        }

    }

    static func workoutSummaryGetManager(workoutDetailDic:[String:String],returnBlock:@escaping (_ paramData:[String:Any],_ result:Bool)->()) {
        let url = ServreAPICommone.ServreCommone.businessBaseUrl + workoutInfoSubUrl.getWorkoutSummaryUrl
        NetworkingTools.shared.postFdEncrayp(url: url, paramter: workoutDetailDic, encraypType: .AES_128_Business, token: UserDefaults.LoginSuccessUserDefault.Login_Token.storedValue as! String) { (type, respondDic,tipDescript) in
            if type == .success {
                returnBlock(respondDic!,true)
                return
            }
            returnBlock([:],false)
        }

    }
}
