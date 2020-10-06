//
//  WorkoutSetTargetPickView.swift
//  FD070+
//
//  Created by HaiQuan on 2019/3/8.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import UIKit

class FDPickView: UIView {
    
    struct Constant {
        static let rowHeight: CGFloat = 55.auto()
        static let rowWidth: CGFloat = 80.auto()
    }
    
    enum PickViewType {
        case heightMetric
        case heightInch
        case weightMetric
        case weightPound
        
        case distance
        case Schedule
    }
    
    private var pickerView: UIPickerView!
    
    //被动传出值。（需主动获取）
    var didSelectValue: String?
    //主动传出值。
    var didSelectValueBlock: ((String) -> Void)?
    
    //可选传入值
    var unitType = PickViewType.distance
    var selectRow = 0 {
        didSet {
            didSelectValue = dataSource[selectRow]
            pickerView.selectRow(selectRow, inComponent: 0, animated: true)
        }
    }
    
    //必须传入。配置UI传入值。
    var dataSource: [String] = [String]() {
        didSet {
            configUI()
        }
    }

    private func configUI() {
        
        pickerView = UIPickerView()
        let reduceWidth: CGFloat = 10.auto()
        
        pickerView.frame = CGRect.init(x: reduceWidth, y: reduceWidth, width: self.bounds.size.width - (reduceWidth * 2), height: self.bounds.size.height - (reduceWidth * 2))
        addSubview(pickerView)
        
        var unitStr = ""
        
        switch unitType {
        case .heightMetric:
            unitStr = "CM"
        case .heightInch:
            unitStr = ""
        case .weightMetric:
            unitStr = "KG"
        case .weightPound:
            unitStr = "POUND"
        case .distance:
            unitStr = "WorkoutVC_workoutSetTargetVC_distanceUnit".localiz()
        case .Schedule:
            unitStr = "WorkoutVC_workoutSetTargetVC_scheduleUnit".localiz()
        }
        
        
        let labelWidth: CGFloat = 100.auto()
        let labelHeight: CGFloat = 30.auto()
        let labelX = (self.bounds.width + Constant.rowWidth) / 2
        let labelY = (self.bounds.height - labelHeight) / 2
        let unitLabel = UILabel.init(frame: CGRect.init(x: (reduceWidth) + labelX, y: labelY, width: labelWidth, height: labelHeight))
        unitLabel.text = unitStr
        unitLabel.font = UIFont.systemFont(ofSize: 17.auto())
        addSubview(unitLabel)
        
        // 设置代理和数据源
        pickerView.delegate = self
        pickerView.dataSource = self
        
        
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.5
        
    }
    
}
extension FDPickView: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        valueLabel.textAlignment = .right
        contentView.addSubview(valueLabel)
        
        let topLayer = CALayer.init()
        topLayer.frame = CGRect.init(x: 0, y: -10, width: 6, height: 2)
        topLayer.backgroundColor = UIColor.black.cgColor
        
        let centLayer = CALayer.init()
        centLayer.frame = CGRect.init(x: 0, y: Constant.rowHeight / 2, width: 20.auto(), height: 2)
        centLayer.backgroundColor = UIColor.black.cgColor
        contentView.layer.addSublayer(centLayer)
        
        let bottomLayer = CALayer.init()
        bottomLayer.frame = CGRect.init(x: 0, y: Constant.rowWidth + 10, width: 6, height: 2)
        bottomLayer.backgroundColor = UIColor.black.cgColor
        
        return contentView
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let selectValue = dataSource[row]
        didSelectValue = selectValue
        
        if didSelectValueBlock != nil {
            didSelectValueBlock!(selectValue)
        }
        
    }
}

