//
//  FDPublicButton.swift
//  FD070+
//
//  Created by Payne on 2018/12/17.
//  Copyright © 2018年 WANG DONG. All rights reserved.
//

import UIKit

class FDPublicButton: UIButton {

    var publicBtnAction: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI(){
    
        self.setTitle("NextStep".localiz(), for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = MainColor
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
        self.addTarget(self, action: #selector(publicButtonClick), for: .touchUpInside)
    }


    /// Set button title. Optional
    ///
    /// - Parameter title: Title string
    func setButtonTitle(_ title: String) {
        self.setTitle(title, for: .normal)
    }

    @objc func publicButtonClick(){
        
        if self.publicBtnAction != nil {
            self.publicBtnAction!()
        }
    }
}
