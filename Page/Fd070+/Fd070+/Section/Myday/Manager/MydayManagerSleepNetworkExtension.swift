//
//  MydaySleepNetwork.swift
//  FD070+
//
//  Created by HaiQuan on 2019/3/22.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import Foundation
import SwiftyJSON

extension MydayManager {

    static func uploadSleepDetailData(complete: @escaping (NetworkoutSyncResult) -> ()) {

        if !FDReachability.shared.reachability {
            complete(NetworkoutSyncResult.failure(.networkNotReachability))
            return
        }

        let sleepDetailDataModels = try! SleepDetailDataHelper.findNotUpdateData()
        guard let dataSouce = sleepDetailDataModels else {
            complete(NetworkoutSyncResult.failure(.notNeedUpload))
            return
        }


        var dataArray = [Dictionary<String, String>]()

        for _ in dataSouce {

            let dataDict:Dictionary = [
                "sleep_time": "10987622",
                "sleep_value": "45122",
                "calorie": "122",
                "hr": "12532",
                "hr_status": "1522",
                "step": "1222",
                "distance": "12332"]

            dataArray.append(dataDict)
        }



        let dataJsonString = FDJsonManager.getJsonStringFromAnyObject(anyObject: dataArray)
        let paraDic:Dictionary = ["userid":CurrentUserID,
                                  "appid":CurrentAppID,
                                  "mac":CurrentMacAddress,
                                  "data": dataJsonString,
                                  "type": "1",
                                  "time": Int(Date().timeIntervalSince1970).description]

        FDSleepInfoAPIManager.sleepDetailSetManager(sleepDetailDic: paraDic) { (returnDic, result) in

                if result {
                    complete(NetworkoutSyncResult.success())
                }else {
                    complete(NetworkoutSyncResult.failure(.other))
                }

        }


    }

    static func uploadSleepChuck(date: String, complete: @escaping (NetworkoutSyncResult) -> ()) {

        if !FDReachability.shared.reachability {
            complete(NetworkoutSyncResult.failure(.networkNotReachability))
            return
        }
        // [String: [[String: String]]]()
        let timestamp = FDDateHandleTool.dateStringToTimeStamp(stringTime: date, timeForm: "yyyy-MM-dd")

        let sleepDetail = coverDBSleepDataToServerReceiveData(timestamp)

        if sleepDetail == nil {
            complete(NetworkoutSyncResult.failure(.notNeedUpload))
            return
        }


        let dataJsonString = FDJsonManager.getJsonStringFromAnyObject(anyObject: sleepDetail ?? "")
        let paraDic:Dictionary = ["userid":CurrentUserID,
                                  "appid":CurrentAppID,
                                  "mac":CurrentMacAddress,
                                  "date":date,
                                  "data": dataJsonString]

        FDSleepInfoAPIManager.sleepChunkSetManager(sleepDetailDic: paraDic) { (returnDic, result) in

                if result {
                    complete(NetworkoutSyncResult.success())
                }else {
                    complete(NetworkoutSyncResult.failure(.other))
                }

        }

    }

    static func downloadSleepDetailData(complete: @escaping (NetworkoutSyncResult) -> ()) {


        if !FDReachability.shared.reachability {
            complete(NetworkoutSyncResult.failure(.networkNotReachability))
            return
        }

        let paraDic:Dictionary = ["userid":CurrentUserID,
                                  "appid":CurrentAppID,
                                  "mac":CurrentMacAddress]

        FDSleepInfoAPIManager.sleepDetailGetManager(sleepDetailDic: paraDic) { (returnDic, result) in

            var models = [SleepDetailDataModel]()
            if result {
                let json = JSON(returnDic)
                let data = json["retstring"]["data"].arrayValue
                for sportDetailData in data {

                    let type = sportDetailData["type"].intValue
                    let time = sportDetailData["time"].intValue
                    let total = sportDetailData["total"].intValue

                    let data = sportDetailData["data"].arrayValue

                    var model = SleepDetailDataModel()
                    model.sleep_time = time.description
                    model.sleep_value = data.description
                    model.hr = type.description
                    model.hr_status = total.description

                    models.append(model)
                }

                do {
                    try SleepDetailDataHelper.insertOrUpdate(items: models, complete: {
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

                    complete(NetworkoutSyncResult.failure(.other))

            }
        }

    }

    static func downloadSleepChunk(complete: @escaping (NetworkoutSyncResult) -> ()) {


        if !FDReachability.shared.reachability {
            complete(NetworkoutSyncResult.failure(.networkNotReachability))
            return
        }

        let paraDic:Dictionary = ["userid":CurrentUserID,
                                  "appid":CurrentAppID,
                                  "mac":CurrentMacAddress]

        FDSleepInfoAPIManager.sleepChunkGetManager(sleepDetailDic: paraDic) { (returnDic, result) in

            if result {
                coverServerSleepDataSaveToDB(returnDic)

            }

                complete(NetworkoutSyncResult.success())
            
        }


    }

    static func uploadSleepSummaryData(complete: @escaping (NetworkoutSyncResult) -> ()) {


        if !FDReachability.shared.reachability {
            complete(NetworkoutSyncResult.failure(.networkNotReachability))
            return
        }

        let sleepSummaryDataModels = try! SleepSummaryDataHelper.findNotUpdateData()

        let dataSouce = sleepSummaryDataModels ?? [SleepSummaryDataModel()]
        //        guard let dataSouce = sleepSummaryDataModels else {
        //            return
        //        }
        let queue = DispatchQueue.global()
        let group = DispatchGroup()
        for model in dataSouce {
            let paraDic:Dictionary = ["userid":CurrentUserID,
                                      "appid":CurrentAppID,
                                      "mac": CurrentMacAddress,
                                      "date": model.date,
                                      "sleeptime": model.start_time,
                                      "deepsleep": model.deep_sleep,
                                      "lightsleep": model.light_sleep,
                                      "awake": model.awake,
                                      "sleepquality": model.sleep_quality,
                                      "reached": model.reached]

            group.enter()
            queue.async(group: group, execute: {
                FDSleepInfoAPIManager.sleepSummarySetManager(sleepDetailDic: paraDic) { (returnDic, result) in
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

    static func downloadSleepSummaryData(complete: @escaping (NetworkoutSyncResult) -> ()) {


        if !FDReachability.shared.reachability {
            complete(NetworkoutSyncResult.failure(.networkNotReachability))
            return
        }

        let paraDic:Dictionary = ["userid":CurrentUserID,
                                  "appid":CurrentAppID,
                                  "mac": CurrentMacAddress]

        FDSleepInfoAPIManager.sleepSummaryGetManager(sleepDetailDic: paraDic) { (returnDic, result) in

            let models = [SleepSummaryDataModel]()
            if result {
                let json = JSON(returnDic)

                _ = json["total"].intValue
                _ = json["data"].arrayValue
                let date = json["date"].stringValue
                let sleeptime = json["sleeptime"].intValue
                let deepsleep = json["deepsleep"].intValue
                let lightsleep = json["lightsleep"].intValue
                let awake = json["awake"].intValue
                let sleepquality = json["sleepquality"].intValue
                let reached = json["reached"].intValue

                var model = SleepSummaryDataModel()
                model.userid = CurrentUserID
                model.bt_mac = CurrentMacAddress
                model.date = date
                model.start_time = sleeptime.description
                model.deep_sleep = deepsleep.description
                model.light_sleep = lightsleep.description
                model.awake = awake.description
                model.sleep_quality = sleepquality.description
                model.reached = reached.description
                do {
                    try SleepSummaryDataHelper.insertOrUpdate(items: models, complete: {
                        complete(NetworkoutSyncResult.success())
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

// MARK: - private func
extension MydayManager {
    private static func coverDBSleepDataToServerReceiveData(_ timestamp: String) -> [String: [[String: Int]]]? {
        let sleepDetailDataItems = try! SleepDetailDataHelper.findNotUpdateData(timestamp)
        guard let items = sleepDetailDataItems else {
            return nil
        }

        var typeDict = [String: [[String: Int]]]()

        var periodDict = [String: Int]()
        //1 light sleep, 2 deep sleep, 3 sober
        var lightSleepArr = [[String: Int]](), deepSleepArr = [[String: Int]](), soberSleepArr = [[String: Int]]()

        var startSleepstamp = Int(items.first?.sleep_time ?? "0") ?? 0
        var nearestSleepType = "0"
        /*
         1. 遍历数组中前count - 1的所有值， 当下一个睡眠类型与前一个不相同时， 添加到对应的睡眠类型数组中，（重要节点是：最后一个必须要添加到对应的数组中）
         2. 数组最后一个值的处理， 该睡眠值与前一个值相同时改变睡眠结束时间戳， 如果不同，生成新字典并添加。
         注意： 开始、结束时间戳的计算"
         */
        for (index, value) in items.enumerated() {

            let sleep_time = Int(value.sleep_time) ?? 0

            if index < items.count - 1 {

                if index == 0 {
                     periodDict["starttimestamp"] = sleep_time
                }

                if (index == items.count - 2) || (value.sleep_value != items[index + 1].sleep_value){

                    periodDict["period"] = ( sleep_time - startSleepstamp) / 60
                    periodDict["endtimestamp"] = sleep_time

                    if value.sleep_value == "1" {
                        lightSleepArr.append(periodDict)
                    }else if value.sleep_value == "2" {
                        deepSleepArr.append(periodDict)
                    }else if value.sleep_value == "3" {
                        soberSleepArr.append(periodDict)
                    }

                    nearestSleepType = value.sleep_value

                    startSleepstamp = sleep_time
                }

            }else {

                if nearestSleepType == value.sleep_value {

                    periodDict["period"] = (periodDict["period"] ?? 0) + 1;
                    periodDict["endtimestamp"] = sleep_time

                }else {

                    periodDict["period"] = 1; periodDict["starttimestamp"] = sleep_time; periodDict["endtimestamp"] = sleep_time

                    if value.sleep_value == "1" {
                        lightSleepArr.append(periodDict)
                    }else if value.sleep_value == "2" {
                        deepSleepArr.append(periodDict)
                    }else if value.sleep_value == "3" {
                        soberSleepArr.append(periodDict)
                    }
                }

            }

            typeDict["101"] = lightSleepArr
            typeDict["102"] = deepSleepArr
            typeDict["103"] = soberSleepArr
        }

        return typeDict
    }


    private static func coverServerSleepDataSaveToDB(_ returnDic: [String:Any]) {

        let json = JSON(returnDic)
        let data = json["retstring"]["redata"].arrayValue

        let userId = json["userId"].stringValue

        for item in data {

            let dict = item.dictionaryValue
            let mac = dict["mac"] ?? ""

            if let dataOptional = dict["data"] {
                do {
                    let arrayOptional = try FDJsonManager.getArrayFromJSONString(jsonString: dataOptional.stringValue)

                    guard let array = arrayOptional else {
                        continue
                    }

                    for dictionType in array {
                        let key = dictionType.key
                        var sleepType = ""
                        if key == "101" {
                            sleepType = "1"
                        }else if key == "102" {
                             sleepType = "2"
                        }else {
                             sleepType = "3"
                        }
                        for diction in dictionType.value {

                            let periodDurating = diction["period"] ?? 0
                            _ = diction["endtimestamp"] ?? 0
                            let starttimestamp = diction["starttimestamp"] ?? 0

                            var models = [SleepDetailDataModel]()

                            for i in 0 ... periodDurating {
                                var model = SleepDetailDataModel()
                                model.isupload = "1"; model.bt_mac = mac.stringValue; model.userid = userId; model.sleep_value = sleepType

                                let sleep_time = starttimestamp + (i * 60)
                                model.sleep_time = sleep_time.description
                                models.append(model)
                            }

                            try! SleepDetailDataHelper.insertOrUpdate(items: models, complete: {
                                print("网络获取的数据片段已插入到数据库中")
                            })

                        }

                    }

                }catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
