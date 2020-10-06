//
//  DataHelperProtocol.swift
//  Orangetheory
//
//  Created by HaiQuan on 2018/6/5.
//  Copyright © 2018年 WANG DONG. All rights reserved.
//

import Foundation

/// Necessary implementation
protocol DataHelperProtocol {
    associatedtype T
    
    /// Creat table
    ///
    /// - Returns: Creat table finished
    /// - Throws: Error
    static func createTable() throws -> Void
    
    
}

