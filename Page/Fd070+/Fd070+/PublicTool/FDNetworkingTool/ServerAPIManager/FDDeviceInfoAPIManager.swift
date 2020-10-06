//
//  FDDeviceInfoAPIManager.swift
//  FD070+
//
//  Created by WANG DONG on 2019/1/2.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import UIKit

struct deviceInfoSubUrl {
    static let getDeviceinfoUrl = "/device/get_deviceinfo/"
    static let setDeviceinfoUrl = "/device/set_deviceinfo/"
    static let getMacUrl = "/device/get_mac/"
    static let setMacUrl = "/device/set_mac/"
}

struct FDDeviceInfoAPIManager {

    static func deviceInfoSetManager(deviceinfoDic:[String:String],returnBlock:@escaping (_ paramData:[String:Any],_ result:Bool)->()) {
        let url = ServreAPICommone.ServreCommone.businessBaseUrl + deviceInfoSubUrl.setDeviceinfoUrl
        NetworkingTools.shared.postFdEncrayp(url: url, paramter: deviceinfoDic, encraypType: .AES_128_Business, token: UserDefaults.LoginSuccessUserDefault.Login_Token.storedValue as! String) { (type, respondDic,tipDescript) in
            if type == .success {
                returnBlock(respondDic!,true)
                return
            }
            returnBlock([:],false)
        }

    }

    static func deviceInfoGetManager(deviceinfoDic:[String:String],returnBlock:@escaping (_ paramData:[String:Any],_ result:Bool)->())  {
        let url = ServreAPICommone.ServreCommone.businessBaseUrl + deviceInfoSubUrl.getDeviceinfoUrl
        NetworkingTools.shared.postFdEncrayp(url: url, paramter: deviceinfoDic, encraypType: .AES_128_Business, token: UserDefaults.LoginSuccessUserDefault.Login_Token.storedValue as! String) { (type, respondDic,tipDescript) in
            if type == .success {
                returnBlock(respondDic!,true)
                return
            }
            returnBlock([:],false)
        }
    }
    
    
    static func deviceInfoSetMacManager(deviceinfoDic:[String:String],returnBlock:@escaping (_ paramData:[String:Any],_ result:Bool)->())  {
        let url = ServreAPICommone.ServreCommone.businessBaseUrl + deviceInfoSubUrl.setMacUrl
        NetworkingTools.shared.postFdEncrayp(url: url, paramter: deviceinfoDic, encraypType: .AES_128_Business, token: UserDefaults.LoginSuccessUserDefault.Login_Token.storedValue as! String) { (type, respondDic,tipDescript) in
            if type == .success {
                returnBlock(respondDic!,true)
                return
            }
            returnBlock([:],false)
        }
    }
    
    static func deviceInfoGetMacManager(deviceinfoDic:[String:String],returnBlock:@escaping (_ paramData:[String:Any],_ result:Bool)->())  {
        let url = ServreAPICommone.ServreCommone.businessBaseUrl + deviceInfoSubUrl.getMacUrl
        NetworkingTools.shared.postFdEncrayp(url: url, paramter: deviceinfoDic, encraypType: .AES_128_Business, token: UserDefaults.LoginSuccessUserDefault.Login_Token.storedValue as! String) { (type, respondDic,tipDescript) in
            if type == .success {
                returnBlock(respondDic!,true)
                return
            }
            returnBlock([:],false)
        }
    }

}
