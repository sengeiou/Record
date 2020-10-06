//
//  FDFileManager.swift
//  Orangetheory
//
//  Created by WANG DONG on 2018/7/31.
//  Copyright © 2018年 WANG DONG. All rights reserved.
//

import Foundation
import Zip

let DOCUMENT_FILEPATH = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]


public class FDFileManager:NSObject{
    
    static let fileManager = FileManager.default
    
    /// 创建文件夹
    ///
    /// - Parameters:
    ///   - name: 文件夹的名称
    ///   - fileBaseUrl: 文件夹的路径
    ///   - isDirectory: 是否为文件夹
    static func createFile(name:String,fileBaseUrl:NSURL,isDirectory:Bool){
        //        let manager = FileManager.default
        
        let file = fileBaseUrl.appendingPathComponent(name, isDirectory: isDirectory)
        print("文件: \(file?.path ?? "")")
        let exist = fileManager.fileExists(atPath: (file?.path)!)
        if !exist {
            if isDirectory {
                do {
                    try fileManager.createDirectory(atPath: (file?.path)!, withIntermediateDirectories: true, attributes: nil)
                } catch {

                }
            }else {
                let createSuccess = fileManager.createFile(atPath: (file?.path)!, contents: Data.init(), attributes: nil)
                print("文件创建结果: \(createSuccess)")
            }

        }
    }
    
    
    /// Copy指定的文件到文件夹
    ///
    /// - Parameters:
    ///   - file: 需要Copy的文件
    ///   - fileName: 指定的文件夹
    static func fileCopyFileToPath(file:String,fileName:String) {
        
        let srcUrl = DOCUMENT_FILEPATH + "/" + file
        let toUrl = DOCUMENT_FILEPATH + "/" + fileName + "/" + file
        
        if fileManager.fileExists(atPath: toUrl) {
            try! fileManager.removeItem(atPath: toUrl)
            try! fileManager.copyItem(atPath: srcUrl, toPath: toUrl)
        }


    }
    
    
    /// 获取Document文件下指定后缀的文件
    ///
    /// - Parameters:
    ///   - fileType: 文件的后缀名
    ///   - specialPath: 指定的文件夹
    /// - Returns: 返回对应后缀的文件路径
    static func fileGetDocumentAllFileType(fileType:String,specialPath:String?) -> [String] {
        
        var documentPath:String = DOCUMENT_FILEPATH
        if specialPath != nil {
            documentPath.append("/\(specialPath!)")
        }
        
        let tempArray:[String] = try! fileManager.contentsOfDirectory(atPath: documentPath)
        let resultArray = tempArray.filter { return $0.hasSuffix(fileType) }
        
        return resultArray
    }
    
    
    
    /// 删除指定名称的文件
    ///
    /// - Parameter filePath: 指定名称的文件
    static func deleteDucomentFile(filePath:String?){

        var documentPath:String = DOCUMENT_FILEPATH
        if filePath != nil {
            documentPath.append("/\(filePath!)")
        }
        
        let fileExit:Bool = fileManager.fileExists(atPath: documentPath)
        
        if fileExit == true {
            try? fileManager.removeItem(atPath: documentPath)
        }else{
            FDLog("File not exit")
        }
    }
    
    
    /// 删除指定后缀的文件
    ///
    /// - Parameter specialSuffix: 指定的后缀名
    static func deleteDucomentSpecialSuffix(specialSuffix:String){
        
        let documentPath:String = DOCUMENT_FILEPATH

        let tempArray:[String] = try! fileManager.contentsOfDirectory(atPath: documentPath)
        let preArray = tempArray.filter { $0.hasSuffix(specialSuffix) }
        
        preArray.forEach { (subPath) in
            deleteDucomentFile(filePath: subPath)
        }
        
        print(preArray)
    }
    
    //判断已经下载的文件是否存在，若存在则不再下载，并删除其他的文件，防止APP包过大
    static func judgeBandFileIsExists(saveFilepath:String,fileName:String) -> Bool {
        
        let fileManager = FileManager.default
        
        let tempArray:[String] = try! fileManager.contentsOfDirectory(atPath: saveFilepath)
        if tempArray.contains(fileName) {
            tempArray.forEach { (value) in
                if value != fileName && value.hasSuffix(".zip") {
                    let path = saveFilepath + "/" + value
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
    

    /// 压缩Log文件
    ///
    /// - Parameters:
    ///   - fileSuffix: 文件后缀名称
    ///   - fileName: 文件名
    static public func zipCollectDataToZip(fileSuffix:String?,fileName:String) {
        
        if fileSuffix != nil {
            let fileArray = FDFileManager.fileGetDocumentAllFileType(fileType: fileSuffix!, specialPath: nil)
            
            fileArray.forEach { (file) in
                
                FDFileManager.fileCopyFileToPath(file: file, fileName: fileName)
            }
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHH:mm"
        
        let  url:URL = URL(fileURLWithPath: "\(DOCUMENT_FILEPATH)/\(fileName)")

        let zipFileSize = "\(DOCUMENT_FILEPATH)/\(fileName)".getFileSize()

        if zipFileSize > 0 {

            let zipName:String = url.lastPathComponent.components(separatedBy: ".")[0]+formatter.string(from: Date())
            let zipUrl = try? Zip.quickZipFiles([url], fileName: zipName)
            print(zipUrl)
        }

        
    }
    
}
extension FDFileManager {

    static func dataBaseIsExists() ->Bool {

        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        let name = CurrentUserID + ".sqlite"
        if let pathComponent = url.appendingPathComponent(name) {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {

                return true

            } else {
                return false
            }
        } else {
            return false
        }
    }
}
