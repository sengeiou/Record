//
//  MyProfileHeaderTableViewCell.swift
//  FD070+
//
//  Created by Payne on 2018/12/13.
//  Copyright © 2018年 WANG DONG. All rights reserved.
//

import UIKit

class ProfileHeaderView: UIView {

    var bgView = UIImageView().then() {
        $0.image = UIImage.init(named: "Combined_Shape")
    }
    var headerImageView = UIImageView().then() {
        $0.image = UIImage.init(named: "use_photo")
        
    }
    
    var nameLabel = UILabel().then(){
        $0.textColor = UIColor.hexColor(0x696969)
        $0.font = UIFont.init(name: FDFontFamily.helveticaBoldOblique.name, size: 20)
        $0.textAlignment = NSTextAlignment.center
        $0.text = "First Last"
//        $0.lineBreakMode = .middle
    }


    var tapBlock: (()-> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
        bindUI()
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI() {

        addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        
        
        addSubview(headerImageView)
        headerImageView.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp.bottom)
            make.width.equalTo(100)
            make.height.equalTo(100)
            make.centerX.equalTo(self)
        }
        headerImageView.layer.masksToBounds = true
        headerImageView.layer.cornerRadius = 50
        headerImageView.layer.borderColor = UIColor.hexColor(0x1b8dfb).cgColor
        headerImageView.layer.borderWidth = 3
        
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headerImageView.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().inset(10)

        }
    }

    private func bindUI() {
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer()
        addGestureRecognizer(tap)
        tap.addTarget(self, action: #selector(self.tapGesClick))
    }


    func myProfileDisplayData(_ item: UserInfoModel) {


        headerImageView.kf.indicatorType = .activity
        self.headerImageView.kf.setImage(with: URL(string: item.icon), placeholder: UIImage(named: "use_photo"), options: nil, progressBlock: nil, completionHandler: nil)

        self.nameLabel.text = String("\(item.firstname) \(item.lastname)")
    }

    @objc func tapGesClick(sender: UITapGestureRecognizer) {

        if tapBlock != nil {
            tapBlock!()
        }

    }

}
