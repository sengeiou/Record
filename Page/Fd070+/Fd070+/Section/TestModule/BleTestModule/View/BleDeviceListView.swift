//
//  BleDeviceListView.swift
//  BLESwiftModule
//
//  Created by WANG DONG on 2017/7/26.
//  Copyright © 2017年 WANG DONG. All rights reserved.
//

import UIKit
import CoreBluetooth
class BleDeviceListView: UIView {

    fileprivate struct Constant {
        static let cellHeight: CGFloat = 80
        static let margin: CGFloat = 20
        static let rippleViewHeight: CGFloat = (SCREEN_HEIGHT * 1) / 4

        static let centBGColor = UIColor.hexColor(0xD65324)
        static let firstCircleColor = UIColor.hexColor(0xFF8356)
        static let secondCircleColor = UIColor.hexColor(0xEF764E)
        static let thirdCircleColor = UIColor.hexColor(0xE66940)

        static let pulsingCount = 5
        static let borderWidth: CGFloat = 5

    }

    public var deviceList:Array<Any> = Array.init()
    public var peripheralMacDic:Dictionary<String, Any>! = Dictionary.init()
    public var peripheralNameDic:Dictionary<String, Any>! = Dictionary.init()
    public var peripheralRssiDic:Dictionary<String, Any>! = Dictionary.init()
    public typealias connectSelectDeviceBlock = (_ selectPeripheral:CBPeripheral)->()
    public var selectConnectDevice:connectSelectDeviceBlock?

    var reSearchClosure: ((Bool) ->())?

    let contentView = UIView().then() {
        $0.backgroundColor = .white
    }

    let refreshBtn = UIButton().then() {
        $0.setBackgroundImage(UIImage.init(named: "refreshBG_searchDeice"), for: .normal)
        $0.setImage(UIImage.init(named: "refreshArrow_searchDeice"), for: .normal)
    }

    var tableView = UITableView().then() {
        $0.tableFooterView = UIView()
        //reSet separator inset
        $0.separatorInset = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)
    }


    var viewHeight: CGFloat = 100
    var scanTime: Timer?
    var centImagView = UIImageView.init(image: UIImage.init(named: "mainBLE_searchDeice"))
//    let pulsator = Pulsator()

    var centViewRect: CGRect {
        get {
            let imageWidth: CGFloat = 80

            let ovalX = (SCREEN_WIDTH - imageWidth) / 2
            let ovalY: CGFloat = 40

            return CGRect.init(x: ovalX, y: ovalY, width: imageWidth, height: imageWidth)
        }
    }
    var centViewLayerRect: CGRect {
        get {
            let imageWidth: CGFloat = 86

            let ovalX = (SCREEN_WIDTH - imageWidth) / 2
            let ovalY: CGFloat = 37

            return CGRect.init(x: ovalX, y: ovalY, width: imageWidth, height: imageWidth)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
        dataBindUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {

    }

    private func configUI() {
        //        add centImageView
        centImagView.frame = centViewRect
        centImagView.contentMode = .scaleAspectFit
        centImagView.image = UIImage.init(named: "mainBLE_searchDeice")
        addSubview(centImagView)
        //        addd centImagerView layer
        let path = UIBezierPath.init(ovalIn: centViewLayerRect)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = Constant.borderWidth
        shapeLayer.strokeColor = Constant.firstCircleColor.cgColor
        shapeLayer.fillColor = Constant.centBGColor.cgColor
        layer.insertSublayer(shapeLayer, below: centImagView.layer)
        //        add pulsator
//        pulsator.position = centImagView .layer.position
//        layer.insertSublayer(pulsator, below: shapeLayer)
        //        add contentView. contentView is rounded rectangle view
        addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(centImagView.snp.bottom).offset(40)
            make.left.bottom.right.equalToSuperview()
        }
        //        add tableview
        contentView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-Constant.cellHeight + 10)

        }

        //        add refresh Button
        contentView.addSubview(refreshBtn)
        refreshBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)

        }
    }
    private func dataBindUI() {

        setUpPulser()
        //        set contentView layer cornerRadius
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        //        set tableView delegate
        tableView.delegate = self
        tableView.dataSource = self

        refreshBtn.addTarget(self, action: #selector(refreshBtnClick(_:)), for: .touchUpInside)

    }
    @objc func dismisAction() {
        self.removeFromSuperview()
    }
    @objc func scanFinishHandle() {
        if scanTime != nil {
            scanTime?.invalidate()
            scanTime = nil
        }

        //scan finish
        if reSearchClosure != nil {
            reSearchClosure!(true)
        }

        stopAnimation()

    }
    @objc func refreshBtnClick(_ sender: UIButton) {

        self.scanTime = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(scanFinishHandle), userInfo: nil, repeats: false)



        startAnimation()

        //scan start
        if reSearchClosure != nil {
            reSearchClosure!(false)
        }

    }

    func HightAdaptive(_ deviceCount: Int) {

        let otherHeigth = Constant.rippleViewHeight + Constant.cellHeight

        let tableViewHeigth = CGFloat(deviceCount) * Constant.cellHeight
        let tableViwHeightMax = SCREEN_HEIGHT - 20 - otherHeigth

        let tableViewHeigthActual = tableViewHeigth > tableViwHeightMax ? tableViwHeightMax : tableViewHeigth
        viewHeight =  tableViewHeigthActual + otherHeigth

        tableView.snp.remakeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-Constant.cellHeight + 10)

        }

    }

}

// MARK: - pulsator layer func
extension BleDeviceListView {
    func startAnimation() {


    }
    private func setUpPulser() {

    }
    func stopAnimation() {


    }

    private func refreshBtnStartAnimation() {
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2 * Double.pi
        anim.repeatCount = MAXFLOAT
        anim.duration = 1
        anim.isRemovedOnCompletion = true
        refreshBtn.imageView?.layer.add(anim, forKey: nil)
    }
    private func refreshBtnStopAnimation() {
        refreshBtn.imageView?.layer.removeAllAnimations()
    }


}

// MARK: - tableview delegate
extension BleDeviceListView: UITableViewDelegate,UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let deviceCount = deviceList.count

        if deviceCount > 0 {
            HightAdaptive(deviceCount)
            return deviceCount
        }
        return 0

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if (cell == nil) {
            cell = UITableViewCell.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        }

        for superview:UIView in (cell?.contentView.subviews)! {
            superview.removeFromSuperview()
        }

        let BLEMarkImagView = UIImageView.init(image: UIImage.init(named: "leftBLE_searchDeice"))
        cell?.contentView.addSubview(BLEMarkImagView)
        BLEMarkImagView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(10)
        }


        let peripheral:CBPeripheral = deviceList[indexPath.row] as! CBPeripheral

        let deviceNameLabel = UILabel()
//        deviceNameLabel.font = UIFont.init(name: OTFFontName.KlavikaLightCondensed.fontName, size: Font(size:15))!
        deviceNameLabel.text = peripheralNameDic[peripheral.identifier.uuidString] as? String
        cell?.contentView.addSubview(deviceNameLabel)
        deviceNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(BLEMarkImagView.snp.right).offset(Constant.margin)
            make.bottom.equalTo((cell?.contentView.snp.centerY)!).offset(-1)
        }
        
        
        let macAddressLabel = UILabel()
//        macAddressLabel.font = UIFont.init(name: OTFFontName.KlavikaMediumCondensed.fontName, size: Font(size:22))!

        var macAddressStr = peripheralMacDic[peripheral.identifier.uuidString] as? String
        let macArray:Array = (macAddressStr?.components(separatedBy: "--"))!
        if macArray.count > 1 {
            macAddressStr = macArray[1].count > 0 ?  macArray[1]:macArray[0]
        }
        macAddressLabel.text = macAddressStr
        cell?.contentView.addSubview(macAddressLabel)
        macAddressLabel.snp.makeConstraints { (make) in
            make.left.equalTo(deviceNameLabel.snp.left)
            make.top.equalTo((cell?.contentView.snp.centerY)!).offset(1)
        }

        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constant.cellHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if self.selectConnectDevice != nil {
            let peripheral:CBPeripheral = self.deviceList[indexPath.row] as! CBPeripheral
            self.selectConnectDevice!(peripheral)
            self.removeFromSuperview()
        }
    }

}

