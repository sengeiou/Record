//
//  MyProfileModel.swift
//  FD070+
//
//  Created by HaiQuan on 2019/3/8.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import Foundation

/// user Info
struct UserInfoModel: Equatable, Encodable {

    var userid = "123"
    var bt_mac = "F0:13:C3:FF:FF:FF"
    var uploadflag  = "0"

    var username = "User name"
    var nickname = "Nick name"
    var firstname = "First nam"
    var lastname = "Last name"
    var icon = ""

    var birthday = "1989-12-31"
    var gender = "1" //0male;1female
    var height = "185"
    var weight = "70"

    var rate_switch = "0"
    var goal = "10000"
    var calculating = "1" //"0" 代表 英制。 "1"代表公制。

    var mobile = "13378404656"
    var email = "abating.xiahaiquan@fenda.com"
    var language = "1"
    var status = "0"

    static func == (lhs: UserInfoModel, rhs: UserInfoModel) -> Bool {
        return lhs.userid == rhs.userid &&
            lhs.bt_mac == rhs.bt_mac &&
            lhs.uploadflag == rhs.uploadflag &&

            lhs.username == rhs.username &&
            lhs.nickname == rhs.nickname &&
            lhs.firstname == rhs.firstname &&
            lhs.lastname == rhs.lastname &&
            lhs.icon == rhs.icon &&

            lhs.birthday == rhs.birthday &&
            lhs.gender == rhs.gender &&
            lhs.height == rhs.height &&
            lhs.weight == rhs.weight &&

            lhs.rate_switch == rhs.rate_switch &&
            lhs.goal == rhs.goal &&
            lhs.calculating == rhs.calculating &&

            lhs.mobile == rhs.mobile &&
            lhs.email == rhs.email &&
            lhs.language == rhs.language &&
            lhs.status == rhs.status
    }
}

//Custom UserDefaults Kes
extension UserDefaults {

    enum ContryInfoKey: String, UserDefaultSettable {
        case country
        case calculating
    }

    enum LocalUserInfoKey: String, UserDefaultSettable {
        case iconPath
    }
}

