//
//  LaunchingViewController.swift
//  FD070+
//
//  Created by WANG DONG on 2018/12/11.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import UIKit

class LaunchingViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

         self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LoginBtnAction(_ sender: UIButton) {
        
        let selectContry = SelectContryViewController()

        self.navigationController?.pushViewController(selectContry, animated: true)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
