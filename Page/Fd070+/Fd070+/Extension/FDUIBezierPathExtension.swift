//
//  UIBezierPathExtension.swift
//  FD070+
//
//  Created by HaiQuan on 2018/12/14.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import Foundation
import UIKit

extension UIBezierPath {

    public convenience init(points: [CGPoint]) {
        self.init()
        for (idx,point) in points.enumerated() {
            if idx == 0 {
                move(to: point)
            } else {
                addLine(to: point)
            }
        }
        if points.count > 0 {
//            close()
        }
    }

}
