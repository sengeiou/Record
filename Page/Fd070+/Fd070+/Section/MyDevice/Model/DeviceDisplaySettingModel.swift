//
//  DeviceDisplaySettingModel.swift
//  FD070+
//
//  Created by HaiQuan on 2019/3/18.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import Foundation

/// 设备的设置Model
struct DeviceDisplaySetting: Encodable {

    var userid = ""
    var bt_mac = ""
    var uploadflag  = ""

    var time_format = ""
    var date_format = ""
    var watch_face = ""
    var unit = ""
    var language = ""

    var sleep_notify_switch = ""
    var sleep_starttime = ""
    var sleep_endtime = ""
   
}

