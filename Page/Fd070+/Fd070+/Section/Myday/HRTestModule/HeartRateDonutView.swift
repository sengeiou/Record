//
//  HeartRateDonutView.swift
//  FD070+
//
//  Created by HaiQuan on 2019/2/14.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import UIKit

class HeartRateDonutView: UIView {

    private struct Constant {
        static let lineWidth: CGFloat = 16.auto()
    }
    var donutView: FDDonutView!


    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configUI() {

        donutView = FDDonutView()
        donutView.frame = self.bounds
//调整色值
        //        donutView.baseColour = UIColor.clear
//        donutView.fromColour = UIColor.RGB(r: 73, g: 32, b: 188).withAlphaComponent(0.5)
//        donutView.toColour = UIColor.RGB(r: 5, g: 66, b: 255).withAlphaComponent(0.5)

        donutView.baseColour = UIColor.clear
        donutView.fromColour = UIColor.blue
        donutView.toColour = UIColor.green

        donutView.duration = 0
        donutView.lineWidth = Constant.lineWidth
        donutView.layout()
        donutView.set(percentage: 1)
        addSubview(donutView)

    }
}
