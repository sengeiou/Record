//
//  TargetViewController.swift
//  FD070+
//
//  Created by Payne on 2018/12/17.
//  Copyright © 2018年 WANG DONG. All rights reserved.
//

import UIKit

class TargetViewController: BaseViewController {

    var userModel = UserInfoModel()
    let targetTextFiled = FDNameTextFiledView()
    var isFirstLogin : Bool!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "UserInforGoalVC_targetSetting".localiz()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(self.handleTap(sender:))))

        configUI()

    }



    private func configUI(){

        targetTextFiled.nameTextField.text = String(userModel.goal)
        targetTextFiled.nameTextField.keyboardType = UIKeyboardType.numberPad
        targetTextFiled.nameTextField.placeholder = "UserInforGoalVC_placeholder".localiz()
        targetTextFiled.nameTextFieldBlock = { text in
            print("text++++\(text)")
            self.userModel.goal = text
            UserInfoManager.updateUserInfo(self.userModel)

        }
        view.addSubview(targetTextFiled)
        targetTextFiled.snp.makeConstraints { (make) in
            make.top.equalTo(navigationBarHeight + 20.auto())
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(50.auto())
        }
        let tipLabel = UILabel()
        tipLabel.text = "UserInforGoalVC_description".localiz()
        tipLabel.textColor = UIColor.hexColor(0x565656)
        tipLabel.numberOfLines = 0
        tipLabel.textAlignment = NSTextAlignment.center
        tipLabel.font = UIFont.boldSystemFont(ofSize: 25.auto())
        view.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.top.equalTo(targetTextFiled.snp.bottom).offset(20.auto())
            make.left.equalTo(20.auto())
            make.right.equalTo(-20.auto())

        }

        if isFirstLogin == true {

            let notSetupBtn = UIButton(type: .custom)
            notSetupBtn.setTitle("UserInforGoalVC_targetSettingIgnore".localiz(), for: .normal)
            notSetupBtn.setTitleColor(UIColor.RGB(r: 80, g: 80, b: 80), for: .normal)
            notSetupBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18.auto())
            notSetupBtn.addTarget(self, action: #selector(notSetupBtnClick), for: .touchUpInside)
            notSetupBtn.backgroundColor = .clear
            notSetupBtn.setTitleColor(.black, for: .normal)

            view.addSubview(notSetupBtn)
            notSetupBtn.snp.makeConstraints { (make) in

                if #available(iOS 11.0, *) {
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(15).inset(60)
                } else {
                    make.bottom.equalTo(self.bottomLayoutGuide.snp.bottom).inset(15).inset(60)
                }
                make.centerX.equalToSuperview()
                make.height.equalTo(40)
            }


            let nextBtn = FDPublicButton()
            nextBtn.publicBtnAction = {
                //Update userInfo DB
                UserInfoManager.updateUserInfo(self.userModel)
                //That is in main thread
                FDCircularProgressLoadTool.shared.show()
                //Upload userinfo
                UserInfoManager.uploadUserInformation(userModel: self.userModel, complete: { (result) in
                    FDCircularProgressLoadTool.shared.dismiss()
                    self.navigationController?.pushViewController(DeviceSelectDevcieViewController(), animated: true)
                })
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
        }

    }

    @objc func notSetupBtnClick(){

        if isFirstLogin == true {
            self.navigationController?.pushViewController(DeviceSelectDevcieViewController(), animated: true)
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }

    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            self.targetTextFiled.nameTextField.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }



}
