//
//  FDFoundationExtension.swift
//  FD070+
//
//  Created by HaiQuan on 2019/5/9.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import Foundation

extension Bool {
    func toString() ->String {
        switch self {
        case true:
            return "1"
        default:
            return "0"
        }
    }
}
