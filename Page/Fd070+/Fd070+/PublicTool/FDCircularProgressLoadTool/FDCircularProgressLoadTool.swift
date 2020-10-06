//
//  FDCircularProgressLoadTool.swift
//  FD070+
//
//  Created by HaiQuan on 2019/1/8.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import Foundation
import UIKit

class FDCircularProgressLoadTool: UIView {

    static var shared  = FDCircularProgressLoadTool()

    private var isDispalyed = false

    private var loadMessageLabel = UILabel().then() {
        $0.textColor = UIColor.gray
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.font = UIFont(name: "Arial-BoldItalicMT", size: 15.auto())
    }

    private var circularProgressMainColor: UIColor?
    private var progressView: FDDonutView!

    private var contentView: UIView!
    private let contentViewWidth: CGFloat = (SCREEN_WIDTH / 2) - 10

    private override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Open func
extension FDCircularProgressLoadTool {

    /// Show load view. default message and default circularProgressColor
    func show() {
        show(message: "Loading".localiz(), circularProgressColor: MainColor)
    }

    /// Show load view with message only
    ///
    /// - Parameter message: Display message string
    func show(message: String) {
        show(message: message, circularProgressColor: MainColor)
    }

    /// Show load view with message. and customize circularColor
    ///
    /// - Parameters:
    ///   - message: Display message string
    ///   - circulaColor: Display circulaColor
    func show(message: String, circulaColor: UIColor) {
        show(message: message, circularProgressColor: circulaColor)
    }

    /// Dismiss load view
    func dismiss() {

        if progressView != nil {
            progressView.endRotationAnimation()
            UIView.animate(withDuration: 0.25) {
                self.removeFromSuperview()
                self.alpha = 0
            }
            isDispalyed = false
        }

    }

}

// MARK: - Filprivat func
extension FDCircularProgressLoadTool {

    /// Setup UI
    fileprivate func setUI() {

        //Set self property
        self.frame = UIScreen.main.bounds
        self.backgroundColor = UIColor(red:0, green:0, blue:0, alpha:0.7)

        //Set contentView
        let xContentView = (self.width - contentViewWidth) / 2
        let yContentView = (self.height - contentViewWidth) / 2

        contentView = UIView.init(frame: CGRect.init(x: xContentView, y: yContentView, width: contentViewWidth, height: contentViewWidth))
        contentView.backgroundColor = .white
        let bezierPath = UIBezierPath.init(roundedRect: contentView.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize.init(width: 10.auto(), height: 10.auto()))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath
        contentView.layer.mask = shapeLayer
        addSubview(contentView)

        //Set progressView
        let dountX = contentViewWidth / 8
        let dountY = contentViewWidth / 8
        let dountWidth = (contentViewWidth * 3 ) / 4
        progressView  = FDDonutView.init(frame: CGRect.init(x: dountX, y: dountY, width: dountWidth, height: dountWidth))

        if circularProgressMainColor != nil {
            progressView.fromColour = MainColor
        }
        progressView.fromColour = UIColor.white
        progressView.toColour = MainColor
        progressView.lineWidth = 15.auto()


        contentView.addSubview(progressView)

        //Set loadMessageLabel
        contentView.addSubview(loadMessageLabel)
        loadMessageLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(10.auto())
            make.right.equalTo(-10.auto())
        }

    }

    /// Show load view
    ///
    /// - Parameters:
    ///   - message: Display message string
    ///   - circularProgressColor: Display circulaColor
    fileprivate func show(message: String, circularProgressColor: UIColor?) {

        if isDispalyed {
            return
        }
        //Remove subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }

        circularProgressMainColor = nil
        circularProgressMainColor = circularProgressColor

        setUI()

        loadMessageLabel.text = message
        progressView.layout()
        progressView.startRotationAnimation()

        isDispalyed = true

        self.alpha = 0
        let keyWindow = UIApplication.shared.keyWindow ?? UIWindow()
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
            keyWindow.addSubview(self)
        }

    }

}
