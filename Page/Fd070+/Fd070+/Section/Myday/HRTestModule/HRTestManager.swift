//
//  HRTestManager.swift
//  FD070+
//
//  Created by HaiQuan on 2019/3/22.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import Foundation
import SwiftyJSON

struct HRTestManager {
    static func uploadHeartRateData(complete: @escaping (NetworkoutSyncResult) -> ()) {
        
        if !FDReachability.shared.reachability {
            complete(NetworkoutSyncResult.failure(.networkNotReachability))
            return
        }
        
        
        let HRDetailModels = try! HeartRateTestHelper.findNotUpdateData()
        
        let dataSouce = HRDetailModels ?? [HRDetailModel()]
        //        guard let dataSouce = HRDetailModels else {
        //            return
        //        }
        
        var dataArray = [Dictionary<String, String>]()
        for model in dataSouce {
            
            let dataDict:Dictionary = [
                "level": model.level,
                "detail": model.detail,
                "time": model.time]
            
            dataArray.append(dataDict)
        }
        
        let dataJsonString = FDJsonManager.getJsonStringFromAnyObject(anyObject: dataArray)
        let paraDic:Dictionary = ["userid":CurrentUserID,
                                  "appid":CurrentAppID,
                                  "mac":CurrentMacAddress,
                                  "data": dataJsonString,
                                  "rate": "67",
                                  "time":Int(Date().timeIntervalSince1970).description]
        
        FDHRInfoAPIManager.heartRateDetailSetManager(heartRateDetailDic: paraDic) { (returnDic, result) in
            DispatchQueue.main.async {
                if result {
                    complete(NetworkoutSyncResult.success())
                }else {
                    complete(NetworkoutSyncResult.failure(.other))
                }
            }
        }
        
    }
    
    static func downloadHeartRateData(complete: @escaping (NetworkoutSyncResult) -> ()) {
        
        
        if !FDReachability.shared.reachability {
            complete(NetworkoutSyncResult.failure(.networkNotReachability))
            return
        }
        
        let paraDic:Dictionary = ["userid":CurrentUserID,
                                  "appid":CurrentAppID]
        
        FDHRInfoAPIManager.heartRateDetailGetManager(heartRateDetailDic: paraDic) { (returnDic, result) in
            
            let models = [HRDetailModel]()
            if result {
                let json = JSON(returnDic)
                
                var model = HRDetailModel()
                model.detail = json["data"].stringValue
                model.time = json["time"].stringValue
                
                do {
                    try? HeartRateTestHelper.insertOrUpdate(items: models, complete: {
                        DispatchQueue.main.async {
                            complete(NetworkoutSyncResult.success())
                        }
                    })
                }catch _ {
                    DispatchQueue.main.async {
                        complete(NetworkoutSyncResult.failure(.dataBaseError))
                    }
                }
                
            }else {
                DispatchQueue.main.async {
                    complete(NetworkoutSyncResult.failure(.other))
                }
            }
        }
        
    }
}
