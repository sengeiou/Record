//
//  FDResourceInfoAPIManager.swift
//  FD070+
//
//  Created by WANG DONG on 2019/1/2.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import UIKit

struct resourceInfoSubUrl {
    static let getResourceDetailUrl = "/resource/geturl/"
    static let setResourceDetailUrl = "/resource/upload/"
    static let setTestUrl = "/test/"
}

struct FDResourceInfoAPIManager {

    static func resurceInfoSetManager(imagePath:String, returnBlock:@escaping (_ result:Bool, _ paramData:AnyObject)->()) {
        
        let userInfoDic = ["userid":CurrentUserID,
                           "appid":CurrentAppID]
        
        
        var imageDataArray:[Data] = Array()
        
        if let decodedData = try? Data(contentsOf: URL(fileURLWithPath: imagePath)) {
            imageDataArray.append(decodedData)
        }
        
        let nspParams = FDJsonManager.getJsonStringFromAnyObject(anyObject:userInfoDic as NSDictionary)
        
        let nspParamsAes = FDEncrytionManager.Endcode_AES_BCB(strToEncode:nspParams, type: .AES_128_Business)
        //解密操作
        print(FDEncrytionManager.Decryption_AES_BCB(strToEncode: nspParamsAes, type: .AES_128_Business))
        
        let parameterDic:Dictionary = ["access_token": UserDefaults.LoginSuccessUserDefault.Login_Token.storedValue as! String,
                                       "nsp_params":nspParamsAes] as [String : String]
        
        let url = ServreAPICommone.ServreCommone.businessBaseUrl + resourceInfoSubUrl.setResourceDetailUrl
        NetworkingTools.uploadImageToServer(urlStr: url, imageDataArray: imageDataArray, parameters: parameterDic, isUploadLog: true) { (isSuccess, respondDic) in
            returnBlock(isSuccess, respondDic)
        }
        
    }

    static func resurceInfoGetManager(resurceParameterDic:[String:String],returnBlock:@escaping (_ paramData:[String:Any],_ result:Bool)->()) {
        let url = ServreAPICommone.ServreCommone.businessBaseUrl + resourceInfoSubUrl.getResourceDetailUrl
        NetworkingTools.shared.postFdEncrayp(url: url, paramter: resurceParameterDic, encraypType: .AES_128_Business, token: UserDefaults.LoginSuccessUserDefault.Login_Token.storedValue as! String) { (type, respondDic,tipDescript) in
            if type == .success {
                returnBlock(respondDic!,true)
                return
            }
            returnBlock([:],false)
        }

    }
}
