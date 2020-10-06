//
//  BloodSugarManager.swift
//  FD070+
//
//  Created by HaiQuan on 2019/3/22.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import Foundation
import SwiftyJSON

struct BloodSugarManager {
    static func uploadBloodSugarData(complete: @escaping (NetworkoutSyncResult) -> ()) {
        
        if !FDReachability.shared.reachability {
            complete(NetworkoutSyncResult.failure(.networkNotReachability))
            return
        }
        
        let bloodSugarResultModels = try! BloodSugarTestDataHelp.findNotUpdateData()
        
        let dataSouce = bloodSugarResultModels ?? [BloodSugarResultModel()]
        //        guard let dataSouce = bloodSugarResultModels else {
        //            complete(NetworkoutSyncResult.failure(.notNeedUpload))
        //            return
        //        }
        
        var dataArray = [Dictionary<String, String>]()
        for model in dataSouce {
            
            let dataDict:Dictionary = [
                "level": model.boolsugar,
                "detail": model.boolsugar,
                "time": model.start_time]
            
            dataArray.append(dataDict)
        }
        
        let dataJsonString = FDJsonManager.getJsonStringFromAnyObject(anyObject: dataArray)
        let paraDic:Dictionary = ["userid":CurrentUserID,
                                  "appid":CurrentAppID,
                                  "mac":CurrentMacAddress,
                                  "data": dataJsonString,
                                  "time":Int(Date().timeIntervalSince1970).description]
        
        FDBloodSugarInfoAPIManager.bloodSugarDetailSetManager(bloodSugarDetailDic: paraDic) { (returnDic, result) in
            DispatchQueue.main.async {
                if result {
                    complete(NetworkoutSyncResult.success())
                }else {
                    complete(NetworkoutSyncResult.failure(.other))
                }
            }
        }
        
    }
    
    static func downloadBloodSugarData(complete: @escaping (NetworkoutSyncResult) -> ()) {
        
        
        if !FDReachability.shared.reachability {
            complete(NetworkoutSyncResult.failure(.networkNotReachability))
            return
        }
        
        let paraDic:Dictionary = ["userid":CurrentUserID,
                                  "appid":CurrentAppID]
        
        FDBloodSugarInfoAPIManager.bloodSugarDetailGetManager(bloodSugarDetailDic: paraDic) { (returnDic, result) in
            
            let models = [BloodSugarResultModel]()
            if result {
                let json = JSON(returnDic)
                
                var model = BloodSugarResultModel()
                model.boolsugar = json["data"].stringValue
                model.start_time = json["time"].stringValue
                
                do {
                    try BloodSugarTestDataHelp.insertOrUpdate(items: models, complete: {
                        DispatchQueue.main.async {
                            complete(NetworkoutSyncResult.success())
                        }
                    })
                }catch {
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
