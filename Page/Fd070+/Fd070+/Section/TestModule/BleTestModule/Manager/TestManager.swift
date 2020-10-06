//
//  TestManager.swift
//  Orangetheory
//
//  Created by HaiQuan on 2018/6/11.
//  Copyright © 2018年 WANG DONG. All rights reserved.
//

import UIKit
import FendaBLESwiftLib
import CoreBluetooth

class TestManager: NSObject {

    func testItem(_ item: Int) {

        let singleBtnAction = SingleBtnAction.init(rawValue: item)
        let stressBtnAction = StressBtnAction.init(rawValue: item)

        if singleBtnAction != nil {
            self.singleBtnAction(singleBtnAction!)
        } else if stressBtnAction != nil {

        } else {

        }

    }

    private func singleBtnAction(_ singleBtnAction: SingleBtnAction) {

        switch singleBtnAction {
        case .setPeronalInfo:
            BleDataManager.instance.sendUserInformationToDevice()
        case .getPersonalInfo:
            BleDataManager.instance.sendGetUserInfoFromDevice()
        case .setWorkoutTarget:
            BleDataManager.instance.sendSetWorkoutTargetToDevice()
        case .getWorktoutTarget:
            BleDataManager.instance.sendGetWorkoutTargetFromDevice()
        case .emptyTarget1:
            break
        case .setCurrentTime:
            BleDataManager.instance.sendSetCurrentTime()
        case .getCurrentTime:
            BleDataManager.instance.sendGetCurrentTime()
        case .startOTA:
            BleDataManager.instance.sendStartOTAToDevice()
        case .factoryReset:
            BleDataManager.instance.sendFactoryResetToDevice()
        case .deviceReset:
            BleDataManager.instance.sendDeviceResetToDevice()
        case .openPairWindow:
            BleDataManager.instance.sendOpenPairWindowToDevice { (data) in
                FDLog(data)
            }
        case .continuousHR:
            BleDataManager.instance.sendContinuousHRTestToDevice()
        case .emptyTarget2:
            break
        case .erasureFlash:
            BleDataManager.instance.sendErasureFlashToDevice()
        case .getWorkoutData:
            
            BleDataManager.instance.sendGetWorkoutDataFromDevice()
        case .getDailyData:
            BleDataManager.instance.sendGetDailyDataFromDevice()
        case .emptyTarget3:
            break
        case .startGlucoseCollect:
            BleDataManager.instance.sendStartCollectGlucoseDataToDevice { (receive) in
                print("开始血糖指令返回的数据：\(receive)")
            }
        case .stopGlucoseCollect:
            BleDataManager.instance.sendStopCollectGlucoseDataToDevice { (receive) in
                print("结束血糖指令返回的数据：\(receive)")
            }
        case .resultGlucoseCollect:
            BleDataManager.instance.sendGluResultToBand(value: 2)

        }

    }

}


