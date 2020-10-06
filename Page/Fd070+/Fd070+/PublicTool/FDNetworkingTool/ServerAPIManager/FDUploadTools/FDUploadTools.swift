//
//  FDUploadTools.swift
//  FD070+
//
//  Created by WANG DONG on 2018/12/28.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import UIKit
import CryptoSwift

let md5Salt = "fd070_plus_upgrade"

struct uploadInfoSubUrl {
    static let getAppinfoUrl = "/ios/version"
    static let getSerialnuminfoUrl = "/ios/serialnum"
    static let getBleinfoUrl = "/ble/devmac"
}

class FDUploadTools: NSObject {

    
    static let APPServerVersion = "APPServerVersion"
    static let APPDownloadUrl = "APPDownloadUrl"
    static let uploadCheckTimeInterval = 5*60
    
    //服务器上设备对应的版本号
    static let BleServerVersion = "BleServerVersion"
    //下载的Zip文件
    static let BleOTAPath = "BleOTAPath"
    
    static let OTAFileName = "FirmwarePackage"
    
    //下载文件指定的路径
    static var downloadZipPath:String? = DOCUMENT_FILEPATH + "/" + OTAFileName
    
    
    static func checkApplicationInfo(returnBlock:@escaping (_ paramData:[String:Any],_ result:Bool)->()) {
        
        guard UserDefaults.LoginSuccessUserDefault.Login_Userid.storedValue as? String != nil else {
            
            print("UserId or MAC is nil")
            returnBlock([:],false)
            return
        }

        var type = "1"
        #if RELEASE
        type = "0"
        #endif

        let paraDic:Dictionary = [
            "userid": CurrentUserID,
            "appid": ServreAPICommone.APPInfoCommone.APPID,
            "type": type,
            "devmac": CurrentMacAddress,
            "version": FDJsonManager.getJsonStringFromAnyObject(anyObject: ["ios": CurrentAppVersion,
                                                                            "ble": CurrentBandVersion])
            ]
        
        
        FDUploadTools.getAppVersionInfo(paraDic ) { (returnDic, result) in
            
            returnBlock(returnDic,true)
            print("获取到的APP版本信息:\(returnDic)" )
        }
        
    }
    
    
    static func checkBleInfoByMac(returnBlock:@escaping (_ paramData:[String:Any],_ result:Bool)->()) {
        guard UserDefaults.LoginSuccessUserDefault.Login_Userid.storedValue as? String != nil || BleConnectState.getCurrentConnectMacAdress() != ServreAPICommone.DeviceInfoCommone.DefaultMac else {
            
            print("UserId or MAC is nil")
            returnBlock([:],false)
            return
        }

        
        var type = "1"
        #if RELEASE
        type = "0"
        #endif

        let paraDic:Dictionary = [
            "userid": CurrentUserID,
            "appid": ServreAPICommone.APPInfoCommone.APPID,
            "type": type,
            "devmac": CurrentMacAddress,
            "version": FDJsonManager.getJsonStringFromAnyObject(anyObject: ["ios":CurrentAppVersion,
                                                                            "ble": CurrentBandVersion]),
            "apptype": "1"

        ]
        
        FDUploadTools.getBleVersionInfo(parameter: paraDic ) { (returnDic, result) in
            
            returnBlock(returnDic,true)
            print("获取到的设备版本信息:\(returnDic)" )
        }
    }
    
    //
    
    /// 暂且借用web端的获取盐值的方法
    ///
    /// - Parameter parameter: 需要请求的参数
    private  static func getAppVersionInfo(_ parameter:[String:String],returnBlock:@escaping (_ paramData:[String:Any],_ result:Bool)->()) {
        
        
        if parameter.keys.count <= 0 {
            returnBlock([:],false)
            return
        }
        
        print(parameter)
        let url = ServreAPICommone.ServreCommone.upgradeBaseUrl + uploadInfoSubUrl.getAppinfoUrl
        NetworkingTools.shared.postFdEncrayp(url: url, paramter: parameter, encraypType: .AES_128_Upgrade, token: UserDefaults.LoginSuccessUserDefault.Login_Token.storedValue as! String) { (type, respondDic,tipDescript) in
            if type == .success {
                
                if let result:[String:Any] = respondDic {
                    
                    if (result.keys.contains("retcode")) && (result["retcode"] as! String == "10000")
                    {
                        if let retstArray:[[String:String]] = (result["retstring"] as? [[String : String]]?)!
                        {
                            guard let retDic:[String:String] = retstArray.first else {
                                returnBlock([:],false)
                                return
                            }
                            if retDic.keys.contains("version") && retDic.keys.contains("url") {
                                
                                //目前只需要版本号和升级APP对应的链接
                                returnBlock([APPServerVersion:retDic["version"] as Any,
                                             APPDownloadUrl:retDic["url"] as Any],true)
                                return
                            }
                        }
                    }
                    FDLog("获取APP版本信息返回：：\(result)")
                }
                
                returnBlock([:],false)
                
                return
            }
            returnBlock([:],false)
        }
        
    }
    
    /// 获取设备版本相关信息
    ///
    /// - Parameters:
    ///   - paramter: 传递的参数
    ///   - returnBlock: 服务器返回的Block
    private static func getBleVersionInfo(parameter:[String:String],returnBlock:@escaping (_ paramData:[String:Any],_ result:Bool)->()) {
        
        
        if parameter.keys.count <= 0 {
            returnBlock([:],false)
        }
        
        //creat FirmwarePackage directory
        FDFileManager.createFile(name: OTAFileName, fileBaseUrl: NSURL.init(fileURLWithPath: DOCUMENT_FILEPATH), isDirectory: true)
        
        print(parameter)
        let url = ServreAPICommone.ServreCommone.upgradeBaseUrl + uploadInfoSubUrl.getBleinfoUrl
        NetworkingTools.shared.postFdEncrayp(url: url, paramter: parameter, encraypType: .AES_128_Upgrade, token: UserDefaults.LoginSuccessUserDefault.Login_Token.storedValue as! String) { (type, respondDic,tipDescript) in
            if type == .success {
                
                
                if let result:[String:Any] = respondDic {
                    
                    if (result.keys.contains("retcode")) && (result["retcode"] as! String == "10000") {
                        if let retstArray:[[String:String]] = (result["retstring"] as? [[String : String]]?)! {
                            
                            guard let retDic:[String:String] = retstArray.first else {
                                returnBlock([:],false)
                                return
                            }
                            if let versionServer:String = retDic["version"] {
                                
                                //保存从服务器获取到的新版本号
                                let bleCurrentVersion = CurrentBandVersion

                                if versionServer > bleCurrentVersion {
                                    
                                    if let url = retDic["url"] {
                                        let updateUrlData = url.data(using: String.Encoding.utf8, allowLossyConversion: true)
                                        let updateUrl:[String:String] = try! JSONSerialization.jsonObject(with: updateUrlData!, options: JSONSerialization.ReadingOptions.allowFragments) as! Dictionary
                                        
                                        if let pkg = updateUrl["pkg"] {
                                            let packPath:URL = URL(string: pkg)!
                                            
                                            //判断文件是否存在若存在则不下载，不存在则直接下载
                                            if self.judgeBandFileIsExist(fileName: packPath.lastPathComponent) == false {
                                                
                                                self.downLoadBandFileFromServer(subUrl: packPath.path, version: versionServer, resultBlock: { (result, isDownload) in
                                                    
                                                    if isDownload {
                                                        returnBlock(result,true)
                                                        return
                                                    }
                                                    
                                                    returnBlock([:],false)
                                                    return
                                                })
                                            }
                                            else {
                                                returnBlock([self.BleOTAPath:packPath.lastPathComponent,self.BleServerVersion:versionServer],true)
                                                return
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    FDLog("获取手环版本信息返回：：\(result)")
                }
            }
            
            returnBlock([:],false)
        }
        
    }
    
    
    static func downLoadBandFileFromServer(subUrl:String,version:String,resultBlock:@escaping (_ paramData:[String:Any],_ result:Bool)->()) {
        
        let downUrl = URL(string: ServreAPICommone.ServerSpecify.downloadBleZipMainDomain + subUrl)
        print("DownloadUrl:::\(String(describing: downUrl))")
        let request:URLRequest = URLRequest(url: downUrl!)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.downloadTask(with: request) { (url, response, error) in
            
            if error == nil {
                if let savrPath = self.downloadZipPath {
                    let saveFilepath = savrPath + "/" + (response?.suggestedFilename)!
                    
                    try? FileManager.default.moveItem(atPath: (url?.path)!, toPath: saveFilepath)
                    let pathUrl:URL = URL(string: saveFilepath)!
                    
                    resultBlock(([self.BleOTAPath:pathUrl.lastPathComponent,
                                  self.BleServerVersion:version] as AnyObject) as! [String : Any],true)
                    return
                }
            }
            
            resultBlock(error as! [String : Any],false)
        }
        task.resume()
    }
    
    
    static func httpPostParamHandle(paramDic:[String:Any],urlStr:String) ->URLRequest {
        
        var paraStr = String()
        
        
        paramDic.forEach({ (arg) in
            
            let (key, value) = arg
            paraStr.append("\(key)=\(value)&")
        })
        
        let startSlicingIndex = paraStr.index(paraStr.startIndex, offsetBy: 0)
        let endSlicingIndex = paraStr.index(paraStr.endIndex, offsetBy: -1)
        
        paraStr = String(paraStr[startSlicingIndex..<endSlicingIndex])
        
        print("paramer-------\(paraStr)")
        
        let data:Data = paraStr.data(using: .utf8, allowLossyConversion: true)!
        let url:URL = URL(string: urlStr)!
        var request:URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        
        return request
        
    }
}

extension FDUploadTools {
    
    //判断已经下载的文件是否存在，若存在则不再下载，并删除其他的文件，防止APP包过大
    static func judgeBandFileIsExist(fileName:String) -> Bool {
        
        let fileManager = FileManager.default
        
        let tempArray:[String] = try! fileManager.contentsOfDirectory(atPath: FDUploadTools.downloadZipPath!)
        if tempArray.contains(fileName) {
            tempArray.forEach { (value) in
                if value != fileName && value.hasSuffix(".zip") {
                    let path = FDUploadTools.downloadZipPath! + "/" + value
                    let fileExit:Bool = fileManager.fileExists(atPath: path)
                    
                    if fileExit == true {
                        try! fileManager.removeItem(atPath: path)
                    }else{
                        print("File not exit")
                    }
                }
            }
            return true
        }
        
        return false
    }
    
    
    
    static func compairVersion(oldVersion:String,newVersion:String) -> Bool {
         
        let oldArray = oldVersion.pregReplace(pattern: "V", with: "").components(separatedBy: ".")
        let newArray =  newVersion.pregReplace(pattern: "V", with: "").components(separatedBy: ".")
        
        let  count:Int = [oldArray.count,newArray.count].min()!
        
        for index in 0 ..< count {
            let old:Int = Int(oldArray[index]) ?? 0
            let new:Int = Int(newArray[index]) ?? 0
            
            if old < new {
                return true
            }
        }
        return false
        
    }
}
