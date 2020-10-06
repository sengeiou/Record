/*
 This file is part of ByteBackpacker Project. It is subject to the license terms in the LICENSE file found in the top-level directory of this distribution and at https://github.com/michaeldorner/ByteBackpacker/blob/master/LICENSE. No part of ByteBackpacker Project, including this file, may be copied, modified, propagated, or distributed except according to the terms contained in the LICENSE file.
 */

import Foundation


public typealias Byte = UInt8


/// ByteOrder
///
/// Byte order can be either big or little endian.
public enum ByteOrder {
    case bigEndian
    case littleEndian

    /// Machine specific byte order
    public static let nativeByteOrder: ByteOrder = (Int(CFByteOrderGetCurrent()) == Int(CFByteOrderLittleEndian.rawValue)) ? .littleEndian : .bigEndian
}
public extension Data {

    /// Extension for exporting Data (NSData) to byte array directly
    ///
    /// - Returns: Byte array
    func toByteArray() -> [Byte] {
        let count = self.count / MemoryLayout<Byte>.size
        var array = [Byte](repeating: 0, count: count)
        copyBytes(to: &array, count:count * MemoryLayout<Byte>.size)
        return array
    }

    func scanValue<T: FixedWidthInteger>(at index: Data.Index) -> T {
        let number: T = self.subdata(in: index..<index + MemoryLayout<T>.size).withUnsafeBytes({ $0.pointee })
        return number.littleEndian
    }


    /// To interger Data by range
    ///
    /// - Parameters:
    ///   - data:       Data
    ///   - startRange: StartRange
    ///   - endRange:   EndRange
    /// - Returns:      Integer Typed
    func toInterger<T : BinaryInteger>(withData data: NSData, withStartRange startRange: Int, withSizeRange endRange: Int) -> T {
        var d : T = 0
        (self as NSData).getBytes(&d, range: NSRange(location: startRange, length: endRange))
        return d
    }


}
extension NSData{
    var int :  Int{
        var out: Int = 0
        self.getBytes(&out, length: MemoryLayout<Int>.size)
        return out
    }
}

extension NSMutableData {

    func appendInt32(value : Int32) {
        var val = value
        self.append(&val, length: MemoryLayout<Int32>.size)
    }

    func appendInt16(value : Int16) {
        var val = value
        self.append(&val, length: MemoryLayout<Int16>.size)
    }

    func appendInt8(value : UInt8) {
        var val = value
        self.append(&val, length: MemoryLayout<UInt8>.size)
    }


}
