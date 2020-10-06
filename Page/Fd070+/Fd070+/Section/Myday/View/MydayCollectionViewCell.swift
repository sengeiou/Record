//
//  MydayCollectionViewCell.swift
//  FD070+
//
//  Created by HaiQuan on 2018/12/12.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import UIKit

class MydayCollectionViewCell: UICollectionViewCell {

    private var iconImagView = UIImageView()

    private var varLabel = UILabel().then() {
        $0.textAlignment = .center
        $0.font = UIFont.init(name: FDFontFamily.helveticaBoldOblique.name, size: 26.auto())
        $0.adjustsFontSizeToFitWidth = true
    }
    private var unitLabel = UILabel().then() {
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 12.auto())
        $0.textColor = UIColor.gray
    }
    private var descriptionLabel = UILabel().then() {
        $0.font = UIFont.systemFont(ofSize: 12.auto())
        $0.textColor = UIColor.gray
    }

    private var lightGradientView: FDAngleGradientView!
    private var deepGradientView: FDAngleGradientView!
    private var progressView: MydayProgressView!

    var mydayModel: MydayModel = MydayModel() {

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

    fileprivate func configUI() {

        backgroundColor = .white

        let angleGradientViewWidth = MydayConstant.circleWith * 2
        let angleGradientViewPosition = (MydayConstant.collectionCellWidth - angleGradientViewWidth) / 2

        deepGradientView = FDAngleGradientView.init(frame: CGRect.init(x: angleGradientViewPosition, y:angleGradientViewPosition, width: angleGradientViewWidth, height: angleGradientViewWidth))
        deepGradientView.isHidden = true
        deepGradientView.gradientType = .haveValue
        contentView.addSubview(deepGradientView)

        lightGradientView = FDAngleGradientView.init(frame: CGRect.init(x: angleGradientViewPosition, y:angleGradientViewPosition, width: angleGradientViewWidth, height: angleGradientViewWidth))
        lightGradientView.isHidden = true
        lightGradientView.gradientType = .notValue
        contentView.addSubview(lightGradientView)


        progressView = MydayProgressView.init(frame: CGRect.init(x: 0, y: 0, width: MydayConstant.collectionCellWidth, height: MydayConstant.collectionCellWidth))
        progressView.isHidden = true
        contentView.addSubview(progressView)

        contentView.addSubview(varLabel)
        varLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().inset(40)
        }

        contentView.addSubview(iconImagView)
        iconImagView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.varLabel.snp.top).offset((-MydayConstant.collectionCellSpace))
        }

        contentView.addSubview(unitLabel)
        unitLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.varLabel.snp.bottom)
        }

        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-5.auto())
        }

        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10.auto()

    }

    private func setData() {

        switch mydayModel.type {
        case .walk, .goal, .sportTime, .calorie, .sleepTime, .distance:
            addProgressView()

        case .heartRate, .bloodSugar:
            let value = mydayModel.value
            if value == "---" || value == "" || value == "0" || value.isEmpty {
                addHeartRateGradientView()
            }else {
                addBloodSugarGradientView()
            }

        default:
            break
        }

        progressView.model = mydayModel

        switch mydayModel.type {
        case .walk:
            iconImagView.image = UIImage.init(named: "home_steps")

            descriptionLabel.text = "MydayVC_step".localiz()
            varLabel.textColor = MydayConstant.walkFillColor

            varLabel.text = mydayModel.value
            unitLabel.text = mydayModel.unit

        case .goal:
            iconImagView.image = UIImage.init(named: "home_target")

            descriptionLabel.text = "MydayVC_goal".localiz()
            varLabel.textColor = MydayConstant.percentFillColor

            varLabel.text = mydayModel.value
            unitLabel.text = mydayModel.unit

        case .bloodSugar:
            iconImagView.image = UIImage.init(named: "home_Bloodsugar")

            descriptionLabel.text = "MydayVC_bloodDSugar".localiz()
            varLabel.textColor = MydayConstant.bloodSugarFillColor

            varLabel.text = mydayModel.value
            unitLabel.text = mydayModel.unit

        case .heartRate:

            iconImagView.image = UIImage.init(named: "home_heart_rate")

            descriptionLabel.text = "MydayVC_HR".localiz()
            varLabel.textColor = MydayConstant.heartRateFillColor

            varLabel.text = mydayModel.value
            unitLabel.text = mydayModel.unit

        case .sportTime:

            iconImagView.image = UIImage.init(named: "home_time")

            descriptionLabel.text = "MydayVC_excerciseTime".localiz()
            varLabel.textColor = MydayConstant.sportTimeFillColor


            varLabel.attributedText = MydayManager.highlightDurationUnitWords(mydayModel.value)
            unitLabel.text = mydayModel.unit

        case .calorie:

            iconImagView.image = UIImage.init(named: "home_calories")

            descriptionLabel.text = "MydayVC_calories".localiz()
            varLabel.textColor = MydayConstant.calorieFillColor

            let calorieValue = MydayManager.coverCalorieValue(calorie: mydayModel.value)
            varLabel.text = calorieValue.0
            unitLabel.text = calorieValue.1

        case .sleepTime:
            iconImagView.image = UIImage.init(named: "home_sleep")

            descriptionLabel.text = "MydayVC_sleepTime".localiz()
            varLabel.textColor = MydayConstant.sleepTimeFillColor

            varLabel.attributedText = MydayManager.highlightDurationUnitWords(mydayModel.value)
            unitLabel.text = mydayModel.unit
        case .distance:

            iconImagView.image = UIImage.init(named: "home_distance")

            descriptionLabel.text = "MydayVC_excerciseDistance".localiz()
            varLabel.textColor = MydayConstant.distanceFillColor

            let distanceValue = MydayManager.coverDistanceValue(distance: mydayModel.value)
            varLabel.text = distanceValue.0
            unitLabel.text = distanceValue.1

        default:
            break
        }

    }

    func addProgressView() {
        self.progressView.isHidden = false
        self.lightGradientView.isHidden = true
        self.deepGradientView.isHidden = true
    }
    
    func addHeartRateGradientView() {
        self.progressView.isHidden = true
        self.lightGradientView.isHidden = false
        self.deepGradientView.isHidden = true
    }

    func addBloodSugarGradientView() {
        self.progressView.isHidden = true
        self.lightGradientView.isHidden = true
        self.deepGradientView.isHidden = false
    }

}
// MARK: - HeatRate Animation
extension MydayCollectionViewCell {

    func addHeatRateAnimation() {

        removerHeatRateAnimation()

        let scaleAnimation = FDAnimate.baseAnimationWithKeyPath("transform.scale", fromValue: 1.0, toValue: 0.67, duration: 1.0, repeatCount: Float.infinity, timingFunction: nil)

        iconImagView.layer.add(scaleAnimation, forKey: MydayConstant.heatRateAnimationKey)

    }

    func removerHeatRateAnimation() {

        iconImagView.layer.removeAnimation(forKey: MydayConstant.heatRateAnimationKey)

    }

}



