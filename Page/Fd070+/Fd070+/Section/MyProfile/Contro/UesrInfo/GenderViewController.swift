//
//  GenderViewController.swift
//  FD070+
//
//  Created by Payne on 2018/12/17.
//  Copyright © 2018年 WANG DONG. All rights reserved.
//

import UIKit

class GenderViewController: BaseViewController {
    
    var userModel = UserInfoModel()

    var isFirstLogin : Bool!
    
    let userInfoHerderView = UserInfoHeaderView()
    let genderButton = FDGenderSelectButton()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
         self.title = "UserInformationVC_VCTitle".localiz()
        self.view.backgroundColor = UIColor.white
        configUI()

    }
    
    private func configUI(){
        userInfoHerderView.isHidenProgress(hidden: true)
        userInfoHerderView.getProgressValueAndTitle(progressValue: 0.4, title: "UserInforGenderVC_description".localiz())
        self.view.addSubview(userInfoHerderView)
        userInfoHerderView.snp.makeConstraints { (make) in
            make.top.equalTo(navigationBarHeight + 20.auto())
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(80)
        }
        genderButton.buttonNum = Int(userModel.gender) ?? 0
        genderButton.genderBtnAction = { sender in
            print("++++\(sender)")
            self.userModel.gender = sender.description
            UserInfoManager.updateUserInfo(self.userModel)
            
        }
        view.addSubview(genderButton)
        genderButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(150)
        }
        
        
        if isFirstLogin == true {
            userInfoHerderView.isHidenProgress(hidden: false)
            let nextBtn = FDPublicButton()
            nextBtn.publicBtnAction = {
                
                UserInfoManager.updateUserInfo(self.userModel)
                let vc = HeightViewController()
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
        }
    }
}
