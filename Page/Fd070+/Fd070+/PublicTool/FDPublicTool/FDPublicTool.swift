//
//  FDPublicTool.swift
//  FD070+
//
//  Created by HaiQuan on 2019/5/5.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import Foundation

struct FDPublicTool {

    static func isNewestWristVersion(_ newVersion: String, _ oldVersion: String) ->Bool {

        let newString = newVersion.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "V", with: "")
        let oldString = oldVersion.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "V", with: "")

        let newInt = Int(newString) ?? 0
        let oldInt = Int(oldString) ?? 0

        return newInt > oldInt

    }
}
