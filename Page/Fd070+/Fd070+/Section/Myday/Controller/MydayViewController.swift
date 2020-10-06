//
//  MydayViewController.swift
//  FD070+
//
//  Created by WANG DONG on 2018/12/12.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import UIKit
import FendaBLESwiftLib

class MydayViewController: BaseViewController {
    
    private var headView: MydayHeadView!
    
    private var collectionView: UICollectionView!
    private var summaryLayout: UICollectionViewFlowLayout!
    private var detailLayout: MydayShowDetailDataLayout!
    
    private var chartsView: MydayChartsView?
    
    private var summaryDataSource: [MydayModel]!
    private var detailDataSource: [ChartModel]!
    
    private var didSelectIndex: IndexPath?
    
    public var bledataMana = BleDataManager.instance
    
    //使用时间戳判断，大于3分钟则更新提示一次
    private var isAPPOrDevcieUploading = "0"
    
    private let  refreshController = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        databBindUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        self.bledataMana.currentHandleDeviceModel = try? DeviceInfoDataHelper.findFirstRow(macAddress: CurrentMacAddress) ?? DeviceInfoModel()
        if BleStateManager.getCurrentBleConnectState() == true {
            headView.changeMyHeaderViewDisplay(.HeaderView_Connected_State, (self.bledataMana.currentHandleDeviceModel?.device_name)!)
        }
        else
        {
            
            print(BleStateManager.getConnectedPeripheralMacAddress())
            if BleStateManager.getConnectedPeripheralMacAddress() != "F0:13:C3:FF:FF:FF"
            {
                headView.changeMyHeaderViewDisplay(.HeaderView_Disconnect_State, (self.bledataMana.currentHandleDeviceModel?.device_name)!)
                
            }
            else
            {
                headView.changeMyHeaderViewDisplay(.HeaderView_Unknow_State, "")
            }
        }
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        DispatchQueue.global().async {
            //MARK: 用户打卡信息
            FDUserStatisticsAPIManager.getAppActiveData()
        }
    }
    
    
    private func configUI() {
        
        headView = MydayHeadView.init(type: .myDay)
        view.addSubview(headView)
        headView.snp.makeConstraints { (make) in
            make.top.equalTo(statusBarHeight)
            make.left.right.equalToSuperview()
            make.height.equalTo(44.auto())
        }
        
        headView.didCleckConnectBtn = { (tag,type) in
            
            if BleConnectState.getSystemBleState() == false {
                
                AlertTool.showAlertView(message: "TurnOnSystemBluetooth".localiz(), cancalTitle: "Cancel".localiz(), action: {
                    print("点击了取消按钮")
                })
                return
            }

            switch type {
            case .HeaderView_Unknow_State:
                let vc = DeviceSelectDevcieViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case .HeaderView_Disconnect_State:

                if  BleConnectState.BleReconnectHandle( timeouthandle: {
                    FDCircularProgressLoadTool.shared.dismiss()
                }) {
                    FDCircularProgressLoadTool.shared.show(message: "Connecting".localiz())
                }
                else
                {
                    let vc = DeviceSelectDevcieViewController()
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                break
            default:
                break
            }
            
        }
        
        summaryLayout = UICollectionViewFlowLayout.init()
        
        summaryLayout.sectionInset = UIEdgeInsets.init(top: MydayConstant.collectionCellSpace, left: MydayConstant.collectionCellSpace, bottom: MydayConstant.collectionCellSpace, right: MydayConstant.collectionCellSpace)
        summaryLayout.itemSize = CGSize(width: MydayConstant.collectionCellWidth , height: MydayConstant.collectionCellWidth)
        summaryLayout.minimumInteritemSpacing = CGFloat(MydayConstant.collectionCellSpace * 2)
        summaryLayout.minimumLineSpacing = CGFloat(MydayConstant.collectionCellSpace * 3)
        
        collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: summaryLayout)
        collectionView.backgroundColor = UIColor.clear
        //                                collectionView.backgroundColor = UIColor.yellow
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(headView.snp.bottom)
            make.bottom.equalToSuperview().inset(tabBarHeight)
        }
        
        
        collectionView.register(MydayCollectionViewCell.self, forCellWithReuseIdentifier: MydayConstant.collectionViewCellReuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.addSubview(refreshController)
        
        //refreshController pull down
        refreshController.addTarget(self, action: #selector(pullDownRefreshData), for: .valueChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.bleConnectNotify(notify:)), name: NSNotification.Name.init(rawValue: BLECONNECTSTATE), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.bleSystemSettingNotify(notify:)), name: NSNotification.Name.init(rawValue: SYSTEM_BLUETOOTH_STATE), object: nil)
        
    }
    @objc func pullDownRefreshData(){
        self.refreshController.beginRefreshing()

        //设备重连
        bleReconnectHandle()

        //同步网络数据
        NetworkDataSyncManager.syncMydayData { [unowned self](resutl) in
            self.endRefreshing()
        }
        //没有主动去手环获取数据。运动MyDay数据会主动上传，Workout数据在每次结束后会主动获取一次

        //检测升级
        self.checkVersinInfoHandle()
    }
    private func endRefreshing() {
        if refreshController.isRefreshing {
            refreshController.endRefreshing()
            UIView.animate(withDuration: 0.75, animations: {
                self.collectionView.contentOffset = CGPoint.zero
                
            })
        }
    }
    private func databBindUI() {
        
        self.getData()
        
        //实时数据更新
        MydayManager.realTimeData {[unowned self] (dataSourceDisplay) in
            DispatchQueue.main.async {
                self.showLoadView()
            }
            guard let _ = self.summaryDataSource else {
                return
            }
            
            var reloadIndexPath = [IndexPath]()
            for (index, model) in self.summaryDataSource.enumerated() {
                
                //步数
                if index == 0, model.value != dataSourceDisplay[index].value {
                    self.summaryDataSource[index].value = dataSourceDisplay[index].value
                    self.summaryDataSource[index].progress = dataSourceDisplay[index].progress
                    reloadIndexPath.append(IndexPath.init(item: index, section: 0))
                    //目标
                }else if index == 1, model.value != dataSourceDisplay[index].value, let modelDisplay = dataSourceDisplay[safe: index] {


                    self.summaryDataSource[index].value = modelDisplay.value
                    self.summaryDataSource[index].progress = dataSourceDisplay[index].progress
                    reloadIndexPath.append(IndexPath.init(item: index, section: 0))
                    //睡眠时间
                }else if index == 3, model.value != dataSourceDisplay[index].value {
                    self.summaryDataSource[index].value = dataSourceDisplay[index].value
                    self.summaryDataSource[index].progress = dataSourceDisplay[index].progress
                    reloadIndexPath.append(IndexPath.init(item: index, section: 0))
                    //卡路里
                }else if index == 4, model.value != dataSourceDisplay[index].value {
                    self.summaryDataSource[index].value = dataSourceDisplay[index].value
                    self.summaryDataSource[index].progress = dataSourceDisplay[index].progress
                    reloadIndexPath.append(IndexPath.init(item: index, section: 0))
                    //距离
                }else if index == 5, model.value != dataSourceDisplay[index].value {
                    self.summaryDataSource[index].value = dataSourceDisplay[index].value
                    self.summaryDataSource[index].progress = dataSourceDisplay[index].progress
                    reloadIndexPath.append(IndexPath.init(item: index, section: 0))
                    //睡眠时间
                }else if index == 7, model.value != dataSourceDisplay[index].value {
                    self.summaryDataSource[index].value = dataSourceDisplay[index].value
                    self.summaryDataSource[index].progress = dataSourceDisplay[index].progress
                    reloadIndexPath.append(IndexPath.init(item: index, section: 0))
                }
                
            }
            
            if reloadIndexPath.count > 0 {
                //That is not in main thread
                DispatchQueue.main.async {
                    self.collectionView.reloadItems(at: reloadIndexPath)
                    
                }
            }
            //将数据上传到网络
            NetworkDataSyncManager.realTimeUploadData()
            
        }
        
        /// Monitoring table update..........
        let _ = NotificationCenter.default.rx.notification(custom: .DBTableUpdate)
            .takeUntil(self.rx.deallocated)
            .subscribe({ [weak self] notification in
                //数据库有变化，更新数据显示
                let tableName = notification.element?.object as? TableNameEnum
                switch tableName {
                case  .userinfo?,.bloodsugar_result?, .daily_detail?, .device_info?:
                    self?.getData()
                default:
                    break
                }
            })
        
        /// Monitoring application significant timeChange
        let _ = NotificationCenter.default.rx.notification(Notification.Name.UIApplicationSignificantTimeChange)
            .takeUntil(self.rx.deallocated)
            .subscribe({notification in
                
                print("UIApplicationSignificantTimeChange")
            })
        
        
        
        //数据库更新检测
        SQLiteDataStore.sharedInstance!.monitorTableUpdateHook()

        //设备重连
        bleReconnectHandle()
        
    }
    
    /// 检测版本相关信息
    func checkVersinInfoHandle() {
        
        if FDReachability.shared.reachability == false {
            FDLog("网络链接失败")
            return
        }
        
        
        //        if Int(FDDateHandleTool.timeStamp)! - Int(self.isAPPOrDevcieUploading)! < FDUploadTools.uploadCheckTimeInterval {
        //            return
        //        }

        isAPPOrDevcieUploading = FDDateHandleTool.timeStamp
        FDUploadTools.checkApplicationInfo { (respondDic, isUpload) in
            
            if isUpload == false { //请求失败
                self.isAPPOrDevcieUploading = "0"
                return
            }

            if let APPVersion:String = (respondDic[FDUploadTools.APPServerVersion] as? String), let url:String = respondDic[FDUploadTools.APPDownloadUrl] as? String {
                
                //需要APP升级了
                if APPVersion > FDAppInfoManager.getMajorVersion() {
                    DispatchQueue.main.async {
                        AlertTool.showAlertView(title: "MydayVC_appUpgrade_point".localiz(), message:"\("MydayVC_appUpgrade_message".localiz())\n版本号：\(APPVersion)", action: { (index) in
                            self.isAPPOrDevcieUploading = "0"
                            if index == 0 {
                                
                                let url:URL = URL.init(string:FDAppInfoManager.ITMSSERVICESURl+url)!
                                
                                UIApplication.shared.openURL(url)
                            }
                        })
                    }
                }
                else if BleStateManager.getCurrentBleConnectState() { //APP不需要升级时再检测固件升级信息
                    
                    FDUploadTools.checkBleInfoByMac(returnBlock: { (respondDic, isUpload) in
                        DispatchQueue.main.async {
                            FDLog(respondDic)
                            if isUpload {
                                if let bleVersion = respondDic[FDUploadTools.BleServerVersion] as? String ,let bleCurrentVersion = UserDefaults.DeviceInfoUserDefault.Device_SoftVersion.storedValue as? String {
                                    
                                    if bleVersion > bleCurrentVersion {
                                        let messageOne = "MydayVC_appUpgrade_messageOne".localiz()
                                        let messageTwo = "MydayVC_appUpgrade_messageTwo".localiz()
                                        
                                        AlertTool.showAlertView(title: "MydayVC_appUpgrade_point".localiz(), message:messageOne + "\(bleVersion)" + messageTwo, action: { (index) in
                                            self.isAPPOrDevcieUploading = "0"
                                            if index == 0 {
                                                
                                                BleOTAManager.init().startOtaInteraction()
                                                FDLog("开始升级设备")
                                            }
                                        })
                                    }
                                }
                            }else {
                                
                                FDLog("下载蓝牙升级文件失败")
                            }
                            
                        }
                    })
                    
                }
            }
            else
            {
                self.isAPPOrDevcieUploading = "0"
                FDLog("APP升级信息为空")
            }
            
        }
        
    }

    
    @objc func bleConnectNotify(notify:Notification){
        let bleState = notify.object as! NSNumber
        FDLog("ble state changed: \(bleState)")
        DispatchQueue.main.async {
            if bleState.boolValue == true {
                FDCircularProgressLoadTool.shared.dismiss()
                self.headView.changeMyHeaderViewDisplay(.HeaderView_Connected_State, (self.bledataMana.currentHandleDeviceModel?.device_name)!)
            }
            else
            {
                self.headView.changeMyHeaderViewDisplay(.HeaderView_Disconnect_State, (self.bledataMana.currentHandleDeviceModel?.device_name) ?? "")
                
            }
        }
    }
    
    @objc func bleSystemSettingNotify(notify:Notification){
        let bleState = notify.object as! NSNumber
        FDLog("System ble state changed: \(bleState)")
        DispatchQueue.main.async {
            if bleState.boolValue == true {
                
                self.bleReconnectHandle()
            }
            else
            {
                self.bledataMana.bleOperationMana.disConnectCertainPeripheral(isAutoReconnect: true)
                self.headView.changeMyHeaderViewDisplay(.HeaderView_Disconnect_State, (self.bledataMana.currentHandleDeviceModel?.device_name) ?? "")
                
            }
        }
    }
    
    func showLoadView() {
        
        if UserDefaults.BLEDataSyncFlag.isDataSyncingKey.storedBool {

            FDCircularProgressLoadTool.shared.show(message: "Myday_BLEDataSynchro".localiz())
        }else {

            FDCircularProgressLoadTool.shared.dismiss()
        }
        
        UserDefaults.BLEDataSyncFlag.isDataSyncingKey.store(value: false)
    }
    
    
}
// MARK: - UICollectionView delegate. UICollectionView dataSource
extension MydayViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let _ =  summaryDataSource else {
            return 0
        }
        return  summaryDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MydayConstant.collectionViewCellReuseIdentifier, for: indexPath) as! MydayCollectionViewCell
        
        cell.mydayModel = summaryDataSource[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectCell = collectionView.cellForItem(at: indexPath)
        guard let cell = selectCell else {
            return
        }
        
        let model = summaryDataSource[indexPath.row]
        if didSelectIndex == indexPath{
            if chartsView == nil {
                openLayout(cell: cell, model: model, index: indexPath)
            }else {
                closeLayout()
            }
        }else {
            openLayout(cell: cell, model: model, index: indexPath)
        }
        didSelectIndex = indexPath
        
        
        //测试cell显示动画
        //        if indexPath.row == 2 {
        //              removerHeatRateAnimation()
        //        }else if indexPath.row == 3  {
        //              addHeatRateAnimation()
        //        }else if indexPath.row == 4  {
        //            addBloodSugarAnimation()
        //        }else if indexPath.row == 5  {
        //            removerBloodSugarAnimation()
        //        }
        
        
    }
    
}

// MARK: - Show or  hide subView
extension MydayViewController {
    
    func showChartsView(_ cell: UICollectionViewCell,_ model: MydayModel, _ index: IndexPath) {
        
        if let _ = chartsView {
            self.chartsView?.removeFromSuperview()
            self.chartsView = nil
        }
        
        let rectInCollectionView = collectionView.convert(cell.frame, to: collectionView)
        chartsView = MydayChartsView.init(frame: CGRect.init(x: 0, y: rectInCollectionView.maxY + 10.auto(), width: SCREEN_WIDTH, height: MydayConstant.chartViewHeight))
        
        chartsView?.model = detailDataSource[index.row]
        
        //Is show sleepView
        if index.row == 5 {
            chartsViewAddSleepDetailView()
        }
        
        UIView.animate(withDuration: 0.5) {
            self.chartsView?.alpha = 1
            self.collectionView.addSubview(self.chartsView!)
            
        }
        
        let chartsViewBottom = chartsView!.bottom
        let superViewBottom = collectionView.bottom
        print(chartsViewBottom)
        print(superViewBottom)
        if chartsViewBottom > superViewBottom, index == didSelectIndex {
            let beyondHeight = collectionView.bottom - (chartsView?.bottom)!
            let point = CGPoint.init(x: 0, y: -beyondHeight + navigationBarHeight + MydayConstant.collectionCellSpace * 8)
            collectionView.setContentOffset(point, animated: true)
            
        }
        
        chartsView?.bloodSugarTestClosure = {[unowned self] in
            let VC = BloodSugarTestViewController()
            VC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(VC, animated: true)
        }
        
    }
    
    func openLayout(cell: UICollectionViewCell, model: MydayModel, index: IndexPath) {
        
        self.collectionView.collectionViewLayout.invalidateLayout()
        detailLayout = MydayShowDetailDataLayout.init(indexSlected: index.row)
        collectionView.setCollectionViewLayout(detailLayout!, animated: false)
        
        showChartsView(cell, model, index)
    }
    
    func closeLayout() {
        self.collectionView.collectionViewLayout.invalidateLayout()
        collectionView.setCollectionViewLayout(summaryLayout, animated: false)
        
        UIView.animate(withDuration: 0.5) {
            self.chartsView?.alpha = 0
            self.chartsView?.removeFromSuperview()
            self.chartsView = nil
        }
    }
}

// MARK: - Sleep view
extension MydayViewController {
    private func chartsViewAddSleepDetailView() {
        
        let sleepColors = [ UIColor.RGB(r: 255, g: 244, b: 150),
                            UIColor.RGB(r: 254, g: 210, b: 10),
                            UIColor.RGB(r: 252, g: 116, b: 8)]
        
        let sleepDetailData = FDSleepDetailHelp.findSleepDetailData(FDDateHandleTool.getCurrentDate(dateType: "yyyy/MM/dd"))
        
        let sleepDetailSummaryModel = FDSleepDetailManager.getSleepSectionData(sleepDetailData)
        let historySleepDetailChartsView = FDSleepDetailView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: chartsView!.height), sleepModel: sleepDetailSummaryModel, viewColor: sleepColors, isShowSliderView: false)
        chartsView?.addSubview(historySleepDetailChartsView)
        
    }
}
// MARK: - Database data
extension MydayViewController {
    
    private func getData() {
        
        //获取默认数据
        //                MydayManager.getDefaultCurrentData(dayModelCompletion: { (mydayModelArray) in
        //从数据库中取得数据
        MydayManager.getCurrentMydatData(dayModelCompletion: { (mydayModelArray) in
            
            if let _ = self.summaryDataSource, self.summaryDataSource.count == 8 {
                self.summaryDataSource.removeAll()
                //                print(" self.summaryDataSource.removeAll()")
            }
            
            self.summaryDataSource = mydayModelArray
            UIView.performWithoutAnimation {
                self.collectionView.reloadData()
            }
            
        }) { (chartModelArray) in
            self.detailDataSource = chartModelArray
            if let chartsViewDispaly = self.chartsView, let selectIndexDisplay = self.didSelectIndex {
                chartsViewDispaly.model = self.detailDataSource[selectIndexDisplay.row]
                
            }
            
        }
    }
    
}

// MARK: - Handle BLE
extension MydayViewController {

    func bleReconnectHandle() {

        if BleConnectState.BleReconnectHandle( timeouthandle: {
            FDCircularProgressLoadTool.shared.dismiss()
        }) {
            FDCircularProgressLoadTool.shared.show(message: "Connecting".localiz())
        }
    }
}
// MARK: - Cells animation
extension MydayViewController {
    
    func addHeatRateAnimation() {
        
        let cell = collectionView.cellForItem(at: IndexPath.init(row: 7, section: 0))
        guard let reuseCell = cell else {
            return
        }
        let heatRateCell = reuseCell as! MydayCollectionViewCell
        heatRateCell.addHeatRateAnimation()
        
    }
    
    func removerHeatRateAnimation() {
        
        let cell = collectionView.cellForItem(at: IndexPath.init(row: 7, section: 0))
        guard let reuseCell = cell else {
            return
        }
        let heatRateCell = reuseCell as! MydayCollectionViewCell
        heatRateCell.removerHeatRateAnimation()
        
    }
    
    func addBloodSugarAnimation() {
        
        let cell = collectionView.cellForItem(at: IndexPath.init(row: 6, section: 0))
        guard let reuseCell = cell else {
            return
        }
        let bloodSugarCell = reuseCell as! MydayCollectionViewCell
        //        bloodSugarCell.boodSugarDonutView.addIndicatorLayerAnimation()
        
        
    }
    
    func removerBloodSugarAnimation() {
        
        let cell = collectionView.cellForItem(at: IndexPath.init(row: 6, section: 0))
        guard let reuseCell = cell else {
            return
        }
        let bloodSugarCell = reuseCell as! MydayCollectionViewCell
        //        bloodSugarCell.boodSugarDonutView.removeIndicatorLayerAnimation()
        
        
    }
    
}
