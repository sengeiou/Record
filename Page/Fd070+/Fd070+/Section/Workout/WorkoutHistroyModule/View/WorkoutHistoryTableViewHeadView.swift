//
//  WorkoutHistoryTableViewHeadView.swift
//  FD070+
//
//  Created by HaiQuan on 2019/3/11.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import UIKit

class WorkoutHistoryTableViewHeadView: UIView {
    
    private let titleLabel: UILabel = {
        let label = getWorkoutHistorySummaryLabel(size: 25.auto())
        label.text = "WorkoutVC_workoutHistory_desc".localiz()
        return label
    }()
    
    var descriptionLabel: UILabel = {
        return getWorkoutHistorySummaryLabel(size: 30.auto())
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configUI() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.snp.centerY).inset(5.auto())
        }
        
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.snp.centerY).offset(5.auto())
        }
    }
    
}
extension WorkoutHistoryTableViewHeadView {
    private static func getWorkoutHistorySummaryLabel(size: CGFloat) ->UILabel {
        let label = UILabel()
        label.textColor = UIColor.RGB(r: 19, g: 19, b: 19)
        label.font = UIFont.systemFont(ofSize: size)
        return label
    }
}
