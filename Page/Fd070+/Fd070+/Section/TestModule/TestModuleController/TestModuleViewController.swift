//
//  TestModuleViewController.swift
//  FD070+
//
//  Created by HaiQuan on 2018/12/25.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import UIKit
import SwiftyJSON
import CryptoSwift

class TestModuleViewController: BaseViewController {


    let testTableView:UITableView = UITableView()
    var testTableDataSource = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
    }
    
    
    override func initDisplayData() {
        testTableDataSource = ["网络接口","蓝牙接口","数据库接口","UI测试"]
    }
    
    override func initDisplayView() {
        self.view.addSubview(testTableView)
        testTableView.snp.makeConstraints { (maker) in
            maker.top.bottom.equalTo(self.view)
            maker.left.right.equalTo(self.view)
        }
        
        testTableView.register(UITableViewCell.self, forCellReuseIdentifier: "TestModulecellId")
        testTableView.delegate = self
        testTableView.dataSource = self
    }

}


extension TestModuleViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.testTableDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier:"TestModulecellId", for: indexPath)
        
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = self.testTableDataSource[indexPath.row]
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.navigationController?.pushViewController(NetworkTestModuleViewController(), animated: true)
            break
        case 1:
            self.navigationController?.pushViewController(BleTestViewController(), animated: true)
            break
        case 2:
            self.navigationController?.pushViewController(DBTestViewController(), animated: true)
            break
        case 3:
            self.navigationController?.pushViewController(UITestViewController(), animated: true)
//             self.navigationController?.pushViewController( TestViewController(), animated: true)

        default:
            break
        }
    }
    
}
