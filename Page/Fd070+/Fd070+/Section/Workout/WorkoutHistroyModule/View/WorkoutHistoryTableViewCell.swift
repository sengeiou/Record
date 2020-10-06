//
//  WorkoutHistoryTableViewCell.swift
//  FD070+
//
//  Created by HaiQuan on 2019/3/11.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import UIKit

class WorkoutHistoryTableViewCell: UITableViewCell {

    private var typeImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "exercise_walking01")
        return imgView
    }()

    private var distanceLabel: UILabel = {
        return getWorkoutDetailLabel(size: 18.auto())
    }()

    private var dateLabel: UILabel = {
        return getWorkoutDetailLabel(size: 15.auto())
    }()

    private var scheduleBtn: UIButton!
    private var stepBtn: UIButton!
    private var calorieBtn: UIButton!




    var detailModel: WorkoutHistoryDetailModel = WorkoutHistoryDetailModel() {

        didSet {
            self.setData()
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configUI() {

        contentView.addSubview(typeImgView)
        typeImgView.snp.makeConstraints { (make) in
            make.left.equalTo(20.auto())
            make.centerY.equalToSuperview()
        }

        contentView.addSubview(distanceLabel)
        distanceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(15.auto())
            make.left.equalTo(typeImgView.snp.right).offset(10)
        }

        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(10.auto())
        }

        //下面那三个Button-----------------------------
        let btnWidth = contentView.width / 3.5
        let btnHeight = contentView.height / 2

        let btnY: CGFloat = 50.auto()
        let startX = (contentView.width - (btnWidth * 3)) / 2


        scheduleBtn = getWorkoutDetailBtn(rect: CGRect(x: startX * 1, y: btnY, width: btnWidth, height: btnHeight))
        scheduleBtn.setImage(UIImage.init(named: "exercise_time01"), for: .normal)
        contentView.addSubview(scheduleBtn)

        stepBtn = getWorkoutDetailBtn(rect: CGRect(x: startX + (btnWidth), y: btnY, width: btnWidth, height: btnHeight))
        stepBtn.setImage(UIImage.init(named: "exercise_steps01"), for: .normal)
        contentView.addSubview(stepBtn)

        calorieBtn = getWorkoutDetailBtn(rect: CGRect(x: startX + (btnWidth * 2), y: btnY, width: btnWidth, height: btnHeight))
        calorieBtn.setImage(UIImage.init(named: "exercise_kcal01"), for: .normal)
        contentView.addSubview(calorieBtn)


    }

    fileprivate func setData() {

        let distanceTuple = WorkoutHistoryManager.coverDistanceValue(distance: detailModel.distance)
        distanceLabel.text = distanceTuple.0 + distanceTuple.1
        dateLabel.text = detailModel.dayDate

        scheduleBtn.setTitle(WorkoutHistoryManager.getWorkoutDurationString(detailModel.schedule), for: .normal)
        stepBtn.setTitle(detailModel.step, for: .normal)
        calorieBtn.setTitle(detailModel.calorie, for: .normal)

        switch detailModel.type {
        case "2":
            typeImgView.image = UIImage.init(named: "exercise_running01")
        default:
            typeImgView.image = UIImage.init(named: "exercise_walking01")
        }

    }
}
extension WorkoutHistoryTableViewCell {
    private static func getWorkoutDetailLabel(size: CGFloat) ->UILabel {

        let label = UILabel()
        label.textColor = UIColor.RGB(r: 19, g: 19, b: 19)
        label.font = UIFont.systemFont(ofSize: size)
        return label
    }

    private func getWorkoutDetailBtn(rect: CGRect) -> UIButton {

        let btn = UIButton.init(frame: rect)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12.auto())
        btn.setTitleColor(UIColor.black, for: .normal)

        btn.titleLabel?.sizeToFit()

        var btnImageWidth = btn.imageView!.bounds.size.width
        var btnLabelWidth = btn.titleLabel!.bounds.size.width
        let margin: CGFloat = -3
        //设置text 和 image的间距
        btnImageWidth += margin
        btnLabelWidth += margin

        btn.titleEdgeInsets = UIEdgeInsetsMake(0, -btnImageWidth , 0, btnImageWidth)
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, btnLabelWidth, 0, -btnLabelWidth)

        return btn
    }
}
