//
//  DataModel.swift
//  Orangetheory
//
//  Created by HaiQuan on 2018/5/31.
//  Copyright © 2018年 WANG DONG. All rights reserved.
//

import Foundation
import SQLite

/// Table name enum.
///
/// - userinfo: Userinfo 
enum TableNameEnum: String {

    case userinfo
    case device_display_setting

    case current
    case daily_detail

    case sport_summary

    case sleep_detail
    case sleep_summary

    case workout_detail
    case workout_summary
    case workout_target

    case bloodsugar_result
    case heartRate_test

    case device_connect_list
    case device_info
    case hitory_data_flag

}

