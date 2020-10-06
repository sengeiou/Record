//
//  BoodSugarTestProgressView.swift
//  FD070+
//
//  Created by HaiQuan on 2019/1/3.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import UIKit

class BloodSugarTestProgressView: UIView {

    private var iconImagView = UIImageView()
    var varLabel = UILabel().then() {
        $0.font = UIFont.boldSystemFont(ofSize: Font(size: 32.auto()))
        $0.textColor = MydayConstant.bloodSugarFillColor

    }
     var unitLabel = UILabel().then() {
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 19.auto())
        $0.textColor = UIColor.gray

    }
    private var descriptionLabel = UILabel().then() {
        $0.font = UIFont.systemFont(ofSize: 17.auto())
        $0.textColor = UIColor.gray
    }
    
    var progressView: BloodSugarDonutView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupData()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {

        let width = (self.width * 3) / 4
        let x = (self.width - width) / 2
        let y = (self.height - width) / 2
        progressView  = BloodSugarDonutView.init(frame: CGRect.init(x: x, y: y, width: width, height: width))

        addSubview(progressView)
        

        backgroundColor = .white

        addSubview(varLabel)
        varLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }

        addSubview(iconImagView)
        iconImagView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.varLabel.snp.top).offset((-MydayConstant.collectionCellSpace))
        }

        addSubview(unitLabel)
        unitLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.varLabel.snp.bottom)
        }

        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { (make) in
            make.bottom.centerX.equalToSuperview()
        }

        
    }
    private func setupData() {

        iconImagView.image = UIImage.init(named: "home_Bloodsugar")
        let GluValue = BloodSugarTestDataHelp.getBloodGluresult()
        varLabel.text = MydayManager.coverBloodGluModelResultValue(GluValue)
        unitLabel.text = MydayManager.coverBloodGluModelDate(GluValue)
        descriptionLabel.text = "MydayVC_bloodDSugar".localiz()

    }

    func startAnimation() {

        progressView.addIndicatorLayerAnimation()

    }
    func endAnimation() {
        progressView.removeIndicatorLayerAnimation()
    }
}
