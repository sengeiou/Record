//
//  Then.swift
//  Orangetheory
//
//  Created by HaiQuan on 2018/5/31.
//  Copyright © 2018年 WANG DONG. All rights reserved.
//

import Foundation

public protocol Then {}

extension Then where Self: AnyObject {
    
    public func then( block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
    
}

extension NSObject: Then {}

