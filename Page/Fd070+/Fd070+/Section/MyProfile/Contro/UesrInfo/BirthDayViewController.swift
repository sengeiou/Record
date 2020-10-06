//
//  BirthDayViewController.swift
//  FD070+
//
//  Created by Payne on 2018/12/17.
//  Copyright © 2018年 WANG DONG. All rights reserved.
//

import UIKit

class BirthDayViewController: BaseViewController {

    var userModel = UserInfoModel()

    var isFirstLogin : Bool!
    
    let userInfoHerderView = UserInfoHeaderView()
    let birthDayPickerView = FDBirthdayPickerView()
    
    let birthDayLabel = UILabel().then() {
        $0.textColor = UIColor.hexColor(0x484848)
        $0.font = UIFont.systemFont(ofSize: 17.0)
        $0.textAlignment = NSTextAlignment.center
        $0.layer.cornerRadius = 8.0
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.hexColor(0xe4e4e4).cgColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "UserInformationVC_VCTitle".localiz()
        self.view.backgroundColor = UIColor.white
        configUI()
        
        bindUI()
    }


    
    private func configUI(){

        //显示生日的View
        userInfoHerderView.isHidenProgress(hidden: true)
        //        userInfoHerderView.backgroundColor = UIColor.randomColor
        userInfoHerderView.getProgressValueAndTitle(progressValue: 1, title: "UserInformationVC_birthday".localiz())
        self.view.addSubview(userInfoHerderView)
        userInfoHerderView.snp.makeConstraints { (make) in
            make.top.equalTo(20.auto())
            make.left.equalTo(20.auto())
            make.right.equalTo(-20.auto())
            make.height.equalTo(80.auto())
        }
        //显示生日的Label
        let birthDayStr = UserInfoManager.coverBirthDayStr(userModel.birthday)
        birthDayLabel.text = birthDayStr
        view.addSubview(birthDayLabel)
        birthDayLabel.snp.makeConstraints { (make) in
            make.top.equalTo(userInfoHerderView.snp.bottom).offset(20.auto())
            make.left.equalTo(20.auto())
            make.right.equalTo(-20.auto())
            make.height.equalTo(50.auto())
            
        }


        var isChinaTimeZone = true
        if FDLanguageChangeTool.shared.currentLanguage == .en {
            isChinaTimeZone = false
        }

        //选取生日的PickerView
        birthDayPickerView.getCurrentTimeZoneAndTime(isChinaTimeZone: isChinaTimeZone, currentDate: userModel.birthday)
        birthDayPickerView.birthDayBlock = { birthDay in
            //            print(birthDay)
            self.birthDayLabel.text = birthDay
            self.userModel.birthday = birthDay
            let model = UserInfoManager.coverBirthDayStrToStorage(&self.userModel)
            UserInfoManager.updateUserInfo(model)
            
        }
        birthDayPickerView.layer.borderWidth = 1.0
        birthDayPickerView.layer.borderColor = UIColor.hexColor(0xebebeb).cgColor
        view.addSubview(birthDayPickerView)
        birthDayPickerView.snp.makeConstraints { (make) in
            make.top.equalTo(birthDayLabel.snp.bottom).offset(20.auto())
            make.left.equalTo(20.auto())
            make.right.equalTo(-20.auto())
            make.height.equalTo(view.height * 0.38)
        }
        
        firstLoginSetup()
    }

    private func firstLoginSetup() {
        if isFirstLogin == true {

            userInfoHerderView.isHidenProgress(hidden: false)
            let nextBtn = FDPublicButton()
            nextBtn.publicBtnAction = {

                let model = UserInfoManager.coverBirthDayStrToStorage(&self.userModel)
                UserInfoManager.updateUserInfo(model)
                let vc = TargetViewController()
                vc.userModel = self.userModel
                vc.isFirstLogin = true
                self.navigationController?.pushViewController(vc, animated: true)

            }
            view.addSubview(nextBtn)
            nextBtn.snp.makeConstraints { (make) in

                if #available(iOS 11.0, *) {
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(15)
                } else {
                    make.bottom.equalTo(self.bottomLayoutGuide.snp.bottom).inset(15)
                }
                make.left.equalTo(view).offset(15)
                make.right.equalTo(view).inset(15)
                make.height.equalTo(50)
            }
        }else {

        }
    }

    private func bindUI() {


    }
}
