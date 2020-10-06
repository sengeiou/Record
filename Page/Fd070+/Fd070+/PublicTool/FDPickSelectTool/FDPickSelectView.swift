//
//  FDPickSelectView.swift
//  FD070+
//
//  Created by HaiQuan on 2019/4/2.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import UIKit

class FDPickSelectView: UIView {

    struct Constant {
        static let rowHeight: CGFloat = 55.auto()
        static let rowWidth: CGFloat = 80.auto()

        static let contentViewWidth: CGFloat = SCREEN_WIDTH - 60
        static let contentViewHeight: CGFloat = (SCREEN_WIDTH / 2)
    }

    static var shared  = FDPickSelectView()

    private var titleLabel = UILabel().then() {
        $0.textColor = UIColor.black
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.font = UIFont(name: "Arial-BoldItalicMT", size: 18.auto())
    }


    private var dataSource = [String]()
    private var pickerView = UIPickerView()
    private var didSelectIndexBlock: ((Int) -> Void)!
    private var contentView = UIView()
}

// MARK: - Open func
extension FDPickSelectView {

    /// Dismiss load view
    func dismiss() {

        UIView.animate(withDuration: 0.25) {
            self.removeFromSuperview()
            self.alpha = 0
        }
    }

    func show(title: String, dataSource: [String], defalutSelectedIndex: Int = 0, slectedBlock: @escaping ((Int) ->())) {


        //Remove subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }

        didSelectIndexBlock = slectedBlock

        self.dataSource = dataSource
        setUI()

        pickerView.selectRow(defalutSelectedIndex, inComponent: 0, animated: true)
        titleLabel.text = title

        self.alpha = 0
        let keyWindow = UIApplication.shared.keyWindow ?? UIWindow()
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
            keyWindow.addSubview(self)
        }

    }

}

// MARK: - Filprivat func
extension FDPickSelectView {

    /// Setup UI
    fileprivate func setUI() {

        //Set self property
        self.frame = UIScreen.main.bounds
        self.backgroundColor = UIColor(red:0, green:0, blue:0, alpha:0.7)

        //Set contentView
        let xContentView = (self.width - Constant.contentViewWidth) / 2
        let yContentView = (self.height - Constant.contentViewHeight) / 2

        contentView = UIView.init(frame: CGRect.init(x: xContentView, y: yContentView, width: Constant.contentViewWidth, height: Constant.contentViewHeight))
        contentView.backgroundColor = .white
        let bezierPath = UIBezierPath.init(roundedRect: contentView.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize.init(width: 10.auto(), height: 10.auto()))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath
        contentView.layer.mask = shapeLayer
        addSubview(contentView)


        //Set titleLabel
        titleLabel.frame =  CGRect.init(x: (contentView.width - 100) / 2, y: 5, width: 100, height: 30)
        contentView.addSubview(titleLabel)

        pickerView.frame = CGRect.init(x: 0, y: titleLabel.bottom + 5, width: contentView.width, height: contentView.height - titleLabel.bottom)
        contentView.addSubview(pickerView)

        // 设置代理和数据源
        pickerView.delegate = self
        pickerView.dataSource = self


        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.5


        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapGesture))
        self.addGestureRecognizer(tap)


        let separateTopLayer = CALayer()
        separateTopLayer.frame = CGRect.init(x: 30, y: titleLabel.bottom + 5, width: contentView.width - 50, height: 0.5)
        separateTopLayer.backgroundColor = UIColor.gray.cgColor
        contentView.layer.addSublayer(separateTopLayer)

    }

    @objc private func tapGesture() {
        dismiss()
    }

}

extension FDPickSelectView: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {

        return Constant.rowHeight
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {

        return Constant.rowWidth
    }
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        if view != nil {
            return view!
        }

        let contentView = UIView.init(frame: CGRect.init(x:0, y: 0, width: Constant.rowWidth, height: Constant.rowHeight))

        let valueLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: Constant.rowWidth, height: Constant.rowHeight))
        valueLabel.font = UIFont.boldSystemFont(ofSize: 25.auto())
        valueLabel.text = dataSource[row]
        valueLabel.textAlignment = .center
        contentView.addSubview(valueLabel)

        return contentView
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        didSelectIndexBlock(row)
    }
}
