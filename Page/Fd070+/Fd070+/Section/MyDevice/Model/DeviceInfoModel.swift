//
//  DeviceInfoModel.swift
//  FD070+
//
//  Created by WANG DONG on 2018/12/24.
//  Copyright © 2018 WANG DONG. All rights reserved.
//


import Foundation
import SQLite

public enum DeviceInfoType:String {
    
    case Device_FD070Plus = "Device_FD070Plus"
}

/// user Info
struct DeviceInfoModel:Equatable, Encodable {
    var userid = ""
    var bt_mac = ""
    var isupload = ""

    var device_name = ""
    var device_id = ""
    var customary_unit = "" //常用单位:0 英制，1 公制
    var customary_hand = "" //惯用手:0 左手，1 右 手
    var hr_test_switch = ""//连续心率测试:0 关，1 开

    var automatic_sync = "" //全天候:0 关，1 开
    var band_version = ""
    var app_version = ""
    var dial_style = ""

    static func == (lhs: DeviceInfoModel, rhs: DeviceInfoModel) -> Bool {
        return lhs.userid == rhs.userid &&
        lhs.bt_mac == rhs.bt_mac &&
        lhs.isupload == rhs.isupload &&

        lhs.device_name == rhs.device_name &&
        lhs.device_id == rhs.device_id &&
        lhs.customary_unit == rhs.customary_unit &&
        lhs.customary_hand == rhs.customary_hand &&
        lhs.hr_test_switch == rhs.hr_test_switch &&

        lhs.automatic_sync == rhs.automatic_sync &&
        lhs.band_version == rhs.band_version &&
        lhs.app_version == rhs.app_version &&
        lhs.dial_style == rhs.dial_style
    }
}


//Custom UserDefaults Kes
extension UserDefaults {

    enum DeviceInfoUserDefault: String, UserDefaultSettable {
        case Device_SoftVersion
        case Device_FirmVersion
    }
}
