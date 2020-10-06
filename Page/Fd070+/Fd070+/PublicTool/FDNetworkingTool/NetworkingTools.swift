//
//  NetworkingTools.swift
//  Orangetheory
//
//  Created by WANG DONG on 2018/6/19.
//  Copyright © 2018年 WANG DONG. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

/// 请求响应状态
/// - success: 响应成功
/// - unusual: 响应异常
/// - failure: 请求错误
enum ResponseStatus: Int {
    case success  = 0
    case unusual  = 1
    case unauthorized = 2
    case tryAgain  = 3
    case failure  = 4
}

/// 网络请求回调闭包 status:响应状态 result:JSON tipString:提示给用户的信息
typealias NetworkFinished = (_ status: ResponseStatus, _ result: Dictionary<String, Any>?, _ tipString: String?) -> ()

class NetworkingTools: NSObject {
    /// 网络工具类单例
    static let shared = NetworkingTools()

}

extension NetworkingTools{

    func postFdEncrayp(url:String, paramter:[String:String],encraypType:EncrytionBubisnessType,token:String, finished: @escaping NetworkFinished) {

        print(paramter)
        //字典转JSON
        let nspParams = FDJsonManager.getJsonStringFromAnyObject(anyObject:paramter)
        let nspParamsAes = FDEncrytionManager.Endcode_AES_BCB(strToEncode:nspParams, type: encraypType)

        var paramskey = ""
        var paramsValue = ""
        switch encraypType {
        case .AES_128_UserHehavior:
            paramskey = "finger_print"

            let nspParamsBehavior = FDEncrytionManager.Endcode_AES_BCB(strToEncode:nspParams, type: encraypType)
            paramsValue = nspParamsBehavior.md5()
        case .AES_128_Upgrade:
            paramskey = "finger_print"

            var nspParamsUpgrade = FDEncrytionManager.Endcode_AES_BCB(strToEncode:nspParams, type: encraypType)
            nspParamsUpgrade.append(md5Salt)
            paramsValue = nspParamsUpgrade.md5()
        default:
            paramskey = "access_token"

            paramsValue = token
        }

        let parameterDic:Dictionary = [paramskey: paramsValue,
                                       "nsp_params":nspParamsAes]

        print("传入的参数：\(parameterDic) \nUrl:\(url)")

        let request = httpPostParamHandle(paramDic: parameterDic, urlStr:url)

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (responseData, response, responseError) in

            guard responseError == nil else {
                print("服务器返回为空")
                finished(.failure, nil, "error")
                return
            }


            if let dict = try? JSONSerialization.jsonObject(with: responseData!, options: .mutableContainers){
                print("服务器返回：\(dict)")
                let json = JSON.init(dict)
                let retcode = json["retcode"].intValue
                if retcode == 10000 {
                    finished(.success, (dict as! [String : Any]), "success")
                }else {
                    finished(.failure, (dict as! [String : Any]), "error")
                }
                return
            }

            finished(.failure, nil, "error")
            return
        }
        task.resume()
    }



    /// Post request
    ///
    /// - Parameters:
    ///   - type: Request type
    ///   - parameters: Request parameters
    ///   - finished: Request finished callback
    func post(url: String, parameters: [String : Any]?, finished: @escaping NetworkFinished) {

        let headers = ["Accept": "application/json",
                       "Accept-Encoding": "gzip"
        ]

        FDLog("\(url)\n\(parameters)")
        //request
        Alamofire.request(url , method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers).responseJSON { (response) in

            //            self.handle(response: response, finished: finished,type)
        }
    }

    func get(url: String, parameters: [String : Any]?, finished: @escaping NetworkFinished) {
        let headers = ["Accept": "application/json",
                       "Accept-Encoding": "gzip"
        ]

        //request
        Alamofire.request(url , method: .get, parameters: parameters, encoding: JSONEncoding.default,headers: headers).responseJSON { (response) in
            self.handle(response: response, finished: finished)
        }
    }


    /// Processing response result
    ///
    /// - Parameters:
    ///   - response: response object
    ///   - finished: finish callback
    ///   - needLoading: load box
    fileprivate func handle(response: DataResponse<Any>, finished: @escaping NetworkFinished) {

        switch response.result {
        case .success(let value):
            let json = JSON(value)
            finished(.success, (value as! Dictionary<String, Any>), json.string)
        case .failure(let error):
            print(error)
            finished(.failure, nil, error.localizedDescription)
        }
    }



    static func uploadFileToServer(urlStr:String,filesArray:Array<String>,parameters:Dictionary<String, String>,resultBlock:@escaping (_ isSucc:Bool,_ result:AnyObject)->()) {


        Alamofire.upload(multipartFormData: { (multipartFormData) in
            parameters.forEach { (key: String, value: String) in
                let intData = value.data(using: String.Encoding.utf8)
                multipartFormData.append(intData!, withName: key)
            }


            filesArray.forEach({ (filePath) in
                let url = URL(fileURLWithPath: filePath)
                multipartFormData.append(url, withName: "file", fileName: url.lastPathComponent, mimeType: "application/x-zip-compressed")

            })
        }, to: urlStr) { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in

                    print(response.result.description)

                    let dic = JSON(response.result.value as Any)

                    print(dic)
                    if dic.dictionaryObject != nil {
                        resultBlock(true,dic.dictionaryObject as AnyObject)
                    }
                    else
                    {
                        resultBlock(false,"Network error" as AnyObject)
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
                resultBlock(false,encodingError as AnyObject)
            }
        }

    }

    /// upload image to server
    ///
    /// - Parameters:
    ///   - urlStr: url string
    ///   - imageDataArray: image data array
    ///   - parameters: parameters
    ///   - resultBlock: result
    static func uploadImageToServer(urlStr:String,imageDataArray:[Data],parameters:[String: String],isUploadLog:Bool,resultBlock:@escaping (_ isSucc:Bool,_ result:AnyObject)->()) {

        if imageDataArray.isEmpty {
            print("imageDataArray.isEmpty")
            resultBlock(false, "imageDataArray.isEmpty" as AnyObject)
            return
        }

        Alamofire.upload(multipartFormData: { (multipartFormData) in
            parameters.forEach { (key: String, value: String) in
                let intData = value.data(using: String.Encoding.utf8)
                multipartFormData.append(intData!, withName: key)
            }

            multipartFormData.append(imageDataArray[0], withName: "file", fileName: "image.png", mimeType: "image/png")

            //            for (index, item) in imageDataArray.enumerated() {
            //                let fileName = "image" + "\(index+1)" + ".png"
            //                //                FDLog(fileName)
            //                //多长图片上传
            //                multipartFormData.append(item, withName: "files[\(index)]", fileName: fileName, mimeType: "image/png")
            //
            //            }

            if isUploadLog == true {


            }
            print("组包数据完成")

        }, to: urlStr) { (encodingResult) in


            print(encodingResult)

            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in


                    print(response.result.description)
                    let newStr = String(data: response.data!, encoding: String.Encoding.utf8)
                    print(newStr ?? "")
                    let dic = JSON(response.result.value as Any)

                    print(dic)
                    if dic.dictionaryObject != nil {
                        resultBlock(true,dic.dictionaryObject as AnyObject)
                    }
                    else
                    {
                        resultBlock(false,"Network error" as AnyObject)
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
                resultBlock(false,encodingError as AnyObject)
            }
        }

    }

    func httpPostParamHandle(paramDic:[String:String],urlStr:String) ->URLRequest {

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
        guard let url:URL = URL(string: urlStr) else {
            return URLRequest.init(url: URL.init(fileURLWithPath: ""))
        }

        var request:URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = data

        return request

    }

}

