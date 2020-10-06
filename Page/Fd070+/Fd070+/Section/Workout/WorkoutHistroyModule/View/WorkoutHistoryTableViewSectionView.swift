//
//  WorkoutHistoryTableViewHeadView.swift
//  FD070+
//
//  Created by HaiQuan on 2019/3/11.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import UIKit

protocol WorkoutHistoryHeaderViewDelegate: AnyObject {
    
    func workoutHistoryHeaderView(_ headerView: WorkoutHistoryTableViewSectionView, didSelectAt index: Int)
}


class WorkoutHistoryTableViewSectionView: UIView {
    
    public weak var delegate: WorkoutHistoryHeaderViewDelegate?
    
    public var index = 0

    private var isSelection = false
    
    private var monthDateLabel: UILabel = {
        return getWorkoutHistoryMonthSummaryLabel(size: 20.auto(), textColor: UIColor.RGB(r: 19, g: 19, b: 19))
    }()

    private var monthDistanceLabel: UILabel = {
        return getWorkoutHistoryMonthSummaryLabel(size: 18.auto(), textColor: UIColor.RGB(r: 60, g: 60, b: 60))
    }()

    private var arrowImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "back02_icon")
        return imgView
    }()


    private var varLabel = UILabel().then() {
        $0.backgroundColor = UIColor.randomColor
        $0.textAlignment = .center
        $0.font = UIFont.init(name: FDFontFamily.helveticaBoldOblique.name, size: 17.auto())
        
    }
    
    var summaryModel: WorkoutHistorySummaryModel = WorkoutHistorySummaryModel() {
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
    private func configUI() {

        self.addSubview(monthDateLabel)
        monthDateLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10.auto())
        }



        self.addSubview(arrowImgView)
        arrowImgView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(10.auto())
        }


        self.addSubview(monthDistanceLabel)
        monthDistanceLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(35.auto())
        }

        self.isUserInteractionEnabled = true
        let tapGes = UITapGestureRecognizer()
        addGestureRecognizer(tapGes)

        tapGes.addTarget(self, action: #selector(self.tapGesClick(sender:)))

        
    }
    private func setData() {
        monthDateLabel.text = summaryModel.monthDate

        let distanceTuple = WorkoutHistoryManager.coverDistanceValue(distance: summaryModel.summaryDistance)
        monthDistanceLabel.text = distanceTuple.0 + distanceTuple.1
    }
    @objc func tapGesClick(sender: UIButton) {

        self.delegate?.workoutHistoryHeaderView(self, didSelectAt: index)

        if self.isSelection {
            print("选中")
            self.arrowImgView.image = UIImage.init(named: "back02_icon")
        }else {
            print("未选中")
            self.arrowImgView.image = UIImage.init(named: "back03_icon")

        }

        self.isSelection = !self.isSelection

        //        UIView.animate(withDuration: 0.5, delay: 0, options: .transitionCurlUp, animations: {
        //
        //            var rotationAngle: CGFloat = 0
        //            if self.isSelection {
        //                print("选中")
        //                rotationAngle = CGFloat(Double.pi)
        //            }else {
        //                  print("未选中")
        //                rotationAngle = CGFloat(-Double.pi)
        //                self.arrowImgView.transform.inverted()
        //            }
        //
        ////            let ss = CGAffineTransformRot
        ////            self.arrowImgView.transform.isIdentity
        //            print(rotationAngle)
        //            self.arrowImgView.transform =   CGAffineTransform.init(rotationAngle: rotationAngle)
        //        }) { (_) in
        //            self.isSelection = !self.isSelection
        //        }

    }
    
}
extension WorkoutHistoryTableViewSectionView {
    private static func getWorkoutHistoryMonthSummaryLabel(size: CGFloat, textColor: UIColor) ->UILabel {
        let label = UILabel()
        label.textColor = textColor
        label.font = UIFont.systemFont(ofSize: size)
        return label
    }
}
