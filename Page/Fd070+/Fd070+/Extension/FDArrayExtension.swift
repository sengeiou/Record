//
//  ArrayExtension.swift
//  FD070+
//
//  Created by HaiQuan on 2018/12/13.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import Foundation

extension Array {

    subscript (safe index: Index) -> Element? {
        return 0 <= index && index < count ? self[index] : nil
    }

    subscript(i1: Int, i2: Int, rest: Int...) -> [Element] {
        //get the value indext
        get {
            var result: [Element] = [self[i1], self[i2]]
            for index in rest {
                result.append(self[index])
            }
            return result
        }
    }

    mutating func appendArrayObject(fromArray array: [Element]?) {
        if array != nil {
            for item in array! {
                self.append(item)
            }
        }
    }
    mutating func insterArrayObject(fromArray array: [Element]?) {
        if array != nil {
            for item in array! {
                self.insert(item, at: 0)
            }
        }
    }

}
extension Array where Element: Equatable {
    func removingDuplicates() -> Array {
        return reduce(into: []) { result, element in
            if !result.contains(element) {
                result.append(element)
            }else {
                print("Has same object")
            }
        }
    }
}
