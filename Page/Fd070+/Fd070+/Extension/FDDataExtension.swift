//
//  FDDataExtension.swift
//  FD070+
//
//  Created by WANG DONG on 2018/12/24.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import UIKit

extension Data {
    
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }
    
    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return map { String(format: format, $0) }.joined()
    }
}

//Data扩展操作
extension Data {
    
    internal var hexString: String {
        let pointer = self.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> UnsafePointer<UInt8> in
            return bytes
        }
        let array = getByteArray(pointer)
        
        return array.reduce("") { (result, byte) -> String in
            result + String(format: "%02x", byte)
        }
    }
    
    private func getByteArray(_ pointer: UnsafePointer<UInt8>) -> [UInt8] {
        let buffer = UnsafeBufferPointer<UInt8>(start: pointer, count: count)
        return [UInt8](buffer)
    }
}

// Source: http://stackoverflow.com/a/42241894/2115352

public protocol DataConvertible {
    static func + (lhs: Data, rhs: Self) -> Data
    static func += (lhs: inout Data, rhs: Self)
}

extension DataConvertible {
    public static func + (lhs: Data, rhs: Self) -> Data {
        var value = rhs
        let data = Data(buffer: UnsafeBufferPointer(start: &value, count: 1))
        return lhs + data
    }
    
    public static func += (lhs: inout Data, rhs: Self) {
        lhs = lhs + rhs
    }
}

extension UInt8 : DataConvertible { }
extension UInt16 : DataConvertible { }
extension UInt32 : DataConvertible { }


extension Int    : DataConvertible { }
extension Float  : DataConvertible { }
extension Double : DataConvertible { }

extension String : DataConvertible {
    public static func + (lhs: Data, rhs: String) -> Data {
        guard let data = rhs.data(using: .utf8) else { return lhs}
        return lhs + data
    }
}

extension Data : DataConvertible {
    public static func + (lhs: Data, rhs: Data) -> Data {
        var data = Data()
        data.append(lhs)
        data.append(rhs)
        
        return data
    }
}

