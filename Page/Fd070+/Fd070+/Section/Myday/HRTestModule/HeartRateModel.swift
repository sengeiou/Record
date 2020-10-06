//
//  HeartRateModel.swift
//  FD070+
//
//  Created by HaiQuan on 2019/3/20.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import Foundation

//心率测试的结果Model
struct HRDetailModel: Encodable {
    var userid = ""
    var bt_mac = ""
    var isupload  = ""

    var time = ""
    var rate = ""
    var level = ""
    var detail = ""

}

