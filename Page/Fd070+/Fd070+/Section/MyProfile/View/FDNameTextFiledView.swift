//
//  FDNameTextFiledView.swift
//  FD070+
//
//  Created by Payne on 2018/12/17.
//  Copyright © 2018年 WANG DONG. All rights reserved.
//

import UIKit

class FDNameTextFiledView: UIView, UITextFieldDelegate {

    var nameTextField : UITextField!
    
    var nameTextFieldBlock: ((String) -> ())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.hexColor(0xd3d2d2).cgColor
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI(){
        
        nameTextField = UITextField(frame:CGRect(x: 15, y: 0, width: SCREEN_WIDTH - 30, height: 50))
        //        nameTextField.adjustsFontSizeToFitWidth = true //当文字超出文本框宽度时,自动调整文字大小
        nameTextField.minimumFontSize = 13 //最小可缩小的字号
        nameTextField.delegate = self
        nameTextField.font = UIFont.systemFont(ofSize:Font(size:18))
        addSubview(nameTextField)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //收起键盘
        textField.resignFirstResponder()
        //打印出文本框中的值
        print(textField.text as Any)
        //判断闭包,非空时,回调
        if self.nameTextFieldBlock != nil {
            self.nameTextFieldBlock!(textField.text!)
        }
        return true;
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.nameTextFieldBlock != nil {
            self.nameTextFieldBlock!(textField.text!)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else{
            return true
        }
        //这里做输入字数限制，后面根据实际情况再做更改
        let textLength = text.count + string.count - range.length
        if textLength > 30 {
            print("超出30")
        }
        return textLength <= 30
    }

}
