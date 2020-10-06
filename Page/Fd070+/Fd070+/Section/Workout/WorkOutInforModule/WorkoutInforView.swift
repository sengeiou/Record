//
//  WorkoutInforView.swift
//  FD070+
//
//  Created by HaiQuan on 2019/2/26.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import UIKit

class WorkoutInforView: UIView {

    struct Constant {
        let dividingLineX = 20
        static let mainBGColor = UIColor.RGB(r: 0, g: 125, b: 255)

        //弧形控件的宽度
        static let sliderViewWidth: CGFloat = 80
        //弧形控件的高度
        static let sliderViewHeight: CGFloat = 40
        //弧形控件向上的偏移量
        static let sliderOffsetHeight: CGFloat = 10
    }


    private lazy var typeImageView: UIImageView = {
        return getWorkoutImageView("home_steps")
    }()
    private lazy var stateLabel: UILabel = {
        return getWorkoutInforLabel(15)
    }()
    private lazy var valueLabel: UILabel = {
        return getWorkoutInforLabel(50)
    }()


    private lazy var stepLabel: UILabel = {
        return getWorkoutInforLabel(30)
    }()
    private lazy var durationSecondLabel: UILabel = {
        return getWorkoutInforLabel(30)
    }()
    private lazy var calorieLabel: UILabel = {
        return getWorkoutInforLabel(30)
    }()
    private lazy var hearRateLabel: UILabel = {
        return getWorkoutInforLabel(30)
    }()


    private var pauseBtn: UIButton!
    private var continueBtn: UIButton!

    var currentWorkoutStateBlock:((WorkoutState) ->Void)?

    private lazy var tipLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.RGB(r: 3, g: 43, b: 106)
        label.textColor = UIColor.white
        label.text = "长按暂停键结束锻炼"
        label.textAlignment = .center
        return label
    }()


    private var press: FDProgressButtonView!


    var model: WorkoutInforModel = WorkoutInforModel() {
        didSet {
            setData()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
        bindUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configUI() {

        self.backgroundColor = Constant.mainBGColor

        addDividingLineLayer()

        let dividingLineY = (self.height * 0.4)
        print(dividingLineY)
        addSubview(valueLabel)
        valueLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.snp.top).inset(dividingLineY)
            make.centerX.equalToSuperview()
        }


        addSubview(stateLabel)
        stateLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(valueLabel.snp.top).offset(-10)
            make.centerX.equalToSuperview()
        }


        addSubview(typeImageView)
        typeImageView.snp.makeConstraints { (make) in
            make.bottom.equalTo(stateLabel.snp.top).offset(-10)
            make.centerX.equalToSuperview()

        }



        //左边哪四个图标
        let stepImageView = getWorkoutImageView("exercise_steps")
        addSubview(stepImageView)
        stepImageView.snp.makeConstraints { (make) in
            make.top.equalTo(dividingLineY + 30)
            make.left.equalTo(80)
        }

        let durationSecondImageView = getWorkoutImageView("exercise_time")
        addSubview(durationSecondImageView)
        durationSecondImageView.snp.makeConstraints { (make) in
            make.leading.equalTo(stepImageView.snp.leading)
            make.top.equalTo(stepImageView.snp.bottom).offset(20)
        }


        let calorieImageView = getWorkoutImageView("exercise_kcal")
        addSubview(calorieImageView)
        calorieImageView.snp.makeConstraints { (make) in
            make.leading.equalTo(stepImageView.snp.leading)
            make.top.equalTo(durationSecondImageView.snp.bottom).offset(20)
        }


        let hearRateImageView = getWorkoutImageView("exercise_heart_rate")
        addSubview(hearRateImageView)
        hearRateImageView.snp.makeConstraints { (make) in
            make.leading.equalTo(stepImageView.snp.leading)
            make.top.equalTo(calorieImageView.snp.bottom).offset(20)
        }


        //右边哪四个Label
        addSubview(stepLabel)
        stepLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(stepImageView.snp.centerY)
            make.leading.equalTo(stepImageView.snp.trailing).offset(20)
            make.width.equalToSuperview()
        }

        addSubview(durationSecondLabel)
        durationSecondLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(durationSecondImageView)
            make.leading.equalTo(stepLabel.snp.leading)
            make.width.equalToSuperview()
        }

        addSubview(calorieLabel)
        calorieLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(calorieImageView)
            make.leading.equalTo(stepLabel.snp.leading)
            make.width.equalToSuperview()
        }

        addSubview(hearRateLabel)
        hearRateLabel.snp.makeConstraints { (make) in

            make.centerY.equalTo(hearRateImageView)
            make.leading.equalTo(stepLabel.snp.leading)
            make.width.equalToSuperview()

        }


        let btnWidth: CGFloat = self.width / 4
        let btnX = (self.width - btnWidth) / 2
        let btnY = ((self.height - btnWidth)) - tabBarHeight
        pauseBtn = UIButton.init(frame: CGRect.init(x: btnX, y: btnY, width: btnWidth, height: btnWidth))
        pauseBtn.setImage(UIImage.init(named: "activity_stop"), for: .normal)
        self.addSubview(pauseBtn)

        pauseBtn.addTarget(self, action: #selector(self.pauserBtnClick), for: .touchUpInside)

        tipLabel.isHidden = true
        addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(pauseBtn.snp.bottom).offset(10.auto())
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(30.auto())
        }

        if self.currentWorkoutStateBlock != nil {
            self.currentWorkoutStateBlock!(.start)
        }

    }


    private func bindUI() {

    }

    private func addDividingLineLayer() {

        let dividingLineLayer = CALayer()
        let layerX: CGFloat = 20
        let layerY = (self.height * 0.4)
        dividingLineLayer.frame = CGRect(x: layerX, y: layerY, width: self.width - (layerX * 2), height: 1)
        dividingLineLayer.backgroundColor = UIColor.white.withAlphaComponent(0.5).cgColor
        layer.addSublayer(dividingLineLayer)
    }




    private func setData() {

        typeImageView.image = UIImage.init(named: model.type)
        stateLabel.text = model.state
        //加个空格，防止被切割
        let workoutValue = model.value + " "
        valueLabel.text = workoutValue

        stepLabel.text = model.step
        durationSecondLabel.text = model.durationSecond
        calorieLabel.text = model.calorie
        hearRateLabel.text = model.hearRate


    }

}
extension WorkoutInforView {

    private func getWorkoutInforLabel(_ size: CGFloat) ->UILabel {
        let label = UILabel()
        label.font = UIFont.init(name: "Helvetica-BoldOblique", size: size)
        label.textColor = UIColor.white
        return label
    }

    private func getWorkoutImageView(_ imageStr: String) ->UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage.init(named: imageStr)
        return imageView
    }
}

// MARK: - Workout action
extension WorkoutInforView {

    @objc func pauserBtnClick(sender: UIButton) {

        pauseBtn.isHidden = true
        tipLabel.isHidden = false

        if currentWorkoutStateBlock != nil {
            currentWorkoutStateBlock!(.pause)
        }

        let btnWidth: CGFloat = self.width / 4
        let btnX = (self.width - btnWidth) / 2
        let btnY = ((self.height - btnWidth)) - tabBarHeight - 10
        press = FDProgressButtonView.init(frame: CGRect.init(x: btnX, y: btnY, width: btnWidth, height: btnWidth))

        press.style = .Orange

        press.centerX = self.centerX

        self.addSubview(press)
        press.progressBtnAction = {[unowned self] in

            if self.currentWorkoutStateBlock != nil {
                self.currentWorkoutStateBlock!(.end)
            }
        }


        continueBtn = UIButton.init(frame: CGRect.init(x: btnX, y: btnY, width: btnWidth, height: btnWidth))
        continueBtn.setImage(UIImage.init(named: "activity_start"), for: .normal)
        self.addSubview(continueBtn)

        UIView.animate(withDuration: 0.35) {
            self.press.centerX = self.width * 0.25
            self.continueBtn.centerX = self.width * 0.75
        }



        continueBtn.addTarget(self, action: #selector(self.continueBtnBtnClick), for: .touchUpInside)

        print("workout pause")

    }

    @objc func continueBtnBtnClick(sender: UIButton) {


        UIView.animate(withDuration: 0.25) {
            self.pauseBtn.isHidden = false

        }

        tipLabel.isHidden = true

        if currentWorkoutStateBlock != nil {
            currentWorkoutStateBlock!(.goOn)
        }

        press.removeFromSuperview()
        continueBtn.removeFromSuperview()

        print("workout continue")
    }

}
