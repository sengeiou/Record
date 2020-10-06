//
//  Log.swift
//  Orangetheory
//
//  Created by HaiQuan on 2018/5/31.
//  Copyright © 2018年 WANG DONG. All rights reserved.
//


import Foundation

/// Encapsulated log output functions
///
/// - Parameters:
///   - message: print message
///   - file: print file
///   - function: print func
///   - line: print line
func FDLog<T>(_ message:T..., file:String = #file, function:String = #function,
              line:Int = #line) {
    

    DispatchQueue.global().async {

        let fileName = (file as NSString).lastPathComponent

        let consoleStr = "\(fileName):\(line) \(function) | \(message)"

        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let datestr = dformatter.string(from: Date())
        let printStr = "\(datestr) \(consoleStr)"

//        #if DEBUG || BT
        print(printStr)
//        #else
        logw(printStr)
//        #endif
    }
}

func FDLogSpecialFile<T>(_ message:T..., filename:String,file:String = #file, function:String = #function,
              line:Int = #line) {
    
    
    DispatchQueue.global().async {
        
        let fileName = (file as NSString).lastPathComponent
        
        let consoleStr = "\(fileName):\(line) \(function) | \(message)"
        
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let datestr = dformatter.string(from: Date())
        let printStr = "\(datestr) \(consoleStr)"
        
        //        #if DEBUG || BT
        print(printStr)
        //        #else
        logw(printStr)
        
        logSpecialFile(printStr, filename)
        //        #endif
    }
}



///The log class containing all the needed methods
open class Log {

    open var logName = "OrangetheoryLog.txt"


    ///The max number of log file that will be stored. Once this point is reached, the oldest file is deleted.
    open var maxFileCount = 4

    ///The directory in which the log files will be written
    open var directory = Log.defaultDirectory() {
        didSet {
            directory = NSString(string: directory).expandingTildeInPath

            let fileManager = FileManager.default
            if !fileManager.fileExists(atPath: directory) {
                do {
                    try fileManager.createDirectory(atPath: directory, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    print("Couldn't create directory at \(directory)")
                }
            }
        }
    }


    ///Whether or not logging also prints to the console
    open var printToConsole = true

    ///logging singleton
    open class var logger: Log {

        struct Static {
            static let instance: Log = Log()
        }
        return Static.instance
    }
    //the date formatter
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .medium
        return formatter
    }

    ///write content to the current log file.
    open func write(_ text: String,_ filename:String) {

        let dayPath = directory
        let fileManager = FileManager.default

        if !fileManager.fileExists(atPath: dayPath) {
            do{

                try fileManager.createDirectory(atPath: dayPath, withIntermediateDirectories: true, attributes: nil)

            } catch{
                print("creat false")
            }

        }

        let path = dayPath  + "/" + (filename.count>0 ? filename : logName)
        if !fileManager.fileExists(atPath: path) {
            do {
                try "".write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
            } catch _ {
            }
        }
        if let fileHandle = FileHandle(forWritingAtPath: path) {
            let writeText = "\(text)\n"
            fileHandle.seekToEndOfFile()
            fileHandle.write(writeText.data(using: String.Encoding.utf8)!)
            fileHandle.closeFile()
        }
    }
    class func todayDateStr() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }


    ///check the size of a file
    func fileSize(_ path: String) -> UInt64 {
        let fileManager = FileManager.default
        let attrs: NSDictionary? = try? fileManager.attributesOfItem(atPath: path) as NSDictionary
        if let dict = attrs {
            return dict.fileSize()
        }
        return 0
    }

    ///get the default log directory
    class func defaultDirectory() -> String {
        var path = ""
        let fileManager = FileManager.default

        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        path = "\(paths[0])/Logs"

        if(!path.hasSuffix("/")){
            path += "/"
        }
        path += todayDateStr()

        if !fileManager.fileExists(atPath: path) && path != ""  {
            do {
                try fileManager.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
            } catch _ {
            }
        }
        return path
    }

}

///Writes content to the current log file
public func logw(_ text: String) {
    
    Log.logger.write(text, "")
}

///Writes content to the current log file
public func logSpecialFile(_ text: String,_ fileName:String) {
    Log.logger.write(text, fileName)
}

