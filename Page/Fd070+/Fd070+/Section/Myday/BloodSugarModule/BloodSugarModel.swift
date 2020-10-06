//
//  BloodSugarModel.swift
//  FD070+
//
//  Created by HaiQuan on 2019/3/20.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import Foundation

//血糖测试完后，血糖的测试结果
struct BloodSugarResultModel: Encodable {
    var userid = ""
    var bt_mac = ""
    var isupload  = ""

    var start_time = ""
    var boolsugar = ""
}

//测试血糖时，蓝牙返回的测试详情数据
/// Glucose Collect Model
struct GlucoseCollectModel: Encodable {

    var timeStamp = ""
    var userId = ""
    var btMac = ""

    var greenLightSignal = ""
    var redLightSignal = ""
    var IRLightSignal = ""

    var accRatiionXAxis = ""
    var accRatiionYAxis = ""
    var accRatiionZAxis = ""

    var greenLightCurrent = ""
    var redLightCurrent = ""
    var IRLightCurrent = ""
    var packageNumber = ""
    var packageTheTailToIdentify: String = ""

}
