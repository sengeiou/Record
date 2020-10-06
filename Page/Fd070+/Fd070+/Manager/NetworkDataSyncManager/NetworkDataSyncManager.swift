//
//  NetworkDataSyncManager.swift
//  FD070+
//
//  Created by HaiQuan on 2019/4/8.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import Foundation

/**
 根据 FD070 项目特性和特质，定制 Android APP 数据上传下载同步到云端的策略:
 1. 登录成功后:
 a，首次登录，卸载重装登录，数据库没有数据的这种情况 概要:从云端拉取属于登录用户的所有数据(概要数据以天统计，失败需尝试再次拉取)。 明细:先拉取小部分时间内的数据，一个星期七天内的数据，剩下的数据，UI 操作到那 个时间的数据再拉回，明细数据拉取太慢适当引导(每分钟数据，失败需尝试再次拉取)。 设备列表:登录成功后拉取(失败不再尝试拉取，APP 手动添加新的手环)
 b，退出再登录，数据库里面有数据的情况 概要:数据库最新数据记录时间，拉取该时间到今天为止的数据 明细:原则上拉取数据库最新时间到今天为止的数据，如果时间大于七天则拉取七天， 剩余的，UI 操作时策略拉回。
 //补充： 当天的数据一定会获取，前几天的数据，数据库有该天的，就不网络获取了
 2. 登出 登出需提交数据
 
 3. 同步
 APP 与手环同步数据后，上传当天的概要和明细(按标识上传，上传过的不再上传)(明 细距离上一次同步上传需要间隔半小时策略上传，概要间隔三分钟策略上传)。PS:每当 APP 与设备同步后，需汇总今天明细数据为今天的概要，并且同时，需要查询没汇总的 数据，汇总并上传。
 4. 锻炼 锻炼结束后，上传概要，上传明细(失败在同步策略中再次提交)。
 5. 定时任务(去掉) 定时上传运动睡眠锻炼概要和明细，各表中标识需上传的数据(暂时去掉，由 APP 与手环同步完成后的动作触发)。
 6. APP 前后台切换
 满足三分钟半小时策略情况下，提交数据。
 
 7. 用户信息
 a，原则上登录成功后，需要返回登录用户的信息，这样保证用户信息是完整的。所以登 录成功且用户信息完整才算是登录成功。云端后台支撑，登录成功后并用户信息返回。
 b，用户信息修改项，修改项优先保存保证本地数据库，然后提交到云端，遇修改提交失败，可策略再次提交，可加入三分钟策略扫瞄再次提交，如有再次下拉用户的信息的操 作，那么需考虑本地标识是否有修改未提交，以本地高优先，本地有修改待提交，那么 不能覆盖，以本地为最新数据(因身高体重值跟运动数据等紧密相关，优先考虑用户信 息与手环同步)。
 8. 附:三分钟等时间间隔策略，数值可尝试与云端联动，动态配置。
 */

struct NetworkDataSyncManager {
    
}
// MARK: - Login
extension NetworkDataSyncManager {
    
    static func login() {

        //在获取到用户的MacAddress后才能请求大数据
        let sema = DispatchSemaphore.init(value: 0)
        getMacAddress { (isFinish) in
            sema.signal()
        }
        sema.wait()

        var currentUserModel = UserInfoModel()
        currentUserModel.userid = CurrentUserID
        let exists = try! UserinfoDataHelper.checkColumnExists(item: currentUserModel)


        if exists {
            loginAgain()
        }else {
            loginFirst()
        }
    }
    private static func loginFirst() {
        
        let currentDate = Date()
        for i in 0 ... 6 {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                let aheadDate = currentDate.dateByAddingDays(byAddingDays: -i)?.startOfDay ?? currentDate
                let aheadDayStr = FDDateHandleTool.dateObjectToDateStrin(date: aheadDate, timeForm: "yyyy-MM-dd")
                print("loginFirst.aheadDayStr\(aheadDayStr)")
                MydayManager.downloadCurrentData(date: aheadDayStr) { (result) in
                    print(result)
                }
            }
        }
        
    }
    
    static func loginAgain() {
        
        let currentDataStored = try! CurrentDataHelper.findAllRow(userID: CurrentUserID)
        var dateArr = [String]()
        
        if let currentData = currentDataStored  {
            for currentModel in currentData {
                let date = FDDateHandleTool.coverTimeStampToDateStr(timeStampStr: currentModel.time, formatStr: "yyyy-MM-dd")
                dateArr.append(date)
            }
        }
        
        let currentDate = Date()
        for i in 0 ... 6 {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                let aheadDate = currentDate.dateByAddingDays(byAddingDays: -i)?.startOfDay ?? currentDate
                let aheadDayStr = FDDateHandleTool.dateObjectToDateStrin(date: aheadDate, timeForm: "yyyy-MM-dd")
                print("loginAgain.aheadDayStr\(aheadDayStr)")
                if !dateArr.contains(aheadDayStr) {
                    MydayManager.downloadCurrentData(date: aheadDayStr) { (result) in
                        print(result)
                    }
                }
                
            }
        }
    }
    
    static  func loginOut(complete:@escaping (NetworkoutSyncResult) -> ()) {
        uploadBigData(complete: complete)
    }
}

// MARK: - 前后台切换的数据同步
extension NetworkDataSyncManager {
    
    static func applicationWillEnterForeground() {
        
        let dateStore = UserDefaults.networkDataSync.foregroundAndBackgroundSwitchTimestampKey.storedValue as? Date ?? Date()
        let sceonds = Int(Date().sceondsSince(dateStore))
        //同步时间到了才上传，必须要获取到动态配置的前提下
        if sceonds > FDDymanicConfigInfo.foregroundAndBackgroundSwitchUpdateInterval, !ServreAPICommone.ServreCommone.businessBaseUrl.isEmpty {
            UserDefaults.networkDataSync.foregroundAndBackgroundSwitchTimestampKey.store(value: Date())
            //That is in main thread
            downloadBigData{(resutl) in print(resutl)}

        }

    }
    static func applicationDidEnterBackground() {
        UserDefaults.networkDataSync.foregroundAndBackgroundSwitchTimestampKey.store(value: Date())
    }
    
}

// MARK: - 实时数据刷新数据同步
extension NetworkDataSyncManager {
    
    static func realTimeUploadData() {
        let dateStored = UserDefaults.networkDataSync.realTimeTimestampKey.storedValue
        guard let date = dateStored else {
            UserDefaults.networkDataSync.realTimeTimestampKey.store(value: Date())
            return
        }
        
        let sceonds = Int(Date().sceondsSince(date as! Date))
        if sceonds > FDDymanicConfigInfo.realTimeUpdateInterval {
            UserDefaults.networkDataSync.realTimeTimestampKey.store(value: Date())
            uploadBigData{(resutl) in print(resutl)}
        }
    }
}
// MARK: - Data sync
extension NetworkDataSyncManager {
    
    static func syncMydayData(complete:@escaping (NetworkoutSyncResult) -> ()) {
        
        self.uploadBigData(complete: complete)
        
    }
    
    private static func uploadBigData(complete:@escaping (NetworkoutSyncResult) -> ()) {
        
        let queue = DispatchQueue.global()
        let group = DispatchGroup()
        
        group.enter()  //Update current
        queue.async(group: group, execute: {
            MydayManager.uploadCurrentData(complete: {(result) in
                group.leave()
            })
        })
        
        group.enter()  //Update sport detail data
        queue.async(group: group, execute: {
            MydayManager.uploadSportDetailData(complete: {(result) in
                group.leave()
            })
        })
        
        group.enter()  //Update sleep summary data
        queue.async(group: group, execute: {
            MydayManager.uploadSleepSummaryData(complete: {(result) in
                group.leave()
            })
        })
        
        group.enter()  //Update workout detial data
        queue.async(group: group, execute: {
            WorkoutManger.uploadWorkoutDetailData(complete: {(result) in
                group.leave()
            })
        })
        
        group.enter()   //Update workout summary data
        queue.async(group: group, execute: {
            WorkoutManger.uploadWorkoutSummaryData(complete: {(result) in
                group.leave()
            })
        })
        
        group.notify(queue: queue){
            DispatchQueue.main.async {
                complete(NetworkoutSyncResult.success())
            }
        }
    }
    
    static func downloadBigData(complete:@escaping (NetworkoutSyncResult) -> ()) {
        
        let queue = DispatchQueue.global()
        let group = DispatchGroup()


        group.enter()  //Downlaod current
        queue.async {
            MydayManager.downloadCurrentData(complete: {(result) in
                group.leave()
            })
        }

        group.enter()  //Downlaod sport detail data
        queue.async {
            MydayManager.downloadSportDetailData(complete: {(result) in
                group.leave()
            })
        }

        group.enter()  //Downlaod sleep summary data
        queue.async {
            MydayManager.downloadSleepSummaryData(complete: {(result) in
                group.leave()
            })
        }

        group.enter()  //Downlaod workout detial data
        queue.async{
            WorkoutManger.downloadWorkoutDetailData(complete: {(result) in
                group.leave()
            })
        }

        group.enter()  //Downlaod workout summary data
        queue.async {
            WorkoutManger.downloadWorkoutSummaryData(complete: {(result) in
                group.leave()
            })
        }

        group.notify(queue: queue){
            DispatchQueue.main.async {
                complete(NetworkoutSyncResult.success())
            }
        }
        
    }
}

// MARK: - 运动完上传Workout数据
extension NetworkDataSyncManager {
    static func uploadWorkoutData(complete:@escaping (NetworkoutSyncResult) -> ()) {
        
        let queue = DispatchQueue.global()//定义队列
        let group = DispatchGroup()//创建一个组

        //将队列放进组里
        group.enter()//开始线程1
        queue.async(group: group, execute: {
            //Update sport summary data
            MydayManager.uploadSportSummaryData(complete: {(result) in
                group.leave()//线程1结束
            })
            
        })
        
        //将队列放进组里
        group.enter()//开始线程2
        queue.async(group: group, execute: {
            //Update workout detial data
            WorkoutManger.uploadWorkoutDetailData(complete: {(result) in
                group.leave()//线程1结束
            })
            
        })
        
        group.notify(queue: queue){
            //队列中线程全部结束
            DispatchQueue.main.async {
                complete(NetworkoutSyncResult.success())
            }
        }
        
    }
    
}

// MARK: - User preference setting
extension NetworkDataSyncManager {
    
    private static func getMacAddress(isFinish:@escaping (Bool) -> ()) {

        DeviceManager.downloadDeviceInformation { (model, result) in
            isFinish(true)
        }
    }


}
//Custom UserDefaults Kes
extension UserDefaults {
    enum networkDataSync: String, UserDefaultSettable {
        case foregroundAndBackgroundSwitchTimestampKey
        case realTimeTimestampKey
    }
}
