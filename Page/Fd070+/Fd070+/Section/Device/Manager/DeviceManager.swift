//
//  DeviceManager.swift
//  FD070+
//
//  Created by HaiQuan on 2019/1/9.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import Foundation
import SwiftyJSON

struct DeviceManager {
    static func checkBleisNeedUpdate(_ isNeedUpdate: @escaping (_ result:Bool)->() ) {

        FDUploadTools.checkBleInfoByMac(returnBlock: { (respondDic, isUpload) in
            DispatchQueue.main.async {
                FDLog(respondDic)
//                isNeedUpdate(true)
//                return
                if isUpload {
                    if let bleVersion = respondDic[FDUploadTools.BleServerVersion] as? String ,let bleCurrentVersion = UserDefaults.DeviceInfoUserDefault.Device_SoftVersion.storedValue as? String {

                        isNeedUpdate(bleVersion > bleCurrentVersion)
                        
                    }
                }else {

                    FDLog("下载蓝牙升级文件失败")
                    isNeedUpdate(false)
                }

            }
        })

    }
}

//Networkout. Get or Set device infor
extension DeviceManager {

    static func uploadNotUpdateDeviceInformation() {
        let deviceInfoModels = try! DeviceInfoDataHelper.findNotUpdateData()
        guard let models = deviceInfoModels else {
            return
        }

        for model in models {
            uploadDeviceInformation(deviceModel: model) { (result) in
                FDLog("update device information\(result)")
            }
        }
    }
    static func uploadDeviceInformation(deviceModel: DeviceInfoModel, complete:@escaping (Bool) -> Void) {

        if !FDReachability.shared.reachability {
            complete(false)
            return
        }

        let deviceInfrDict:Dictionary = [
            "device_name":deviceModel.device_name,
            "device_id":deviceModel.device_id,
            "customary_unit":deviceModel.customary_unit,
            "customary_hand":deviceModel.customary_hand,
            "hr_test_switch":deviceModel.hr_test_switch,

            "automatic_sync":deviceModel.automatic_sync,
            "band_version":deviceModel.band_version,
            "app_version":deviceModel.app_version,
            "dial_style":deviceModel.dial_style

        ]

        let infoString = FDJsonManager.getJsonStringFromAnyObject(anyObject: deviceInfrDict)

        let paraDic:Dictionary = [
            "userid":CurrentUserID,
            "appid":CurrentAppID,
            "mac":CurrentMacAddress,
            "info": infoString
        ]


        FDDeviceInfoAPIManager.deviceInfoSetManager(deviceinfoDic: paraDic) { (returnDic, result) in
            //上传完成更新数据库
            var model = deviceModel
            model.isupload = result.toString()
            try! DeviceInfoDataHelper.insertOrUpdate(items: [model], complete: { })
            DispatchQueue.main.async {
                complete(result)
            }
        }

    }

    static func downloadDeviceInformation(complete:@escaping (_ deviceInfoModel: DeviceInfoModel, _ result: Bool) -> Void) {

        if !FDReachability.shared.reachability {
            let DBModel  = try! DeviceInfoDataHelper.findFirstRow(macAddress: CurrentMacAddress) ?? DeviceInfoModel()
            complete(DBModel,false)
            return
        }


        let paraDic:Dictionary = [
            "appid":CurrentAppID,
            "userid":CurrentUserID,
            "mac":CurrentMacAddress
        ]

        FDDeviceInfoAPIManager.deviceInfoGetManager(deviceinfoDic: paraDic) { (returnDic, result) in

            let json = JSON(returnDic)

            let retstringJson = json["retstring"]


            let macAddress = retstringJson["mac"].stringValue
            let userID = retstringJson["userid"].stringValue

            let infoRawString = retstringJson["info"].rawString() ?? ""
            let infoDict = FDJsonManager.getDictionaryFromJSONString(jsonString: infoRawString)

            var deviceModel = try! DeviceInfoDataHelper.findFirstRow(macAddress: CurrentMacAddress) ?? DeviceInfoModel()

            deviceModel.bt_mac = macAddress
            deviceModel.userid = userID

            if let app_version = infoDict["app_version"] as? String {
                deviceModel.app_version.filterNetworkString(app_version)
            }
            if let automatic_sync = infoDict["automatic_sync"] as? String {
                deviceModel.automatic_sync.filterNetworkString(automatic_sync)
            }
            if let band_version = infoDict["band_version"] as? String {
                deviceModel.band_version.filterNetworkString(band_version)
            }
            if let customary_hand = infoDict["customary_hand"] as? String {
                deviceModel.customary_hand.filterNetworkString(customary_hand)
            }
            if let customary_unit = infoDict["customary_unit"] as? String {
                deviceModel.customary_unit.filterNetworkString(customary_unit)
            }
            if let device_name = infoDict["device_name"] as? String {
                deviceModel.device_name.filterNetworkString(device_name)
            }
            if let device_id = infoDict["device_id"] as? String {
                deviceModel.device_id.filterNetworkString(device_id)
            }
            if let dial_style = infoDict["dial_style"] as? String {
                deviceModel.dial_style.filterNetworkString(dial_style)
            }
            if let hr_test_switch = infoDict["hr_test_switch"] as? String {
                deviceModel.hr_test_switch.filterNetworkString(hr_test_switch)
            }

            let _ = try? DeviceInfoDataHelper.update(item: deviceModel)

            //回调返回的Model
            complete(deviceModel, result)



        }
        
    }


    static func uploadDeviceMacAddressInformation(complete:@escaping (NetworkoutSyncResult) -> Void) {

        let paraDic:Dictionary = [
            "userid":CurrentUserID,
            "appid":CurrentAppID,
            "devmac":CurrentMacAddress,
            "type": "23",
            "sn": "123456789"]

        FDDeviceInfoAPIManager.deviceInfoSetMacManager(deviceinfoDic: paraDic) { (returnDic, result) in
            if result {
                DispatchQueue.main.async {
                    complete(.success())
                }
            }else {
                DispatchQueue.main.async {
                    complete(.failure(.other))
                }
            }

        }

    }

    static func downloadDeviceMacAddressInformation(complete:@escaping (NetworkoutSyncResult) -> Void) {

        let paraDic:Dictionary = [
            "userid":CurrentUserID,
            "appid":CurrentAppID,
            "devmac":"FA:35:79:99:3C:08",
            "flag": "1"]

        FDDeviceInfoAPIManager.deviceInfoGetMacManager(deviceinfoDic: paraDic) { (returnDic, result) in
            if result {
                DispatchQueue.main.async {
                    complete(.success())
                }
            }else {
                DispatchQueue.main.async {
                    complete(.failure(.other))
                }
            }
        }

    }

}
