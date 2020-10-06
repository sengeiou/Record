
//
//  MyView.swift
//  hhh
//
//  Created by HaiQuan on 2019/2/22.
//  Copyright © 2019 HaiQuan. All rights reserved.
//

import Foundation
import UIKit

class FDAngleGradientView: UIView {

    struct Constant {
        static var lineWidth: CGFloat = 15.auto()

    }

    enum GradientDispalyType {
        case haveValue
        case notValue
    }

    var gradientType: GradientDispalyType = .haveValue {
        didSet {
            configUI()
        }
    }

    override class var layerClass: AnyClass {
        return AngleGradientLayer.self
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        let gradientLayer: AngleGradientLayer = self.layer as! AngleGradientLayer

        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = Constant.lineWidth

        let radius = (MydayConstant.circleWith - MydayConstant.circleSpace ) * 2
        let x = (self.width - radius) / 2

        let path = UIBezierPath.init(ovalIn: CGRect.init(x: x, y: x, width: radius, height: radius))

        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor

        gradientLayer.mask = shapeLayer
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configUI() {
        let gradientLayer: AngleGradientLayer = self.layer as! AngleGradientLayer

        gradientLayer.colors = nil

        switch gradientType {
        case .haveValue:
            gradientLayer.colors = getForegroundColors()
        case .notValue:
            gradientLayer.colors = getBackgroundColors()
        }
    }

}

extension FDAngleGradientView {
    //正常的背景色
    private func getForegroundColors() ->[Any] {
        //首尾的颜色要一样。才能拼接颜色
        var colors = [UIColor.RGB(r: 87, g: 32, b: 172).cgColor]
        colors.append(UIColor.RGB(r: 20, g: 50, b: 240).cgColor)
        colors.append(UIColor.RGB(r: 32, g: 242, b: 22).cgColor)
        colors.append(UIColor.RGB(r: 87, g: 32, b: 172).cgColor)
        return colors
    }
    //较轻的颜色
    private func getBackgroundColors() ->[Any] {
        var colors = [UIColor.RGB(r: 199, g: 180, b: 231).cgColor]
        colors.append(UIColor.RGB(r: 164, g: 204, b: 240).cgColor)
        colors.append(UIColor.RGB(r: 166, g: 255, b: 173).cgColor)
        colors.append(UIColor.RGB(r: 199, g: 180, b: 231).cgColor)
        return colors
    }
}
