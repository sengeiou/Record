//
//  HistoryCalendarCollectionViewCell.swift
//  FD070+
//
//  Created by HaiQuan on 2019/1/19.
//  Copyright © 2019年 WANG DONG. All rights reserved.
//

import UIKit

class HistroyCalendarCollectionViewCell: UICollectionViewCell {
    
    private var dateLabel:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 20.auto())
        return label
    }()
    
    
    private let recordBGLayer = CAShapeLayer()
    
    var model = DayModel() {
        didSet {
            setData()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configUI() {

//        self.backgroundColor = UIColor.randomColor

        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        //set recordBGLayer
        let centShapeLayerRadius = self.contentView.width * 0.4
        let path = UIBezierPath.init(arcCenter: self.contentView.center, radius: centShapeLayerRadius, startAngle: 0, endAngle: CGFloat(2 * Double.pi) , clockwise: true)
        recordBGLayer.path = path.cgPath
        contentView.layer.insertSublayer(recordBGLayer, at: 0)
    }
    
    private func setData() {
        
        let dayNumberInt = Int(model.dayNumber) ?? 0
        if dayNumberInt > 0 {
            dateLabel.text = model.dayNumber
            if model.isHaveRecord {
                recordBGLayer.fillColor = UIColor.RGB(r: 253, g: 134, b: 8).cgColor
            }else {
                recordBGLayer.fillColor = MainColor.cgColor
            }
        }else {
            dateLabel.text = ""
            recordBGLayer.fillColor = MainColor.cgColor
        }
        
    }
}
