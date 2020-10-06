//
//  NetworkTestModuleViewController.swift
//  FD070+
//
//  Created by WANG DONG on 2018/12/28.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import UIKit

class NetworkTestModuleViewController: BaseViewController {
    
    let logDisplayText = UITextView()
    let testNetworkTableView:UITableView = UITableView()
    var testNetworkTableDataSource = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func initDisplayView() {
        
        self.view.addSubview(logDisplayText)
        
        logDisplayText.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.view).offset(10)
            maker.left.equalTo(self.view).offset(10)
            maker.right.equalTo(self.view).offset(-10)
            maker.height.equalTo(200)
        }
        
        logDisplayText.textColor = UIColor.black
        logDisplayText.backgroundColor = UIColor.gray
        logDisplayText.font = UIFont.systemFont(ofSize: 12)
        
        self.view.addSubview(testNetworkTableView)
        testNetworkTableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        testNetworkTableView.register(UITableViewCell.self, forCellReuseIdentifier: "TestNetworkModulecellId")
        testNetworkTableView.delegate = self
        testNetworkTableView.dataSource = self
        
    }
    
    override func initDisplayData() {
        self.testNetworkTableDataSource = ["获取APP升级信息",
                                           "获取设备的升级信息",

                                           "上传用户信息",
                                           "获取用户信息",

                                           "用户行为统计",
                                           
                                           "设置运动明细",
                                           "获取运动明细",
                                           "设置运动概要",
                                           "获取运动概要",
                                           
                                           "设置睡眠明细",
                                           "睡眠数据片段化上传",
                                           "获取睡眠明细",
                                           "睡眠数据片段化获取",
                                           "设置睡眠概要",
                                           "获取睡眠概要",
                                           
                                           "设置Workout明细",
                                           "获取Workout明细",
                                           "设置Workout概要",
                                           "获取Workout概要",
                                           
                                           "获取最近心率",
                                           "首页运动睡眠汇总",
                                           "7天步数汇总",
                                           
                                           "上传心率数据",
                                           "获取心率数据",
                                           
                                           "上传血糖数据",
                                           "获取血糖数据",
                                           
                                           "设置设备信息",
                                           "获取设备信息",
                                           "设置设备MacAddress",
                                           "获取设备MacAddress",
                                           
                                           "获取资源",
                                           
                                           "动态配置文件"]
    }
    
}

extension NetworkTestModuleViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.testNetworkTableDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestNetworkModulecellId", for: indexPath)
        
        
        cell.textLabel?.text = self.testNetworkTableDataSource[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        //升级相关
        case 0: getAppVersionInfo()
        case 1: getDeviceVersionInfo()

        //用户相关
        case 2: setUserInfor()
        case 3: getUserInfor()

        //用户行为统计
        case 4: FDUserStatisticsAPIManager.getAppActiveData()
            
        //运动接口
        case 5: setSportDetailData()
        case 6: getSportDetailData()
        case 7: setSportSummaryData()
        case 8: getSportSummaryData()
            
        //睡眠接口
        case 9: setSleepDetailData()
        case 10: setSleepChunkData()
        case 11: getSleepDetailData()
        case 12: getSleepChunklData()
        case 13: setSleepSummaryData()
        case 14: getSleepSummaryData()
            
        //Workout接口
        case 15: setWorkoutDetailData()
        case 16: getWorkoutDetailData()
        case 17: setWorkoutSummaryData()
        case 18: getWorkoutSummaryData()
            
        //首页相关接口
        case 19: getHearRateDataLately()
        case 20: getSportAndSleepSummary()
        case 21: getSummaryOfSevenDaySteps()
            
        //心率测试接口
        case 22: uploadHeartRateData()
        case 23: downloadHeartRateData()
            
        //血糖测试接口
        case 24: uploadBloodSugarData()
        case 25: downloadBloodSugarData()
            
        //设备信息相关接口
        case 26: uploadDeviceInformation()
        case 27: downloadDeviceInformation()
        case 28: setDeviceMacAddressInformation()
        case 29: getDeviceMacAddressInformation()
            
        //资源获取接口
        case 30: getResurce()
            
        //动态配置文件
        case 31: dymacinConfigApp()
        default:
            break
        }
    }
    
    
}
//版本相关
extension NetworkTestModuleViewController {
    func getAppVersionInfo() {

        FDUploadTools.checkApplicationInfo { (resultDic, status) in
            print(resultDic)
            print(status)
        }

    }
    func getDeviceVersionInfo() {


        FDUploadTools.checkBleInfoByMac { (resultDic, status) in
            print(resultDic)
            print(status)
        }

    }
}
//用户相关
extension NetworkTestModuleViewController {
    func setUserInfor() {
        let model = UserInfoModel.init(userid: CurrentUserID, bt_mac: CurrentMacAddress, uploadflag: "0", username: "My_username", nickname: "My_nickname", firstname: "ere", lastname: "13", icon: "45", birthday: "666", gender: "453", height: "q34", weight: "6", rate_switch: "764", goal: "543", calculating: "2", mobile: "43", email: "43", language: "1", status: "1")
        UserInfoManager.uploadUserInformation(userModel: model) { (result) in
            print(result)
        }
    }
    func getUserInfor() {
        UserInfoManager.downloadUserInformation(language: "0") { (model, result) in
            print(model)
            print(result)
        }
    }
}

//运动相关
extension NetworkTestModuleViewController {
    
    func setSportDetailData() {
        MydayManager.uploadSportDetailData { (result) in
            FDLog(result)
        }
    }
    
    func getSportDetailData() {
        MydayManager.downloadSportDetailData { (result) in
            FDLog(result)
        }
    }
    
    func setSportSummaryData() {
        MydayManager.uploadSportSummaryData { (result) in
            FDLog(result)
        }
    }
    
    func getSportSummaryData() {
        MydayManager.downloadSportSummaryData { (result) in
            FDLog(result)
        }
    }
}
//睡眠相关
extension NetworkTestModuleViewController {
    func setSleepDetailData() {
        MydayManager.uploadSleepDetailData { (result) in
            switch result {
            case .success():
                break
            case .failure(.notNeedUpload):
                break
            default:
                break
            }
        }
    }
    func setSleepChunkData() {
        let currentDate = FDDateHandleTool.getCurrentDate(dateType: "yyyy-MM-dd")
        MydayManager.uploadSleepChuck(date: currentDate) { (resutl) in
            FDLog(resutl)
        }
    }
    func getSleepDetailData() {
        MydayManager.downloadSleepDetailData { (result) in
            FDLog(result)
        }
    }
    func getSleepChunklData() {
        MydayManager.downloadSleepChunk { (result) in
            FDLog(result)
        }
    }
    
    func setSleepSummaryData() {
        MydayManager.uploadSleepSummaryData { (result) in
            FDLog(result)
        }
    }
    
    func getSleepSummaryData() {
        MydayManager.downloadSleepSummaryData { (result) in
            FDLog(result)
        }
    }
}
//Workout  相关
extension NetworkTestModuleViewController {
    func setWorkoutDetailData() {
        WorkoutManger.uploadWorkoutDetailData { (result) in
            FDLog(result)
        }
    }
    
    func getWorkoutDetailData() {
        WorkoutManger.downloadWorkoutDetailData { (result) in
            FDLog(result)
        }
    }
    
    func setWorkoutSummaryData() {
        WorkoutManger.uploadWorkoutSummaryData { (result) in
            FDLog(result)
        }
    }
    
    func getWorkoutSummaryData() {
        WorkoutManger.downloadWorkoutSummaryData { (result) in
            FDLog(result)
        }
    }
}
//主页相关
extension NetworkTestModuleViewController {
    func getHearRateDataLately() {
        MydayManager.downloadHearRateDataLately { (result) in
            FDLog(result)
        }
    }
    
    func getSportAndSleepSummary() {
        MydayManager.downloadSportAndSleepSummary { (result) in
            FDLog(result)
        }
    }
    
    func getSummaryOfSevenDaySteps() {
        MydayManager.downloadSummaryOfSevenDaySteps { (result) in
            FDLog(result)
        }
    }
}

//心率测试
extension NetworkTestModuleViewController {
    func uploadHeartRateData() {
        HRTestManager.uploadHeartRateData{ (result) in
            FDLog(result)
        }
    }
    
    func downloadHeartRateData() {
        HRTestManager.downloadHeartRateData { (result) in
            FDLog(result)
        }
    }
}

//血糖测试
extension NetworkTestModuleViewController {
    func uploadBloodSugarData() {
        BloodSugarManager.uploadBloodSugarData{ (result) in
            FDLog(result)
        }
    }
    func downloadBloodSugarData() {
        BloodSugarManager.downloadBloodSugarData { (result) in
            FDLog(result)
        }
    }
}
//设备信息
extension NetworkTestModuleViewController {
    func uploadDeviceInformation() {
        var model = DeviceInfoModel()
        model.customary_unit = "1"
        DeviceManager.uploadDeviceInformation(deviceModel: model) { (result) in
            FDLog(result)
        }
    }
    
    func downloadDeviceInformation() {
        DeviceManager.downloadDeviceInformation { (model, result) in
            print(model, result)
        }
    }
    
    func setDeviceMacAddressInformation() {
        DeviceManager.uploadDeviceMacAddressInformation { (result) in
            print(result)
        }
    }
    
    func getDeviceMacAddressInformation() {
        DeviceManager.downloadDeviceMacAddressInformation { (result) in
            print(result)
        }
    }
}

//资源相关
extension NetworkTestModuleViewController {
    
    func getResurce() {
        let paraDic:Dictionary = ["userid":CurrentUserID,
                                  "appid":CurrentAppID,
                                  "type": "1"]
        
        
//        FDResourceInfoAPIManager.resurceInfoGetManager(resurceParameterDic: paraDic) { (returnDic, result) in
//            print(returnDic, result)
//        }


        NetworkDataSyncManager.uploadWorkoutData { (result) in }

    }
    
}

// MARK: - 动态文件配置
extension NetworkTestModuleViewController {
    
    func dymacinConfigApp() {
//        FDDymanicConfigAPIManager.getDymanicConfigFile()

        NetworkDataSyncManager.downloadBigData { (result) in
            print(result)
        }
    }
}

