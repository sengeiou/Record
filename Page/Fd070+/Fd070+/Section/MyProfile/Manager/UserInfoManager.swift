//
//  UserInfoManager.swift
//  FD070+
//
//  Created by Payne on 2018/12/18.
//  Copyright © 2018年 WANG DONG. All rights reserved.
//

import UIKit
import SwiftyJSON

class UserInfoManager: NSObject {
    
    func getScaleDataSource(_ range: ClosedRange<Int>)->[String] {
        var dataSource = [String]()
        for i in range {
            dataSource.append(i.description)
        }
        return dataSource
    }
    
    func getBirthDaystr(birthDay:String) ->String {
        var resultString = ""
        if FDLanguageChangeTool.shared.currentLanguage != .zhHans  {
            
            resultString = self.getBirthDay(birthDay: birthDay)
        }else {
            
            resultString = self.getBirthdayWithCalculating(birthDay: birthDay)
        }
        
        return resultString
    }
    
    private  func getBirthDay(birthDay:String) -> String{
        let array : Array = String(format: "%@",birthDay).components(separatedBy: "-")
        
        var monthStr = String()
        if array.count > 0 {
            
            if array[0] == "01"{
                monthStr = "January"
            }else if array[0] == "02"{
                monthStr = "February"
            }else if array[0] == "03"{
                monthStr = "March"
            }else if array[0] == "04"{
                monthStr = "April"
            }else if array[0] == "05"{
                monthStr = "May"
            }else if array[0] == "06"{
                monthStr = "June"
            }else if array[0] == "07"{
                monthStr = "July"
            }else if array[0] == "08"{
                monthStr = "August"
            }else if array[0] == "09"{
                monthStr = "September"
            }else if array[0] == "10"{
                monthStr = "October"
            }else if array[0] == "11"{
                monthStr = "November"
            }else if array[0] == "12"{
                monthStr = "December"
            }
        }
        //1998-12-31
        let birthDayStr = String(format: "%@.%@.%@",array[safe:2] ?? "", monthStr,array[safe: 0] ?? "")
        return birthDayStr
    }
    
    private  func getBirthdayWithCalculating(birthDay:String) -> String{
        
        //1998-12-31
        let array : Array = String(format: "%@",birthDay).components(separatedBy: "-")
        
        let birthDayStr = String(format: "%@.%@.%@",array[safe:0] ?? "",array[safe:1] ?? "",array[safe: 2] ?? "")
        return birthDayStr
        
    }
    
    
    func getGender(gender:String) -> String {
        
        var genderStr = ""
        
        //0 man 1 female
        if gender == "0" {
            genderStr = "UserInforGenderVC_male".localiz()
        }else {
            genderStr = "UserInforGenderVC_female".localiz()
        }
        return genderStr
    }
    
    func getHeightUnits(userModel:UserInfoModel) -> String {
        let userManager = UserInfoManager()
        //当前是英制
        if userModel.calculating == "0" {
            var heightValue = ""
            //存的是英制
            if userModel.height.contains(".") {
                heightValue = userModel.height
            }else {
                //存的不是英制
                heightValue = userManager.getCMSwitchFootRow(heightValue: userModel.height)
            }
            
            heightValue.insert("'", at:  heightValue.firstIndex(of: ".")!)
            heightValue.insert(contentsOf: "''", at: heightValue.endIndex)
            heightValue.remove(at: heightValue.firstIndex(of: ".")!)
            
            return heightValue
        } else {
            var heightValue = ""
            //当前是英制
            if userModel.height.contains(".") {
                
                heightValue = userManager.getFootSwitchCMRow(heightValue: userModel.height)
            }else {
                //当前不是英制
                heightValue = userModel.height
                
            }
            heightValue += "cm"
            
            return heightValue
        }
    }
    
    func getWeightUnits(userModel:UserInfoModel) -> String {
        
        let userManager = UserInfoManager()
        //当前是英制
        if userModel.calculating == "0" {
            var weightValue = userModel.weight
            //存的是英制
            if userModel.weight.contains(".") {
                
                weightValue.remove(at: weightValue.firstIndex(of: ".")!)
            }else {
                //存的不是英制
                weightValue = userManager.getKGSwitchLBSRow(weightValue: userModel.weight)
            }
            
            weightValue += "LBS"
            
            return weightValue
        } else {
            var weightValue = userModel.weight
            //当前是英制
            if userModel.weight.contains(".") {
                weightValue.remove(at: weightValue.firstIndex(of: ".")!)
                weightValue = userManager.getLBSSwitchKGRow(weightValue: weightValue)
            }else {
                //当前不是英制
                
                
            }
            weightValue += "KG"
            
            return weightValue
        }
        
    }
    
    
    /// get FootRow Or InchRow
    ///
    /// - Parameters:
    ///   - heightValue: heightValue
    ///   - isFootRow: isFootRow
    /// - Returns: inchHeight
    func getFootRowOrInchRow(heightValue:String,isFootRow:Bool) -> Int {
        
        var array : Array = heightValue.components(separatedBy: ".")
        
        if array.count == 1{
            array.append("0")
        }
        if isFootRow {
            return Int(array[safe: 0] ?? "0") ?? 0
        }
        let inchHeight = String(format: "%.f",Double(array[safe: 1] ?? "0") ?? 0)
        
        return Int(inchHeight) ?? 0
    }
    
    
    /// get Foot Switch CM Row //1厘米(cm)=0.0328084英尺(ft) .身高inch英转公制cm
    ///
    /// - Parameter heightValue: heightValue
    /// - Returns: cmValue String
    func getFootSwitchCMRow(heightValue:String) -> String {
        
        var array : Array = heightValue.components(separatedBy: ".")
        if array.count == 1{
            array.append("0")
        }
        let heightInchs = String(format: "%.1f", (Double(array[safe: 1] ?? "0") ?? 0)/12)
        
        let heightFoot =  String(format: "%.1f",Double(array[safe:0] ?? "0") ?? 0 + (Double(heightInchs) ?? 0))
        
        var height = Int(heightFoot) ?? 0 * 30
        if height > 300 {
            height = 300
        }
        if height <= 30 {
            height = 30
        }
        let cmStr = "\(height)"
        
        return cmStr
    }
    
    /// get CM Switch Foot Row。身高cm公制转英制inch
    ///
    /// - Parameter heightValue: heightValue
    /// - Returns: cmValue String
    func getCMSwitchFootRow(heightValue:String) -> String {
        
        var temp = Double(heightValue) ?? 0 / 2.54
        if temp <= 12{
            temp = 12
        }
        let foots = Int(temp / 12)
        let inchs = Int(temp) % 12
        
        let footHeight = String(format: "%d.%d",foots ,inchs)
        
        return footHeight
    }
    
    
    /// get CM Integer Row Or Decimal Row
    ///
    /// - Parameters:
    ///   - heightValue: heightValue
    ///   - isIntegerRow: isIntegerRow
    /// - Returns: heightValue
    func getCMIntegerRowOrDecimalRow(heightValue:String,isIntegerRow:Bool) -> Int {
        
        var array : Array = heightValue.components(separatedBy: ".")
        if array.count == 1{
            array.append("0")
        }
        if isIntegerRow {
            return Int(array[0])!
        }
        return Int(array[1]) ?? 0
        
    }
    
    
    /// get KG Switch LBS Row. 体重。公制KG转磅LB
    ///
    /// - Parameter weightValue: weightValue
    /// - Returns: lbsWeight
    func getKGSwitchLBSRow(weightValue:String) ->String{
        var weight = (Double(weightValue) ?? 0) * 2.2046
        if weight >= 661 {
            weight = 662
        }
        let lbsWeight = String(format: "%.f",weight)
        
        return lbsWeight
    }
    
    
    /// get LBS Switch KG Row。体重。磅LB转磅公制KG
    ///
    /// - Parameter weightValue: weightValue
    /// - Returns: kgWeight
    func getLBSSwitchKGRow(weightValue:String) ->String{
        
        let weight = (Double(weightValue) ?? 0) / 2.2046
        
        let kgWeight = String(format: "%.f",weight)
        
        return kgWeight
    }
    
    
    /// get KG IntegerRow Or DecimalRow
    ///
    /// - Parameters:
    ///   - weightValue: weightValue
    ///   - isIntegerRow: isIntegerRow
    /// - Returns: weightValue
    func getKGIntegerRowOrDecimalRow(weightValue:String,isIntegerRow:Bool) -> Int {
        
        var array : Array = weightValue.components(separatedBy: ".")
        if array.count == 1{
            array.append("0")
        }
        if isIntegerRow {
            return Int(array[0])!
        }
        return Int(array[1]) ?? 0
    }
    
    /// get LBS IntegerRow Or DecimalRow
    ///
    /// - Parameters:
    ///   - weightValue: weightValue
    ///   - isIntegerRow: isIntegerRow
    /// - Returns: weightValue
    func getLBSIntegerRowOrDecimalRow(weightValue:String,isIntegerRow:Bool) -> Int {
        
        var array : Array = weightValue.components(separatedBy: ".")
        if array.count == 1{
            array.append("0")
        }
        if isIntegerRow {
            return Int(array[0]) ?? 0
        }
        return Int(array[1]) ?? 0
    }
    
    
    /// getUserInfo
    ///
    /// - Returns: UserInfoModel()
    static func getUserInfo() -> UserInfoModel {
        //find
        return  try! UserinfoDataHelper.findFirstRow(userID: CurrentUserID)
    }
    
    
    /// updateUserInfo
    ///
    /// - Parameter userInfoModel: userInfoModel
    static func updateUserInfo(_ userInfoModel: UserInfoModel) {
        
        //insert
        do {
            let storeModel = userInfoModel
            
            let _ = try UserinfoDataHelper.update(item:storeModel)
            
        } catch _ {
            FDLog("saveUserInfo error")
        }
    }
}

extension UserInfoManager {
    
    static func coverBirthDayStr(_ birthDayOrigianlStr: String) ->String {
        //1991-12-31
        var birthDayStr = birthDayOrigianlStr
        if FDLanguageChangeTool.shared.currentLanguage != .zhHans {
            let array : Array = String(format: "%@",birthDayOrigianlStr).components(separatedBy: "-")
            birthDayStr = String(format: "%@-%@-%@",array[safe:1] ?? "",array[safe:2] ?? "",array[safe: 0] ?? "")
        }
        return birthDayStr
    }
    static func coverBirthDayStrToStorage(_ usermodel: inout UserInfoModel) ->UserInfoModel {
        //12-31-1991
        var birthDayStr = usermodel.birthday
        if FDLanguageChangeTool.shared.currentLanguage != .zhHans {
            let array : Array = String(format: "%@",usermodel.birthday).components(separatedBy: "-")
            birthDayStr = String(format: "%@-%@-%@",array[safe:2] ?? "",array[safe:0] ?? "",array[safe: 1] ?? "")
        }
        
        usermodel.birthday = birthDayStr
        return usermodel
    }
    static func coverCountryCodeToCountryString(_ countryCode: String) -> String {
        
        if countryCode == "0" {
            return "UserInforCountryVC_china".localiz()
        }
        return "UserInforCountryVC_unitedStates".localiz()
        
    }
    
    static func coverCountryStingToCountryCode(_ countryString: String) -> String {
        
        if countryString == "0" {
            return "UserInforCountryVC_china".localiz()
        }
        return "UserInforCountryVC_unitedStates".localiz()
        
    }
    
}
//Networkout. Get or Set userinfor
extension UserInfoManager {
    
    static func uploadUserInformation(userModel: UserInfoModel? = nil, complete:@escaping (NetworkoutSyncResult) -> Void) {
        
        var model = UserInfoModel()
        if let modelValue = userModel {
            model = modelValue
        }else {
            model = try! UserinfoDataHelper.findFirstRow(userID: CurrentUserID)
        }
        
        if !FDReachability.shared.reachability {
            complete(.failure(.networkNotReachability))
            return
        }
        
        
        let name = model.firstname + model.lastname
        let paraDic:Dictionary = [
            "userid":UserDefaults.LoginSuccessUserDefault.Login_Userid.storedValue as? String ?? "",
            "appid":"23518",
            "firstname":model.firstname,
            "lastname":model.lastname,
            "icon": model.icon,
            "name":name,
            "birthday":model.birthday,
            "weight":model.weight,
            "height":model.height,
            "gender":model.gender.description,
            "goal":model.goal.description,
            "rate_swich":model.rate_switch,
            "calculating":model.calculating.description,
            "country": model.language
        ]
        
        FDUserInfoAPIManager.userInfoSetManager(userinfoDic: paraDic) { (returnDic, result) in
            //That isnot in main thread
            DispatchQueue.main.async {
                if result {
                    complete(.success())
                }else {
                    complete(.failure(.other))
                }
            }
        }
        
    }
    
    static func downloadUserInformation(language:String, complete:@escaping (_ userModel: UserInfoModel, _ result: Bool) -> Void) {
        
        if !FDReachability.shared.reachability {

            let DBModel = try! UserinfoDataHelper.findFirstRow(userID: CurrentUserID)
            complete(DBModel, false)
            return
        }
        
        
        let paraDic:Dictionary = [
            "userid":UserDefaults.LoginSuccessUserDefault.Login_Userid.storedValue as? String ?? "",
            "appid":"23518"
        ]
        
        FDUserInfoAPIManager.userInfoGetManager(userinfoDic: paraDic) { (returnDic, result) in
            
            let json = JSON(returnDic)
            let retstringJson = json["retstring"]
            
            let birthday = retstringJson["birthday"].stringValue.count <= 0 ? "1999-09-09" : retstringJson["birthday"].stringValue
            let calculating = retstringJson["calculating"].stringValue
            let language = retstringJson["country"].stringValue
            let firstname = retstringJson["firstname"].stringValue
            let gender = retstringJson["gender"].stringValue
            let goal = retstringJson["goal"].stringValue
            let height = retstringJson["height"].stringValue
            let icon = retstringJson["icon"].stringValue
            let lastname = retstringJson["lastname"].stringValue
            let rate_swich = retstringJson["rate_swich"].stringValue
            let weight = retstringJson["weight"].stringValue

            var userInfoModel = UserInfoModel()

            //第一次登陆，数据库没生成。
            if FDFileManager.dataBaseIsExists() {
                userInfoModel = try! UserinfoDataHelper.findFirstRow(userID: CurrentUserID)
            }

            userInfoModel.userid = CurrentUserID
            userInfoModel.bt_mac = CurrentMacAddress
            userInfoModel.uploadflag = "1"

            userInfoModel.firstname.filterNetworkString(firstname)
            userInfoModel.lastname.filterNetworkString(lastname)
            userInfoModel.icon.filterNetworkString(icon)
            userInfoModel.birthday.filterNetworkString(birthday)

            userInfoModel.gender.filterNetworkString(gender)
            userInfoModel.height.filterNetworkString(height)
            userInfoModel.weight.filterNetworkString(weight)
            userInfoModel.rate_switch.filterNetworkString(rate_swich)

            userInfoModel.goal.filterNetworkString(goal)
            userInfoModel.calculating.filterNetworkString(calculating)
            userInfoModel.language.filterNetworkString(language)

            //网络数据存到数据库
//            try! UserinfoDataHelper.insertOrUpdate(items: [userInfoModel], complete: { })

//            DispatchQueue.main.async {
                complete(userInfoModel, result)
//            }
        }
        
    }
    
    static func uploadUserIcon(userModel: UserInfoModel, complete:@escaping (_ userModel: UserInfoModel?, _ result: Bool) -> Void) {
        
        if !FDReachability.shared.reachability {
            complete(nil, false)
            return
        }
        
        guard let iconPathStored = UserDefaults.LocalUserInfoKey.iconPath.storedValue as? String else {
            complete(nil, false)
            return
        }
        
        if iconPathStored.isEmpty {
            complete(nil, false)
            return
        }
        
        FDResourceInfoAPIManager.resurceInfoSetManager(imagePath: iconPathStored) { (result, paramData) in
            
            if result {
                let json = JSON(paramData)
                let retstringJson = json["retstring"]
                let iconUrl = retstringJson["url_temp"].stringValue
                
                var userInfoModel = try! UserinfoDataHelper.findFirstRow(userID: CurrentUserID) 
                userInfoModel.icon = iconUrl
                let _ = try? UserinfoDataHelper.update(item: userInfoModel)
                
                //That isnot in main thread
                complete(userInfoModel, result)
            }else {
                complete(nil, false)
            }
        }
    }
    
}
