//
//  MydayManagerNetworkExtension.swift
//  FD070+
//
//  Created by HaiQuan on 2019/1/16.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import Foundation
import SwiftyJSON

extension MydayManager {
    
    static func uploadSportDetailData(complete:@escaping (NetworkoutSyncResult) -> ()) {
        
        let sportUnitMinuteModels = try! DailyDetailDataHelper.findNotUpdateData()
        
        let dataSouce = sportUnitMinuteModels ?? [DailyDetailModel()]
        //        guard let dataSouce = sportUnitMinuteModels else {
        //            return
        //        }
        
        var dataArray = [Dictionary<String, String>]()
        for model in dataSouce {
            
            let dataDict:Dictionary = [
                "type": "0",
                "steps": model.step,
                "calories": model.calorie,
                "kilometres": model.distance,
                "time": model.timeStamp]
            
            dataArray.append(dataDict)
        }
        
        let dataJsonString = FDJsonManager.getJsonStringFromAnyObject(anyObject: dataArray)
        let paraDic:Dictionary = ["userid":CurrentUserID,
                                  "appid":CurrentAppID,
                                  "mac":CurrentMacAddress,
                                  "data": dataJsonString]
        
        FDSportInfoAPIManager.sportDetailSetManager(sportDetailDic: paraDic) { (returnDic, result) in

            if result {
                complete(.success())
            }else {
                complete(.failure(.other))
            }


        }
        
        
    }
    
    static func downloadSportDetailData(complete:@escaping (NetworkoutSyncResult) -> ()) {
        
        
        let paraDic:Dictionary = ["userid":CurrentUserID,
                                  "appid":CurrentAppID]
        
        FDSportInfoAPIManager.sportDetailGetManager(sportDetailDic: paraDic) { (returnDic, result) in
            
            var models = [DailyDetailModel]()
            if result {
                let json = JSON(returnDic)
                let data = json["retstring"]["data"].arrayValue
                for sportDetailData in data {
                    
                    let calories = sportDetailData["calories"].stringValue
                    let kilometres = sportDetailData["kilometres"].stringValue
                    _ = sportDetailData["sportid"].stringValue
                    let steps = sportDetailData["steps"].stringValue
                    let time = sportDetailData["time"].stringValue
                    _ = sportDetailData["type"].stringValue
                    
                    var model = DailyDetailModel()
                    model.calorie = calories
                    model.distance = kilometres
                    model.step = steps
                    model.timeStamp = time
                    models.append(model)
                }
                
                try? DailyDetailDataHelper.insertOrUpdate(items: models, complete: {

                    complete(.success())

                })

            }else {
                //                DispatchQueue.main.async {
                complete(.failure(.other))
                //                }
            }
            
        }
        
    }
    
    static func uploadSportSummaryData(complete:@escaping (NetworkoutSyncResult) -> ()) {
        
        let currentDataModel = try! SportSummaryDataHelper.findNotUpdateData()
        
        let dataSouce = currentDataModel ?? [SportSummaryDataModel()]
        //        guard let dataSouce = currentDataModel else {
        //            return
        //        }
        
        let userModel = try! UserinfoDataHelper.findFirstRow(userID: CurrentUserID)
        
        let queue = DispatchQueue.global()
        let group = DispatchGroup()
        
        for model in dataSouce {
            
            _ = FDDateHandleTool.coverTimeStampToDateStr(timeStampStr: model.date, formatStr: "yyyy-MM-dd")
            let reached = model.steps > userModel.goal ? "1" : "0"
            
            let paraDic:Dictionary = ["userid":CurrentUserID,
                                      "appid":CurrentAppID,
                                      "steps": model.steps,
                                      "calories": model.calories,
                                      "kilometres": "24543",
                                      "sportduration": "34",
                                      "reached": reached,
                                      "date": model.date]
            
            group.enter()
            queue.async(group: group, execute: {
                FDSportInfoAPIManager.sportSummarySetManager(sportSummaryDic: paraDic) { (returnDic, result) in
                    group.leave()
                }
                
            })
            
            group.notify(queue: queue){
                DispatchQueue.main.async {
                    complete(NetworkoutSyncResult.success())
                }
            }
        }
        
    }
    
    static func downloadSportSummaryData(complete: @escaping (NetworkoutSyncResult) -> ()) {
        
        let paraDic:Dictionary = ["userid":CurrentUserID,
                                  "appid":CurrentAppID,
                                  "date": "2019-01-16"]
        
        FDSportInfoAPIManager.sportSummaryGetManager(sportSummaryDic: paraDic) { (returnDic, result) in
            
            
            if result {
                let json = JSON(returnDic)
                let sportSummaryData = json["retstring"].dictionaryValue
                
                let calories = sportSummaryData["calories"]?.stringValue
                _ = sportSummaryData["date"]?.stringValue
                _  = sportSummaryData["kilometres"]?.stringValue
                _  = sportSummaryData["reached"]?.stringValue
                _ = sportSummaryData["sportduration"]?.stringValue
                let steps = sportSummaryData["steps"]?.stringValue
                
                var model = SportSummaryDataModel()
                model.calories = calories ?? "0"
                model.steps = steps ?? "0"
                
                
                try? SportSummaryDataHelper.insertOrUpdate(items: [model], complete: {
                    complete(.success())
                })

            }else {

                complete(.failure(.other))

            }
            
        }
        
    }
    
    static func uploadCurrentData(complete:@escaping (NetworkoutSyncResult) -> ()) {
        
        let currentDataModel = try! CurrentDataHelper.findNotUpdateData()
        
        let dataSouce = currentDataModel ?? [CurrentDataModel()]
        //        guard let dataSouce = currentDataModel else {
        //            return
        //        }
        
        let queue = DispatchQueue.global()
        let group = DispatchGroup()
        
        for model in dataSouce {
            
            let date = FDDateHandleTool.coverTimeStampToDateStr(timeStampStr: model.time, formatStr: "yyyy-MM-dd")
            let reached = model.step > CurrentTargetStep ? "1" : "0"
            let endSleepTime = Double(model.end_sleep_time) ?? 0
            let startSleepTime = Double(model.start_sleep_time) ?? 0
            let sleepDuration = (endSleepTime - startSleepTime).description
            let paraDic:Dictionary = ["userid":CurrentUserID,
                                      "appid":CurrentAppID,
                                      "mac": CurrentMacAddress,
                                      "steps": model.step,
                                      "goal":CurrentTargetStep,
                                      "calories": model.calorie,
                                      "kilometres": model.distance,
                                      "sportduration": sleepDuration,
                                      "reached":reached,
                                      "date": date]
            
            group.enter()
            queue.async(group: group, execute: {
                FDSportInfoAPIManager.sportSummarySetManager(sportSummaryDic: paraDic) { (returnDic, result) in
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
    
    
    static func downloadCurrentData(date: String? = nil, dateEnd: String? = nil, page: String? = nil, pageSize: String? = nil, complete: @escaping (NetworkoutSyncResult) -> ()) {
        
        var paraDic = ["userid":CurrentUserID,
                       "appid":CurrentAppID]
        
        if let dateValue = date {
            paraDic["date"] = dateValue
        }
        
        if let dateEndValue = dateEnd {
            paraDic["date_end"] = dateEndValue
        }
        
        if let pageValue = page {
            paraDic["page"] = pageValue
        }
        
        if let pageSizeValue = pageSize {
            paraDic["pagesize"] = pageSizeValue
        }
        
        FDSportInfoAPIManager.sportSummaryGetManager(sportSummaryDic: paraDic) { (returnDic, result) in
            
            var models = [CurrentDataModel]()
            var flagmodels = [HistroyDataFlagModel]()
            if result {
                let json = JSON(returnDic)
                let dataArray = json["retstring"]["data"].arrayValue
                
                for subJson in dataArray {
                    let date = subJson["date"].stringValue
                    var model = try! CurrentDataHelper.findFirstRow(userID: CurrentUserID, macAddress: CurrentMacAddress, currentDate: date) ?? CurrentDataModel()

                    model.userid = subJson["userid"].stringValue
                    model.bt_mac = subJson["mac"].stringValue

                    model.calorie.filterNetworkString(subJson["calories"].stringValue)
                    model.distance.filterNetworkString(subJson["kilometres"].stringValue)
                    model.step.filterNetworkString(subJson["steps"].stringValue)
                    model.time = FDDateHandleTool.dateStringToTimeStamp(stringTime: date, timeForm: "yyyy-MM-dd")
                    
                    models.append(model)

                    let startOfDayDate = FDDateHandleTool.timestampToDateObject(timestamp: model.time).startOfDay
                    let startOfDayTimestamp = FDDateHandleTool.dateObjectToDateStrin(date: startOfDayDate, timeForm: "yyyy-MM-dd")
                    let flagModel = HistroyDataFlagModel.init(timeStamp: startOfDayTimestamp, userId: model.userid, btMac: model.bt_mac, dataFlag: "1")
                    flagmodels.append(flagModel)
                }
            }else {

                complete(.failure(.other))
                
            }
            
            if models.isEmpty {

                complete(.failure(.other))

            }else {
                //更新数据标识
                try! CurrentDayFlagDataHelper.insertOrUpdate(items: flagmodels, complete: {})

                try? CurrentDataHelper.insertOrUpdate(items: models, complete: {
                    complete(.success())
                })
            }
            
        }
        
    }
    
}


// MARK: - 主页相关
extension MydayManager {
    static func downloadHearRateDataLately(complete: @escaping (NetworkoutSyncResult) -> ()) {
        
        let paraDic:Dictionary = ["userid":CurrentUserID,
                                  "appid":CurrentAppID]
        
        FDSportInfoAPIManager.getHearRateDataLately(paramterDic: paraDic) { (returnDic, result) in
            if result {
                let json = JSON(returnDic)
                let data = json["data"].dictionaryValue
                
                print(data)
            }else {

                complete(.failure(.other))

            }
            
        }
        
    }
    static func downloadSportAndSleepSummary(complete: @escaping (NetworkoutSyncResult) -> ()) {
        
        let paraDic:Dictionary = ["userid":CurrentUserID,
                                  "appid":CurrentAppID,
                                  "date": "2019-03-22"]
        
        FDSportInfoAPIManager.getSportAndSleepSummary(paramterDic: paraDic) { (returnDic, result) in
            if result {
                let json = JSON(returnDic)
                let data = json["data"].dictionaryValue
                
                print(data)
                
            }else {

                complete(.failure(.other))

            }
            
        }
        
    }
    static func downloadSummaryOfSevenDaySteps(complete: @escaping (NetworkoutSyncResult) -> ()) {
        
        let paraDic:Dictionary = ["userid":CurrentUserID,
                                  "appid":CurrentAppID]
        
        FDSportInfoAPIManager.getSummaryOfSevenDaySteps(paramterDic: paraDic) { (returnDic, result) in
            if result {
                let json = JSON(returnDic)
                let data = json["retstring"].dictionaryValue
                print(data)
                
            }else {

                complete(.failure(.other))

            }
        }
        
    }
}


