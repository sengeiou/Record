//
//  FDStringExtension.swift
//  FD070+
//
//  Created by WANG DONG on 2018/12/23.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import UIKit


extension String {
    
    //返回字数
    var count: Int {
        let string_NS = self as NSString
        return string_NS.length
    }
    
    //使用正则表达式替换
    func pregReplace(pattern: String, with: String,
                     options: NSRegularExpression.Options = []) -> String {
        let regex = try! NSRegularExpression(pattern: pattern, options: options)
        return regex.stringByReplacingMatches(in: self, options: [],
                                              range: NSMakeRange(0, self.count),
                                              withTemplate: with)
    }


    func nsRange(from range: Range<String.Index>) -> NSRange? {
        let utf16view = self.utf16
        if let from = range.lowerBound.samePosition(in: utf16view), let to = range.upperBound.samePosition(in: utf16view) {

            return NSMakeRange(utf16view.distance(from: utf16view.startIndex, to: from), utf16view.distance(from: from, to: to))

        }
        return nil
    }
    
    public subscript(safe range: ClosedRange<Int>) -> String? {
        guard let lowerIndex = index(startIndex, offsetBy: max(0, range.lowerBound), limitedBy: endIndex) else { return nil }
        guard let upperIndex = index(lowerIndex, offsetBy: range.upperBound - range.lowerBound + 1, limitedBy: endIndex) else { return nil }
        return String(self[lowerIndex..<upperIndex])
    }

    func toCGFloat() -> CGFloat {
        guard let doubleValue = Double(self) else {
            return 0
        }

        return CGFloat(doubleValue)
    }
    
    
    /// Get file size
    ///
    /// - Returns: The file size
    func getFileSize() -> UInt64  {
        var size: UInt64 = 0
        let fileManager = FileManager.default
        var isDir: ObjCBool = false
        let isExists = fileManager.fileExists(atPath: self, isDirectory: &isDir)
        // 判断文件存在
        if isExists {
            // 是否为文件夹
            if isDir.boolValue {
                // 迭代器 存放文件夹下的所有文件名
                let enumerator = fileManager.enumerator(atPath: self)
                for subPath in enumerator! {
                    // 获得全路径
                    let fullPath = self.appending("/\(subPath)")
                    do {
                        let attr = try fileManager.attributesOfItem(atPath: fullPath)
                        size += attr[FileAttributeKey.size] as! UInt64
                    } catch  {
                        print("error :\(error)")
                    }
                }
            } else {    // 单文件
                do {
                    let attr = try fileManager.attributesOfItem(atPath: self)
                    size += attr[FileAttributeKey.size] as! UInt64
                    
                } catch  {
                    print("error :\(error)")
                }
            }
        }
        return size
    }

    func highlightWordsIn(highlightedWords: String, attributes: [[NSAttributedStringKey: Any]]) -> NSMutableAttributedString {

        let range = (self as NSString).range(of: highlightedWords)
        let result = NSMutableAttributedString(string: self)

        for attribute in attributes {
            result.addAttributes(attribute, range: range)
        }

        return result
    }
}

// MARK: - Filter networkout sting
extension String {
    mutating func filterNetworkString(_ networkString: String?) {

        guard let string = networkString else {
            return
        }
        if !string.isEmpty {
            self = string
        }
    }
}
