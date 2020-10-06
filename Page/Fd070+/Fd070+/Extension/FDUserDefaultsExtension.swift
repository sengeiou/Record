//
//  FDUserDefaults.swift
//  Orangetheory
//
//  Created by HaiQuan on 2018/6/19.
//  Copyright © 2018年 WANG DONG. All rights reserved.
//

import Foundation

public protocol UserDefaultSettable {
    var uniqueKey: String { get }
}

public extension UserDefaultSettable where Self: RawRepresentable, Self.RawValue == String {

    func store(value: Any?) {
        UserDefaults.standard.set(value, forKey: uniqueKey)

    }
    var storedValue: Any? {
        return UserDefaults.standard.value(forKey: uniqueKey)
    }
    //URL
    func store(url: URL?) {
        UserDefaults.standard.set(url, forKey: uniqueKey)

    }
    var storedURL: URL? {
        return UserDefaults.standard.url(forKey: uniqueKey)
    }


    //Bool
    func store(value: Bool) {
        UserDefaults.standard.set(value, forKey: uniqueKey)

    }
    var storedBool: Bool {
        return UserDefaults.standard.bool(forKey: uniqueKey)
    }


    //Int
    func store(value: Int) {
        UserDefaults.standard.set(value, forKey: uniqueKey)


    }
    var storedInt: Int {
        return UserDefaults.standard.integer(forKey: uniqueKey)
    }

    //Double
    func store(value: Double) {
        UserDefaults.standard.set(value, forKey: uniqueKey)

    }
    var storedDouble: Double {
        return UserDefaults.standard.double(forKey: uniqueKey)
    }

    //Float
    func store(value: Float) {
        UserDefaults.standard.set(value, forKey: uniqueKey)

    }
    var storedFloat: Float {
        return UserDefaults.standard.float(forKey: uniqueKey)
    }

    //UUID
    func store(value: UUID) {
        UserDefaults.standard.set(value, forKey: uniqueKey)

    }
    var storedUUID: UUID {
        return UserDefaults.standard.value(forKey: uniqueKey) as! UUID
    }


    var uniqueKey: String {
        return "\(Self.self).\(rawValue)"
    }

    /// removed object from standard userdefaults
    func removed() {
        UserDefaults.standard.removeObject(forKey: uniqueKey)
    }

}

