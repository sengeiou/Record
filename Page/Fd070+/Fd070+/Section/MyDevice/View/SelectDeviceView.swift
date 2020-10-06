//
//  SelectDeviceView.swift
//  FD070+
//
//  Created by WANG DONG on 2018/12/18.
//  Copyright © 2018 WANG DONG. All rights reserved.
//


import UIKit

public typealias didSelectCellBlock = (_ indexPath: IndexPath) -> ()

class SelectDeviceView: UIView,UITableViewDelegate,UITableViewDataSource {

    
    
    let deviceTypeTable:UITableView = UITableView()
    var deviceTableData:Array = [DeviceTypeModel]()
    
    public var didSelctCell : didSelectCellBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        self.initDisplayData()
        self.initDisplayView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initDisplayData() {
        
        for _ in 0 ..< 1 {
            let model = DeviceTypeModel()
            model.deviceName = "F&D HEALTH"
            model.deviceImageName = "Select_device"
            self.deviceTableData.append(model)
        }
        
    }
    
    func initDisplayView() {
        self.addSubview(deviceTypeTable)
        deviceTypeTable.snp.makeConstraints { (maker) in
            maker.top.bottom.equalTo(self)
            maker.left.right.equalTo(self)
        }
        
        deviceTypeTable.backgroundColor = .white
        deviceTypeTable.dataSource=self
        deviceTypeTable.delegate=self
        deviceTypeTable.tableFooterView=UIView()
        deviceTypeTable.register(UITableViewCell.self, forCellReuseIdentifier:"DeviceTypecellId")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.deviceTableData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
 
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"DeviceTypecellId", for: indexPath)

        cell.accessoryType = .disclosureIndicator
        let model  = self.deviceTableData[indexPath.row]
        
        cell.textLabel?.text = model.deviceName
        cell.imageView?.image = UIImage.init(named: model.deviceImageName!)
        
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if didSelctCell != nil {
            didSelctCell!(indexPath)
        }
    }
    
    
    
}
