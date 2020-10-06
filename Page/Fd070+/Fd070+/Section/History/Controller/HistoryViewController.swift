//
//  HistoryViewController.swift
//  FD070+
//
//  Created by WANG DONG on 2018/12/12.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import UIKit
import FendaBLESwiftLib

class HistoryViewController: BaseViewController {
    
    private struct Constant {
        
        static let segmentedControlMargin: CGFloat = 10.auto()
        
        static let segmentedSelectedMainColor = UIColor.RGB(r: 110, g: 184, b: 226)
        static let segmentedHeight: CGFloat = 40.auto()
        static let hearRateImageViewHeight: CGFloat = 100.auto()
        static let collectionViewCellReuseIdentifier = "HistoryViewController.MydayCollectionViewCell"
    }
    
    private var currentDateStr = FDDateHandleTool.getCurrentDate(dateType: "yyyy/MM/dd")
    
    private var sumDataCharsViewHeight: CGFloat = 0
    private var sumDataCharsViewY: CGFloat = 0
    
    private var dayDataCharsViewHeight: CGFloat = 0
    private var dayDataCharsViewY: CGFloat = 0
    
    private var headView: MydayHeadView!
    private var bledataMana = BleDataManager.instance
    
    private var segmentedControl: UISegmentedControl!
    
    private var collectionView: UICollectionView!
    private var layout: UICollectionViewFlowLayout!
    private var dataSource = HistoryManager.getCurrentDayDataModel(nil)
    
    private var selectedRow = 0
    
    private var historyCalendarView: HistroyCalendarView?
    
    private var historySportChartsView: HistorySportChartsView!
    
    private var historySleepDetailChartsView: FDSleepDetailView!
    
    private var historyHeartRateChartsView: HistoryHeartRateChartsView!
    private var historyBloodSugarChartsView: HistoryBloodSugarChartsView!
    
    private var swipeGestureRecognizerView: UIView!
    
    
    private var leftIndicatorImageView: UIImageView!
    private var rightIndicatorImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        databBindUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.bledataMana.currentHandleDeviceModel = try! DeviceInfoDataHelper.findFirstRow(macAddress: CurrentMacAddress) ?? DeviceInfoModel()
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
    
    private func configUI() {
        
        //头部视图
        headView = MydayHeadView.init(type: .history)
        view.addSubview(headView)
        headView.snp.makeConstraints { (make) in
            make.top.equalTo(statusBarHeight)
            make.left.right.equalToSuperview()
            make.height.equalTo(44.auto())
        }
        
        //segmented 视图
        segmentedControl = UISegmentedControl(items:["HistoryVC_segmentTitle_day".localiz(),
                                                     "HistoryVC_segmentTitle_month".localiz(),
                                                     "HistoryVC_segmentTitle_year".localiz()])
        
        
        segmentedControl.tintColor = Constant.segmentedSelectedMainColor
        segmentedControl.selectedSegmentIndex = 0
        let normalTextAttributes: [NSAttributedStringKey : AnyObject] = [
            NSAttributedStringKey.foregroundColor : UIColor.white,
            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 18.auto())
        ]
        let selectedTextAttributes: [NSAttributedStringKey : AnyObject] = [
            NSAttributedStringKey.foregroundColor : MainColor,
            NSAttributedStringKey.font :UIFont.systemFont(ofSize: 18.auto())
        ]
        
        segmentedControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        
        view.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { (make) in
            make.left.equalTo(Constant.segmentedControlMargin)
            make.right.equalTo(-Constant.segmentedControlMargin)
            make.top.equalTo(headView.snp.bottom)
            make.height.equalTo(Constant.segmentedHeight)
            
        }
        
        view.layoutSubviews()
        
        sumDataCharsViewY = segmentedControl.bottom + 5.auto()
        dayDataCharsViewY = headView.bottom
        
        sumDataCharsViewHeight = self.view.height - MydayConstant.collectionCellWidth - segmentedControl.bottom - tabBarHeight
        dayDataCharsViewHeight = self.view.height - MydayConstant.collectionCellWidth - headView.bottom - tabBarHeight
        
        segmentedControl.layer.borderColor = UIColor.white.cgColor
        segmentedControl.layer.borderWidth = 1
        segmentedControl.backgroundColor = UIColor.clear
        segmentedControl.layer.cornerRadius = CGFloat(Constant.segmentedHeight/4)
        segmentedControl.layer.masksToBounds = true
        
        
        print(sumDataCharsViewHeight)
        //添加图表视图们
        addChartsViews()
        
        //设置Collectionview的Layout
        layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets.init(top: MydayConstant.collectionCellSpace, left: MydayConstant.collectionCellSpace, bottom: MydayConstant.collectionCellSpace, right: MydayConstant.collectionCellSpace)
        layout.itemSize = CGSize(width: MydayConstant.collectionCellWidth , height: MydayConstant.collectionCellWidth)
        
        //添加Collectionview 到Scroller
        collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y:segmentedControl.bottom + sumDataCharsViewHeight, width: SCREEN_WIDTH, height: MydayConstant.collectionCellWidth), collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        //        collectionView.backgroundColor = UIColor.randomColor
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MydayCollectionViewCell.self, forCellWithReuseIdentifier: Constant.collectionViewCellReuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        view.insertSubview(collectionView, at: 0)
        
        leftIndicatorImageView = UIImageView.init(image: UIImage.init(named: "back04_icon"))
        view.addSubview(leftIndicatorImageView)
        leftIndicatorImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(3)
            make.centerY.equalTo(self.collectionView.snp.centerY)
        }
        
        rightIndicatorImageView = UIImageView.init(image: UIImage.init(named: "back01_icon"))
        view.addSubview(rightIndicatorImageView)
        rightIndicatorImageView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(3)
            make.centerY.equalTo(self.collectionView.snp.centerY)
        }
        
        leftIndicatorImageView.isHidden = true
        rightIndicatorImageView.isHidden = false
    }
    
    private func databBindUI() {
        
        //Segmented 的Target
        segmentedControl.addTarget(self, action: #selector(self.segmentedControlSelected), for: .valueChanged)
        view.layoutSubviews()
        
        //设置默认的运动图表
        setSportChartsData(.current)
        
        //头部视图的日历的点击事件
        headView.didCleckTypeBtn = {[unowned self] in
            
            if let _ = self.historyCalendarView,self.view.subviews.contains(self.historyCalendarView!) {
                self.historyCalendarView!.removeFromSuperview()
                self.historyCalendarView = nil
            }else {
                
                self.historyCalendarView = HistroyCalendarView.init(frame: CGRect.init(x: 0, y: statusBarHeight, width: SCREEN_WIDTH, height: self.sumDataCharsViewHeight + 80.auto()))
                let histroyCalendarModel = HistroyCalendarManager.getHistroyCalendarModel()
                
                self.historyCalendarView?.histroyCalendarModel = histroyCalendarModel!
                self.historyCalendarView!.alpha = 0
                UIView.animate(withDuration: 0.35, animations: {
                    self.historyCalendarView!.alpha = 1
                    self.view.addSubview(self.historyCalendarView!)
                })
                
                //选中了日期
                self.historyCalendarView?.selectedDateStrBlock = {(dateStr: String) in
                    
                    self.segmentedControl.selectedSegmentIndex = 0
                    self.setSportChartsData(.current, dateStr)
                    
                    self.currentDateStr = dateStr
                    //查询点击日期的天汇总数据
                    let queryTimestamp = FDDateHandleTool.dateStringToTimeStamp(stringTime: dateStr, timeForm: "yyyy/MM/dd")
                    self.dataSource = HistoryManager.getCurrentDayDataModel(queryTimestamp)
                    self.collectionView.reloadData()
                }
            }
            
        }
        
        //头部视图整体的点击事件
        headView.didCleckConnectBtn = { [unowned self] (tag,type) in
            
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
        
        //BLE state observer
        NotificationCenter.default.addObserver(self, selector: #selector(self.bleConnectNotify(notify:)), name: NSNotification.Name.init(rawValue: BLECONNECTSTATE), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.bleSystemSettingNotify(notify:)), name: NSNotification.Name.init(rawValue: SYSTEM_BLUETOOTH_STATE), object: nil)
        
        /// Monitoring table update..........
        let _ = NotificationCenter.default.rx.notification(custom: .DBTableUpdate)
            .takeUntil(self.rx.deallocated)
            .subscribe({ [weak self] notification in
                //数据库有变化，更新数据显示
                let tableName = notification.element?.object as? TableNameEnum
                switch tableName {
                case  .userinfo?, .daily_detail?, .current?:
                    self?.dataSource = HistoryManager.getCurrentDayDataModel(nil)
                    self?.collectionView.reloadData()
                default:
                    break
                }
            })
    }
    
    /// Handle swipGes
    ///
    /// - Parameter swip: swipGes event
    @objc func swipAction(swip:UISwipeGestureRecognizer) -> Void {
        
        
        switch selectedRow {
        case 5:
            //点击了睡眠的Cell
            if swip.direction == .right {
                setSleepDetailChartsData(.ahead)
            }else {
                setSleepDetailChartsData(.next)
            }
            break
        case 6:
            //点击了血糖的Cell
            if swip.direction == .right {
                setBloodSugarChartsData(.ahead)
            }else {
                setBloodSugarChartsData(.next)
            }
            break
        case 7:
            //点击了心率的Cell
            if swip.direction == .right {
                setHeartRateChartsData(.ahead)
            }else {
                setHeartRateChartsData(.next)
            }
            break
        default:
            //点击了运动的Cell
            if swip.direction == .right {
                setSportChartsData(.ahead)
            }else {
                setSportChartsData(.next)
            }
            break
        }
        
    }
    
    @objc func segmentedControlSelected(segmentedControl: UISegmentedControl) {
        if selectedRow < 5 {
            //点击了运动的Cell
            setSportChartsData(.current)
        }else {
            //点击了睡眠的Cell
            setSleepDetailChartsData(.current)
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
        FDLog("ble state changed: \(bleState)")
        DispatchQueue.main.async {
            if bleState.boolValue == true {
                
                if  BleConnectState.BleReconnectHandle( timeouthandle: {
                    FDCircularProgressLoadTool.shared.dismiss()
                }) {
                    FDCircularProgressLoadTool.shared.show(message: "Connecting".localiz())
                }
            }
            else
            {
                self.bledataMana.bleOperationMana.disConnectCertainPeripheral(isAutoReconnect: true)
                self.headView.changeMyHeaderViewDisplay(.HeaderView_Disconnect_State, (self.bledataMana.currentHandleDeviceModel?.device_name) ?? "")
                
            }
        }
    }
    
    
}

// MARK: - UICollectionView delegate. UICollectionView dataSource
extension HistoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.collectionViewCellReuseIdentifier, for: indexPath) as! MydayCollectionViewCell
        
        cell.mydayModel = dataSource[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //可能日历视图已经添加到了View
        if let _ = self.historyCalendarView, self.view.subviews.contains(self.historyCalendarView!) {
            self.historyCalendarView!.removeFromSuperview()
            self.historyCalendarView = nil
        }
        
        selectedRow = indexPath.row
        
        switch selectedRow {
        case 5:
            //显示睡眠图表
            segmentedControl.isHidden = false
            setSleepDetailChartsData(.current)
            
        case 6:
            //显示血糖图表
            segmentedControl.isHidden = true
            setBloodSugarChartsData(.current)
            
        case 7:
            //显示心率图表
            segmentedControl.isHidden = true
            setHeartRateChartsData(.current)
        default:
            //显示运动图表
            segmentedControl.isHidden = false
            setSportChartsData(.current)
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (scrollView.contentOffset.x >= (scrollView.contentSize.width - scrollView.frame.size.width - 50)) {
            //reach right
            leftIndicatorImageView.isHidden = false
            rightIndicatorImageView.isHidden = true
            
        }
        
        if (scrollView.contentOffset.x <= 0){
            //reach left
            leftIndicatorImageView.isHidden = true
            rightIndicatorImageView.isHidden = false
        }
        
        if (scrollView.contentOffset.x > 0 && scrollView.contentOffset.x < (scrollView.contentSize.width - scrollView.frame.size.width - 50)){
            //not left and not right
            leftIndicatorImageView.isHidden = false
            rightIndicatorImageView.isHidden = false
        }
    }
    
}

// MARK: - Set charts data
extension HistoryViewController {
    
    
    func setSleepDetailChartsData(_ type : FDSleepLoadDataDirectionType,_ specifyDateStr: String? = nil) {
        
        
        var summaryType = HistorySportSummaryType.day
        
        if segmentedControl.selectedSegmentIndex == 0 {
            summaryType = .day
        }else if segmentedControl.selectedSegmentIndex == 1 {
            summaryType = .month
        }else if segmentedControl.selectedSegmentIndex == 2 {
            summaryType = .year
        }
        
        
        let queryStr = FDSleepDetailManager.getSleepQueryDateStr(summaryType: summaryType, loadDataDirectionType: type, specifyDateStr: "")
        
        removeChartsView()
        
        
        var sleepDetailSummaryModel: FDSleepDetailSummaryModel!
        var sleepMonthSummaryModel: FDSleepMonthSummaryModel!
        if segmentedControl.selectedSegmentIndex == 0 {
            summaryType = .day
            sleepDetailSummaryModel = FDSleepDetailManager.getSleepSectionData(FDSleepDetailHelp.findSleepDetailData(queryStr))
        }else if segmentedControl.selectedSegmentIndex == 1 {
            summaryType = .month
            sleepMonthSummaryModel = FDSleepDetailHelp.getSleepMonthDataFromDB(queryStr)
        }else if segmentedControl.selectedSegmentIndex == 2 {
            summaryType = .year
            sleepMonthSummaryModel = FDSleepDetailHelp.getSleepYeaDataFromDB(queryStr)
        }
        
        //Sober, Light, Deep
        let sleepColors = [UIColor.RGB(r: 255, g: 244, b: 150),
                           UIColor.RGB(r: 254, g: 210, b: 10),
                           UIColor.RGB(r: 252, g: 116, b: 8)]
        
        if summaryType == .day {
            historySleepDetailChartsView = FDSleepDetailView.init(frame: CGRect.init(x: SCREEN_WIDTH, y: sumDataCharsViewY, width: SCREEN_WIDTH, height: sumDataCharsViewHeight), sleepModel: sleepDetailSummaryModel, viewColor: sleepColors)
        }else if summaryType == .month {
            historySleepDetailChartsView = FDSleepDetailView.init(frame: CGRect.init(x: SCREEN_WIDTH, y: sumDataCharsViewY, width: SCREEN_WIDTH, height: sumDataCharsViewHeight), sleepModel: sleepMonthSummaryModel, viewColor: sleepColors,summaryType: .month)
        }else {
            historySleepDetailChartsView = FDSleepDetailView.init(frame: CGRect.init(x: SCREEN_WIDTH, y: sumDataCharsViewY, width: SCREEN_WIDTH, height: sumDataCharsViewHeight), sleepModel: sleepMonthSummaryModel, viewColor: sleepColors,summaryType: .year)
        }
        
        if type == .next {
            historySleepDetailChartsView.x = SCREEN_WIDTH
        }else {
            historySleepDetailChartsView.x = -SCREEN_WIDTH
        }
        
        UIView.animate(withDuration: 0.25) {
            self.historySleepDetailChartsView.frame.origin.x = 0
            self.view.insertSubview(self.historySleepDetailChartsView, belowSubview: self.swipeGestureRecognizerView)
            
        }
        
    }
    
    
    
    private func setSportChartsData(_ type : HistorySportLoadDataDirectionType, _ specifyDateStr: String? = nil) {


        var summaryType = HistorySportSummaryType.day

        if segmentedControl.selectedSegmentIndex == 0 {
            summaryType = .day
        }else if segmentedControl.selectedSegmentIndex == 1 {
            summaryType = .month
        }else if segmentedControl.selectedSegmentIndex == 2 {
            summaryType = .year
        }

         let sportType = SportType.init(rawValue: selectedRow)
        guard let historySportChartsModel =  HistorySportChartsManager.getHistorySportChartsModel(summaryType: summaryType, sportType: sportType, loadDataDirectionType: type, specifyDateStr: specifyDateStr) else {
            AlertTool.showAlertView(message: "HistoryVC_NoDataWarn".localiz(), cancalTitle: "OK") { }
            return
        }

        removeChartsView()


        if type == .next {
            historySportChartsView = HistorySportChartsView.init(frame: CGRect.init(x: SCREEN_WIDTH, y: sumDataCharsViewY, width: SCREEN_WIDTH, height: sumDataCharsViewHeight))
        }else {
            historySportChartsView = HistorySportChartsView.init(frame: CGRect.init(x: -SCREEN_WIDTH, y: sumDataCharsViewY, width: SCREEN_WIDTH, height: sumDataCharsViewHeight))
        }


        historySportChartsView.model = historySportChartsModel
        UIView.animate(withDuration: 0.25) {
            self.historySportChartsView.frame.origin.x = 0
            self.view.insertSubview(self.historySportChartsView, belowSubview: self.swipeGestureRecognizerView)
            
        }
        
    }
    
    
    private func setHeartRateChartsData(_ type : HistroyHeartRateLoadDataDirectionType) {
        
        removeChartsView()
        
        if type == .next {
            historyHeartRateChartsView = HistoryHeartRateChartsView.init(frame: CGRect.init(x: SCREEN_WIDTH, y: dayDataCharsViewY, width: SCREEN_WIDTH, height: dayDataCharsViewHeight))
        }else {
            historyHeartRateChartsView = HistoryHeartRateChartsView.init(frame: CGRect.init(x: -SCREEN_WIDTH, y: dayDataCharsViewY, width: SCREEN_WIDTH, height: dayDataCharsViewHeight))
            
        }
        
        historyHeartRateChartsView.model = HistoryHeartRateChartsManager.getHistoryHeartRateChartsModelFromDB(loadDataDirectionType: type)
        
        UIView.animate(withDuration: 0.25) {
            self.historyHeartRateChartsView.frame.origin.x = 0
            self.view.insertSubview(self.historyHeartRateChartsView, belowSubview: self.swipeGestureRecognizerView)
        }
        
    }
    
    private func setBloodSugarChartsData(_ type : HistoryBloodSugarLoadDataDirectionType) {
        
        removeChartsView()
        
        if type == .next {
            historyBloodSugarChartsView = HistoryBloodSugarChartsView.init(frame: CGRect.init(x: SCREEN_WIDTH, y: dayDataCharsViewY, width: SCREEN_WIDTH, height: dayDataCharsViewHeight))
        }else {
            historyBloodSugarChartsView = HistoryBloodSugarChartsView.init(frame: CGRect.init(x: -SCREEN_WIDTH, y: dayDataCharsViewY, width: SCREEN_WIDTH, height: dayDataCharsViewHeight))
            
        }
        
        
        historyBloodSugarChartsView.model = HistoryBloodSugarChartsManager.getHistoryBloodSugarChartsModel(loadDataDirectionType: type)
        
        UIView.animate(withDuration: 0.25) {
            self.historyBloodSugarChartsView.frame.origin.x = 0
            self.view.insertSubview(self.historyBloodSugarChartsView, belowSubview: self.swipeGestureRecognizerView)
        }
        
    }
    
}

// MARK: - Handle charts views
extension HistoryViewController {
    
    func addChartsViews() {
        
        addSportChartsView()
        
        //Add swipeGestureRecognizerView
        swipeGestureRecognizerView = UIView.init(frame: CGRect.init(x: 0, y: sumDataCharsViewY, width: SCREEN_WIDTH, height: sumDataCharsViewHeight - 40))
        swipeGestureRecognizerView.backgroundColor = UIColor.clear
        swipeGestureRecognizerView.isUserInteractionEnabled = true
        //        view.addSubview(swipeGestureRecognizerView)
        view.insertSubview(swipeGestureRecognizerView, at: 0)
        
        //Add UISwipeGestureRecognizer
        let rightSwip = UISwipeGestureRecognizer.init(target: self, action: #selector(swipAction(swip:)))
        rightSwip.direction = .right
        swipeGestureRecognizerView.addGestureRecognizer(rightSwip)
        
        let leftSwip = UISwipeGestureRecognizer.init(target: self, action: #selector(swipAction(swip:)))
        leftSwip.direction = .left
        swipeGestureRecognizerView.addGestureRecognizer(leftSwip)
        
    }
    
    
    func addSportChartsView() {

        guard let historySportChartsModel =  HistorySportChartsManager.getHistorySportChartsModel(summaryType: .day, sportType: .walk, loadDataDirectionType: .current, specifyDateStr: currentDateStr) else {
            AlertTool.showAlertView(message: "HistoryVC_NoDataWarn".localiz(), cancalTitle: "OK") { }
            return
        }

        historySportChartsView = HistorySportChartsView.init(frame: CGRect.init(x: 0, y: sumDataCharsViewY, width: SCREEN_WIDTH, height: sumDataCharsViewHeight))
        historySportChartsView.model = historySportChartsModel
        view.addSubview(historySportChartsView)
    }
    func addHeartRateChartsView() {
        
        historyHeartRateChartsView = HistoryHeartRateChartsView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: sumDataCharsViewHeight))
        historyHeartRateChartsView.model = HistoryHeartRateChartsManager.getHistoryHeartRateChartsModelFromDB(loadDataDirectionType: .current)
        view.addSubview(historyHeartRateChartsView)
    }
    
    func addHistoryBloodSugarChartsView() {
        
        historyBloodSugarChartsView = HistoryBloodSugarChartsView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: sumDataCharsViewHeight))
        historyBloodSugarChartsView.model = HistoryBloodSugarChartsManager.getHistoryBloodSugarChartsModel(loadDataDirectionType: .current)
        view.addSubview(historyBloodSugarChartsView)
    }
    
    func removeChartsView() {
        if historyHeartRateChartsView != nil {
            historyHeartRateChartsView.removeFromSuperview()
        }
        
        if historySportChartsView != nil {
            historySportChartsView.removeFromSuperview()
        }
        
        if historySleepDetailChartsView != nil {
            historySleepDetailChartsView.removeFromSuperview()
        }
        
        if historyBloodSugarChartsView != nil {
            historyBloodSugarChartsView.removeFromSuperview()
        }
    }
}




