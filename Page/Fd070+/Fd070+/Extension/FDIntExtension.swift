//
//  IntExtension.swift
//  FD070+
//
//  Created by HaiQuan on 2018/12/14.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import Foundation

// MARK: - Methods
public extension Int {

    /// SwifterSwift: Random integer between two integer values.
    ///
    /// - Parameters:
    ///   - min: minimum number to start random from.
    ///   - max: maximum number random number end before.
    /// - Returns: random double between two double values.
    static func random(between min: Int, and max: Int) -> Int {
        return random(inRange: min...max)
    }
    /// SwifterSwift: Random integer in a closed interval range.
    ///
    /// - Parameter range: closed interval range.
    /// - Returns: random double in the given closed range.
    static func random(inRange range: ClosedRange<Int>) -> Int {
        let delta = UInt32(range.upperBound - range.lowerBound + 1)
        return range.lowerBound + Int(arc4random_uniform(delta))
    }

}
