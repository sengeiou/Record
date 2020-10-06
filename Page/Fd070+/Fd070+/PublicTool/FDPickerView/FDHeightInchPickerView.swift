//
//  FDHeightInchPickerView.swift
//  FD070+
//
//  Created by HaiQuan on 2019/3/14.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import UIKit

class FDHeightInchPickerView: UIView {

    struct Constant {
        static let rowHeight: CGFloat = 55
        static let rowWidth: CGFloat = 100
    }

    private var intPickerView: UIPickerView!
    private var floatPickerView: UIPickerView!

    //主动获取值
    var didSelectValueBlock: ((String) -> Void)?
    //被动获取值
    var didSelectValue: String {
        get{
            return didSelectIntValue + "." + didSelectFloatValue
        }
    }
    private var didSelectIntValue = ""
    private var didSelectFloatValue = ""

    var intPickerViewSelectRow = 0 {
        didSet {
            didSelectIntValue = dataSource.intDataSource[intPickerViewSelectRow]
            intPickerView.selectRow(intPickerViewSelectRow, inComponent: 0, animated: true)
        }
    }
    var floatPickerViewSelectRow = 0 {
        didSet {
            didSelectFloatValue = dataSource.floatDataSource[floatPickerViewSelectRow]
            floatPickerView.selectRow(floatPickerViewSelectRow, inComponent: 0, animated: true)
        }
    }

    var dataSource: HeightInchModel = HeightInchModel() {
        didSet {
            configUI()
        }
    }

    private func configUI() {

        setupIntPickerView()
        setupFloatPickerView()

        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1

    }

    private func setupIntPickerView() {

        intPickerView = UIPickerView()
        intPickerView.tag = 100

        let reduceWidth: CGFloat = 10
        intPickerView.frame = CGRect.init(x: reduceWidth, y: 0, width: (self.bounds.size.width / 2) - (reduceWidth), height: self.bounds.size.height)
        addSubview(intPickerView)

        let labelWidth: CGFloat = 10
        let labelHeight: CGFloat = 30
        let labelX = intPickerView.frame.maxX - labelWidth
        let labelY = (self.bounds.height - labelHeight) / 2
        let unitLabel = getUnitLabel(CGRect.init(x: labelX, y: labelY, width: labelWidth, height: labelHeight), "'")
        addSubview(unitLabel)

        // 设置代理和数据源
        intPickerView.delegate = self
        intPickerView.dataSource = self
    }

    private func setupFloatPickerView() {
        floatPickerView = UIPickerView()
        floatPickerView.tag = 101
        let reduceWidth: CGFloat = 10

        floatPickerView.frame = CGRect.init(x: self.bounds.size.width / 2, y: 0, width: (self.bounds.size.width / 2) - (reduceWidth), height: self.bounds.size.height)
        addSubview(floatPickerView)

        let labelWidth: CGFloat = 10
        let labelHeight: CGFloat = 30
        let labelX = floatPickerView.frame.maxX - labelWidth
        let labelY = (self.bounds.height - labelHeight) / 2
        let unitLabel = getUnitLabel(CGRect.init(x: labelX, y: labelY, width: labelWidth, height: labelHeight), "''")
        addSubview(unitLabel)

        // 设置代理和数据源
        floatPickerView.delegate = self
        floatPickerView.dataSource = self
    }

}
extension FDHeightInchPickerView {

    private func getUnitLabel(_ frame: CGRect, _ text: String) ->UILabel {
        let label = UILabel.init(frame: frame)
        label.text = text
        return label

    }
}
extension FDHeightInchPickerView: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }


    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 100 {
            return dataSource.intDataSource.count
        }else {
            return dataSource.floatDataSource.count
        }

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

        let labelWidth: CGFloat = 40
        let labelHeight: CGFloat = 30
        let labelX = contentView.frame.maxX - labelWidth
        let labelY = (contentView.frame.height - labelHeight) / 2

        let valueLabel = UILabel.init(frame: CGRect.init(x: labelX, y: labelY, width: labelWidth, height: labelHeight))
        valueLabel.font = UIFont.boldSystemFont(ofSize: 25.auto())
        valueLabel.textAlignment = .right
        contentView.addSubview(valueLabel)
        
        let centLayer = CALayer.init()
        centLayer.frame = CGRect.init(x: 0, y: Constant.rowHeight / 2, width: 20.auto(), height: 2)
        centLayer.backgroundColor = UIColor.black.cgColor
        contentView.layer.addSublayer(centLayer)

        if pickerView.tag == 100 {
            valueLabel.text = dataSource.intDataSource[row]
        }else {
            valueLabel.text = dataSource.floatDataSource[row]
        }


        return contentView
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        if pickerView.tag == 100 {
            didSelectIntValue = dataSource.intDataSource[row]
        }else {
            didSelectFloatValue = dataSource.floatDataSource[row]
        }

        if didSelectValueBlock != nil {
            didSelectValueBlock!(didSelectIntValue + didSelectFloatValue)
        }

    }
}


struct HeightInchModel {
    var intDataSource = [String]()
    var floatDataSource = [String]()
}
