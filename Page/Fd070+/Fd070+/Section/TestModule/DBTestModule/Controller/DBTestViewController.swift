//
//  HomeViewController.swift
//  Orangetheory
//
//  Created by WANG DONG on 2018/5/31.
//  Copyright © 2018年 WANG DONG. All rights reserved.
//

import UIKit

class DBTestViewController: BaseViewController {

    private struct Constant {
        static let collectionViewCellReuseIdentifier = "DBTestViewController.DBTestCollectionViewCell"
    }
    private var collectionView: UICollectionView!
    private var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout.init()
        let itemWidth = SCREEN_WIDTH / 2
        layout.itemSize = CGSize(width: itemWidth , height: 30)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        return layout
    }()

    var dataSource = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        bindData()
    }

    private func configUI() {

        collectionView = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.register(DBTestCollectionViewCell.self, forCellWithReuseIdentifier: Constant.collectionViewCellReuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self

        view.addSubview(collectionView)
    }

    func bindData() {

        dataSource = ["insterSleepData","insertTestDailybyHour",
                      "insterTestCurrentData", "currentdataCheckColumnExists", "updateTestCurrentData",
                      "insterGlucoseCollectModel", "getDailyDataByDay", "getDailyDataByMonth"]
        collectionView.reloadData()
    }
    
}
// MARK: - UICollectionView delegate. UICollectionView dataSource
extension DBTestViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.collectionViewCellReuseIdentifier, for: indexPath) as! DBTestCollectionViewCell
        cell.textLabel.text = dataSource[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        didSelectItem(row: indexPath.row )
    }

}
class DBTestCollectionViewCell: UICollectionViewCell {

    var textLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.lineBreakMode = .byTruncatingMiddle
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func configUI() {

        contentView.backgroundColor = UIColor.gray
        contentView.layer.borderColor = UIColor.red.cgColor
        contentView.layer.borderWidth = 1

        contentView.addSubview(textLabel)
        textLabel.snp.makeConstraints { (make) in
            make.left.centerY.equalToSuperview()

        }
    }
}


// MARK: - 点击每个Cell所要执行的动作
extension DBTestViewController {
    func didSelectItem(row:Int) {
        switch row {
        case 0: insterSleepData()
        case 1: insertTestDailybyHour()

        case 2: insterTestCurrentData()
        case 3: currentdataCheckColumnExists()
        case 4: updateTestCurrentData()

        case 5: insterGlucoseCollectModel()

        case 6: getDailyDataByDay()
        case 7: getDailyDataByMonth()

        default: break

        }
    }
}

// MARK: - 动作方法的具体实现
extension DBTestViewController {

    func insterSleepData() {




//        let origanalTime = Int(FDDateHandleTool.timeStamp) ?? 1556385780
        var origanalTime = 1556299380

        var models = [SleepDetailDataModel]()

        for _ in 0 ..< 1024 {
            origanalTime  += 60

            let currentSleepType = Int.random(in: 0...3).description

            let model = SleepDetailDataModel.init(userid: "518248981c", bt_mac: "F0:13:C3:FF:FF:FF", isupload: "0", sleep_time: origanalTime.description, sleep_value: currentSleepType, calorie: String(Int(arc4random() % 510) + 1), hr: String(Int(arc4random() % 140) + 1), hr_status: String(Int(arc4random() % 10) + 1), step: String(Int(arc4random() % 610) + 1), distance: String(Int(arc4random() % 310) + 1))



            models.append(model)

        }


        DispatchQueue.main.async {
            do {
                let _ = try SleepDetailDataHelper.insertOrUpdate(items: models, complete: {})


            } catch _ {
                FDLog("inster default DeviceInfo  error")
            }
        }


    }

    func insertTestDailybyHour() {

//        let origanalTime = Int(FDDateHandleTool.timeStamp) ?? 1556385780

        let origanalTime = 1497196800
        var models = [DailyDetailModel]()

        for index in 0 ..< (60 * 60 * 2) {

             let timeStamp = origanalTime + index * 60

            if (timeStamp % 60)  != 0{
                continue
            }


            let dailyDetailModel = DailyDetailModel.init(userid: CurrentUserID, bt_mac: CurrentMacAddress, isupload: "0", typeData: "1", index: String(Int(arc4random() % 6) + 1), timeStamp: timeStamp.description, hr: String(Int(arc4random() % 250) + 1), hrStatus: String(Int(arc4random() % 10) + 1), step: String(Int(arc4random() % 510) + 1), distance: String(Int(arc4random() % 610) + 1), calorie: String(Int(arc4random() % 710) + 1), sleepValue: String(Int(arc4random() % 3) + 1))
            models.append(dailyDetailModel)

        }

        DispatchQueue.main.async {
            do {
                let _ = try DailyDetailDataHelper.insertOrUpdate(items: models, complete: {})


            } catch _ {
                FDLog("inster default DeviceInfo  error")
            }
        }

    }

    func insterTestCurrentData() {
        let model0 = CurrentDataModel.init(userid: "11", bt_mac: "2", isupload: "1", time: "4", device_state: "w2", hr: "wqer", hr_stateus: "qwer", step: "rttewt", distance: "wrtwt", calorie: "wtrw", sleep_hour: "456", sleep_minutes: "53467", light_sleep_time: "767645", deep_sleep_time: "524243", wake_sleep_time: "8765", start_sleep_time: "654", end_sleep_time: "7654")

        do {
            try CurrentDataHelper.insertOrUpdate(items: [model0], complete: {})
            
        } catch _ {
            FDLog("Error")
        }


        let model1 = CurrentDataModel.init(userid: "11", bt_mac: "2", isupload: "2", time: "4", device_state: "w2", hr: "wqer", hr_stateus: "qwer", step: "rttewt", distance: "wrtwt", calorie: "", sleep_hour: "", sleep_minutes: "", light_sleep_time: "", deep_sleep_time: "", wake_sleep_time: "", start_sleep_time: "", end_sleep_time: "11234567876543213456765432")

        do {
            try CurrentDataHelper.insertOrUpdate(items: [model1], complete: {})

        } catch _ {
            FDLog("Error")
        }




    }

    
    func currentdataCheckColumnExists() {

        let model0 = CurrentDataModel.init(userid: "1", bt_mac: "2", isupload: "123", time: "4", device_state: "w2", hr: "wqer", hr_stateus: "qwer", step: "rttewt", distance: "wrtwt", calorie: "wtrw", sleep_hour: "456", sleep_minutes: "53467", light_sleep_time: "767645", deep_sleep_time: "524243", wake_sleep_time: "8765", start_sleep_time: "654", end_sleep_time: "7654")

        do {
            let exists = try CurrentDataHelper.checkColumnExists(item: model0)
            FDLog(exists)
        } catch  {
            FDLog("Error")
        }
    }

    func updateTestCurrentData() {

        let model0 = CurrentDataModel.init(userid: "1", bt_mac: "2", isupload: "100", time: "4", device_state: "w2", hr: "wqer", hr_stateus: "qwer", step: "rttewt", distance: "wrtwt", calorie: "wtrw", sleep_hour: "456", sleep_minutes: "53467", light_sleep_time: "767645", deep_sleep_time: "524243", wake_sleep_time: "8765", start_sleep_time: "654", end_sleep_time: "7654")

        do {
            let row0 =  try CurrentDataHelper.update(item: model0)
            FDLog(row0)
        } catch _ {
            FDLog("Error")
        }


    }

    func insterGlucoseCollectModel() {
        var glucoseCollectModel = GlucoseCollectModel()
        glucoseCollectModel.userId = "5467890"
        try! GlucoseCollectDataHelper.insertOrUpdate(items: [glucoseCollectModel], complete: {
            print("Complate")
        })
    }

    func getDailyDataByDay() {
        let ss = try! DailyDetailDataHelper.getDataGroupByDay(monthStr: "2019/04")
        print(ss)
    }

    func getDailyDataByMonth() {
//        let ss = try! DailyDetailDataHelper.getDataGroupByMonth(yearStr: "2019")
//        print(ss)

        let hrRandom = Int.random(in: 10 ... 250)

         let connection =  SQLiteDataStore.sharedInstance!.connection

        let stm = try! connection!.prepare("update t_daily_detail set hr = \(hrRandom)")
         print(stm)

    }



}
