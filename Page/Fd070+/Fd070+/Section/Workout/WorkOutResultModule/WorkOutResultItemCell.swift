
//
//  WorkOutResultItemCellCollectionViewCell.swift
//  FD070+
//
//  Created by HaiQuan on 2019/2/26.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import UIKit

class WorkOutResultItemCell: UICollectionViewCell {
    
    var heartRateGradientView: FDAngleGradientView!

    private var progressView: WorkOutResultProgressView!

    private var iconImagView = UIImageView()

    private lazy var valueLabel: UILabel = {
        return getWorkOutResultUnitLabel(26.auto())
    }()

    private var unitLabel: UILabel =  {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12.auto())
        label.textColor = UIColor.gray
        return label
    }()
    private var descriptionLabel: UILabel =  {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.auto())
        label.textColor = UIColor.gray
        return label
    }()
    
    var model: WorkOutResultItemModel = WorkOutResultItemModel() {

        didSet {
            self.setData()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        configUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setData() {
        progressView.model = model

        iconImagView.image = UIImage.init(named: model.icon)

        switch model.type {
        case .schedule:
            valueLabel.attributedText = WorkOutResultManager.highlightSportScheduleWords(model.value)
            unitLabel.text = model.unit
        case .distance:
            let tuple = WorkOutResultManager.coverDistanceValue(distance: model.value)
            
            valueLabel.text = tuple.0
            unitLabel.text = tuple.1

        case .calorie:

            let tuple = WorkOutResultManager.coverCalorieValue(calorie: model.value)

            valueLabel.text = tuple.0
            unitLabel.text = tuple.1
        default:
            valueLabel.text = model.value
            unitLabel.text = model.unit
        }

        descriptionLabel.text = model.describe

        valueLabel.textColor = model.mainColor

        //是负数. 说明是心率表示图，
        if model.progress < 0 {
            progressView.isHidden = true
            heartRateGradientView.isHidden = false
            //心率-1没值。它是没有进度的。
            heartRateGradientView.gradientType = .notValue

        }else {
            progressView.isHidden = false
            heartRateGradientView.isHidden = true
        }
    }


    private func configUI() {

        self.backgroundColor = UIColor.white
        
        contentView.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().inset(40)
        }

        contentView.addSubview(iconImagView)
        iconImagView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.valueLabel.snp.top).offset((-MydayConstant.collectionCellSpace))
        }

        contentView.addSubview(unitLabel)
        unitLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.valueLabel.snp.bottom)
        }
        
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(contentView.snp.bottom).inset(5.auto())

        }
        
        progressView = WorkOutResultProgressView.init(frame: CGRect.init(x: 0, y: 0, width: MydayConstant.collectionCellWidth, height: MydayConstant.collectionCellWidth))
        contentView.addSubview(progressView)

        heartRateGradientView = FDAngleGradientView.init(frame: CGRect.init(x: 0, y:0, width: MydayConstant.collectionCellWidth, height: MydayConstant.collectionCellWidth))
        contentView.addSubview(heartRateGradientView)

        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10.auto()


    }
}
extension WorkOutResultItemCell {

    private func getWorkOutResultUnitLabel(_ size: CGFloat) ->UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.init(name: FDFontFamily.helveticaBoldOblique.name, size: size)
        label.adjustsFontSizeToFitWidth = true
        return label
    }
}
