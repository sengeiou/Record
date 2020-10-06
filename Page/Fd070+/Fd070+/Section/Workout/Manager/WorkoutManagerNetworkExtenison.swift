//
//  WorkoutManagerNetworkExtenison.swift
//  FD070+
//
//  Created by HaiQuan on 2019/3/22.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import Foundation
import SwiftyJSON

extension WorkoutManger {
    
    static func uploadWorkoutDetailData(complete: @escaping (NetworkoutSyncResult) -> ()) {
        
        if !FDReachability.shared.reachability {
            complete(NetworkoutSyncResult.failure(.networkNotReachability))
            return
        }
        
        let workoutDetailModels = try! WorkoutDetialDataHelper.findNotUpdateData()
        let dataSouce = workoutDetailModels ?? [WorkoutDetailModel()]
        //        guard let dataSouce = workoutDetailModels else {
        //            complete(NetworkoutSyncResult.failure(.notNeedUpload))
        //            return
        //        }
        
        var dataArray = [Dictionary<String, String>]()
        
        for model in dataSouce {
            
            let dataDict:Dictionary = [
                "sportid": model.sportid,
                "workout_type": model.workout_type,
                "time": model.time,
                "hr": model.hr,
                "hr_status": model.hr_status]
            
            dataArray.append(dataDict)
        }
        
        let dataJsonString = FDJsonManager.getJsonStringFromAnyObject(anyObject: dataArray)
        let paraDic:Dictionary = ["userid":CurrentUserID,
                                  "appid":CurrentAppID,
                                  "mac":CurrentMacAddress,
                                  "data": dataJsonString,
                                  "sportid": "354",
                                  "type": "1",
                                  "steps":"234295",
                                  "calories": "3435",
                                  "kilometres": "3455",
                                  "time": Int(Date().timeIntervalSince1970).description]
        
        FDWorkoutInfoAPIManager.workoutDetailSetManager(workoutDetailDic: paraDic) { (returnDic, result) in
            DispatchQueue.main.async {
                if result {
                    complete(NetworkoutSyncResult.success())
                }else {
                    complete(NetworkoutSyncResult.failure(.other))
                }
            }
        }
        
        
    }
    
    static func downloadWorkoutDetailData(complete: @escaping (NetworkoutSyncResult) -> ()) {
        
        
        if !FDReachability.shared.reachability {
            complete(NetworkoutSyncResult.failure(.networkNotReachability))
            return
        }
        
        let paraDic:Dictionary = ["userid":CurrentUserID,
                                  "appid":CurrentAppID,
                                  "mac":CurrentMacAddress]
        
        FDWorkoutInfoAPIManager.workoutDetailGetManager(workoutDetailDic: paraDic) { (returnDic, result) in
            
            var models = [WorkoutDetailModel]()
            if result {
                let json = JSON(returnDic)
                let data = json["retstring"]["data"].arrayValue
                for workoutDetailData in data {
                    var model = WorkoutDetailModel()
                    model.workout_type.filterNetworkString(workoutDetailData["type"].stringValue)
                    model.step.filterNetworkString(workoutDetailData["steps"].stringValue)
                    model.calorie.filterNetworkString(workoutDetailData["calories"].stringValue)
                    model.distance.filterNetworkString(workoutDetailData["kilometres"].stringValue)
                    
                    models.append(model)
                }
                do {
                    try WorkoutDetialDataHelper.insertOrUpdate(items: models, complete: {
//                        DispatchQueue.main.async {
                            complete(NetworkoutSyncResult.success())
//                        }
                    })
                }catch {
//                    DispatchQueue.main.async {
                        complete(NetworkoutSyncResult.failure(.dataBaseError))
//                    }
                }
                
                
            }else {
//                DispatchQueue.main.async {
                    complete(NetworkoutSyncResult.failure(.other))
//                }
            }
            
        }
        
    }
    
    static func uploadWorkoutSummaryData(complete: @escaping (NetworkoutSyncResult) -> ()) {
        
        
        if !FDReachability.shared.reachability {
            complete(NetworkoutSyncResult.failure(.networkNotReachability))
            return
        }
        
        let workoutSummaryModels = try! WorkoutSummaryDataHelper.findNotUpdateData()
        
        let dataSouce = workoutSummaryModels ?? [WorkoutSummaryModel()]
        //        guard let dataSouce = sleepSummaryDataModels else {
        //            complete(NetworkoutSyncResult.failure(.notNeedUpload))
        //            return
        //        }
        
        let queue = DispatchQueue.global()
        let group = DispatchGroup()
        for model in dataSouce {
            let paraDic:Dictionary = ["userid":CurrentUserID,
                                      "appid":CurrentAppID,
                                      "mac": CurrentMacAddress,
                                      "sportid": "4",
                                      "steps": "12",
                                      "goal": "67",
                                      "goal_type": "7443",
                                      "rate": "4",
                                      "calories": "866",
                                      "kilometres":"334",
                                      "sportduration": "654",
                                      "date": "2019-03-25"]
            
            
            group.enter()
            queue.async(group: group, execute: {
                FDWorkoutInfoAPIManager.workoutSummarySetManager(workoutDetailDic: paraDic) { (returnDic, result) in
                    group.leave()
                }
                
            })
        }
        
        group.notify(queue: queue){
            DispatchQueue.main.async {
                complete(NetworkoutSyncResult.success())
            }
        }
        
    }
    
    static func downloadWorkoutSummaryData(complete: @escaping (NetworkoutSyncResult) -> ()) {
        
        
        if !FDReachability.shared.reachability {
            complete(NetworkoutSyncResult.failure(.networkNotReachability))
            return
        }
        
        let paraDic:Dictionary = ["userid":CurrentUserID,
                                  "appid":CurrentAppID,
                                  "mac": CurrentMacAddress]
        
        FDWorkoutInfoAPIManager.workoutSummaryGetManager(workoutDetailDic: paraDic) { (returnDic, result) in
            
            let models = [WorkoutSummaryModel]()
            if result {
                let json = JSON(returnDic)
                
                var model = WorkoutSummaryModel()
                model.date.filterNetworkString(json["date"].stringValue)
                model.steps.filterNetworkString(json["steps"].stringValue)
                model.calories.filterNetworkString(json["calories"].stringValue)
                
                
                do {
                    try WorkoutSummaryDataHelper.insertOrUpdate(items: models, complete: {
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
