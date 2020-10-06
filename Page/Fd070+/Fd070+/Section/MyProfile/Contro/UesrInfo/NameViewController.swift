//
//  NameViewController.swift
//  FD070+
//
//  Created by Payne on 2018/12/17.
//  Copyright © 2018年 WANG DONG. All rights reserved.
//

import UIKit

class NameViewController: BaseViewController {

    var userModel = UserInfoModel()

    var isFirstLogin : Bool!

    let userInfoHerderView = UserInfoHeaderView()
    
    let firstNameTextFiledView = FDNameTextFiledView()
    let lastNameTextFiledView = FDNameTextFiledView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "UserInformationVC_VCTitle".localiz()
        self.view.backgroundColor = UIColor.white
        configUI()
        configNavUI()
        bindUI()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(self.handleTap(sender:))))
        

    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController!.navigationBar.tintColor = UIColor.white
    }

    private func configNavUI(){
    }
    
    private func configUI(){
        userInfoHerderView.isHidenProgress(hidden: true)
        userInfoHerderView.getProgressValueAndTitle(progressValue: 0.2, title: "UserInformationVC_nameHeadTitle".localiz())
        
        self.view.addSubview(userInfoHerderView)
        userInfoHerderView.snp.makeConstraints { (make) in
            make.top.equalTo(navigationBarHeight + 20.auto())
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(80)
        }
        let placeholderAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.gray,
            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 12)
        ]

        firstNameTextFiledView.nameTextField.text = userModel.firstname
        firstNameTextFiledView.nameTextField.attributedPlaceholder = NSAttributedString(string: "UserInforNameVC_firstName".localiz(), attributes:placeholderAttributes)

        firstNameTextFiledView.nameTextFieldBlock = {[unowned self] text in
            print("text++++\(text)")
            self.userModel.firstname = text
            UserInfoManager.updateUserInfo(self.userModel)
            
        }
        view.addSubview(firstNameTextFiledView)
        firstNameTextFiledView.snp.makeConstraints { (make) in
            make.top.equalTo(userInfoHerderView.snp.bottom).offset(50)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(50)
        }
        
        lastNameTextFiledView.nameTextField.text = userModel.lastname
        lastNameTextFiledView.nameTextField.attributedPlaceholder = NSAttributedString(string: "UserInforNameVC_lastName".localiz(), attributes:placeholderAttributes)

        lastNameTextFiledView.nameTextFieldBlock = {[unowned self] text in
            print("text++++\(text)")
            self.userModel.lastname = text
            UserInfoManager.updateUserInfo(self.userModel)
            
        }
        view.addSubview(lastNameTextFiledView)
        lastNameTextFiledView.snp.makeConstraints { (make) in
            make.top.equalTo(firstNameTextFiledView.snp.bottom).offset(20)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(50)
        }
        if isFirstLogin == true {
            userInfoHerderView.isHidenProgress(hidden: false)
            let nextBtn = FDPublicButton()
            nextBtn.publicBtnAction = {[unowned self] in
                
                UserInfoManager.updateUserInfo(self.userModel)
                let vc = GenderViewController()
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
            userInfoHerderView.snp.updateConstraints { (make) in
                make.top.equalToSuperview()
            }
        }
    }
    func bindUI() {
        //MARK:无需移除监听，没有引用循环、一直监听。控制器可以销毁。
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }

}
extension NameViewController {

    @objc func handleTap(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey])! as AnyObject).cgRectValue {

            var firstResponderTextFiledView: FDNameTextFiledView!
            if firstNameTextFiledView.nameTextField.isFirstResponder {
                firstResponderTextFiledView = firstNameTextFiledView
            }else {
                firstResponderTextFiledView = lastNameTextFiledView
            }

            let distanceBetweenTextfielAndKeyboard = self.view.frame.height - firstResponderTextFiledView.bottom - keyboardSize.height
            if distanceBetweenTextfielAndKeyboard < 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }

        }
    }

    @objc func keyboardWillHide(notification: Notification) {

        self.view.frame.origin.y = navigationBarHeight

    }
}
