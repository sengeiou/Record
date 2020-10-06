//
//  WorkOutResultViewController.swift
//  FD070+
//
//  Created by HaiQuan on 2019/3/6.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import UIKit

class WorkOutResultViewController: UIViewController {

    private var workOutResultView: WorkOutResultView!

    var dateString = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        bindUI()

    }
    deinit {
        print("WorkOutResultViewController.deinit")
    }

    private func configUI() {

        view.backgroundColor = MainColor



    }

    private func bindUI() {

    }

}
