//
//  HistroyCalendarView.swift
//  FD070+
//
//  Created by HaiQuan on 2019/1/19.
//  Copyright © 2019年 WANG DONG. All rights reserved.
//

import UIKit

class HistroyCalendarView: UIView {
    
    private struct Constant {
        static let collectionViewCellReuseIdentifier = "HistroyCalendarView.HistoryCalendarCollectionViewCell"
        static let dateLabelHeigth: CGFloat = 50
        static let weekViewHeight: CGFloat = 30
        static let bottomSpace: CGFloat = 20
    }

    private var dateLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = MainColor
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()

    private var collectionView: UICollectionView!
    private var headView: MydayHeadView!
    private var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout.init()
        let itemWidth = SCREEN_WIDTH / 7
        layout.itemSize = CGSize(width: itemWidth , height: itemWidth)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        return layout
    }()

    var selectedDateStrBlock:((String)->())?


    var histroyCalendarModel:HistroyCalendarModel = HistroyCalendarModel() {
        didSet {
            setData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    private func configUI() {
        
        dateLabel.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: Constant.dateLabelHeigth)
        self.addSubview(dateLabel)

        let histroyCalendarWeekView = HistroyCalendarWeekView.init(frame: CGRect.init(x: 0, y: dateLabel.bottom, width: SCREEN_WIDTH, height: CGFloat(Constant.weekViewHeight)))
        addSubview(histroyCalendarWeekView)

        //CollectionView少建了一个高度。是为遮外部视图用的 Constant.dateLabelHeigth
        collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: histroyCalendarWeekView.bottom, width: self.width, height: self.height - Constant.dateLabelHeigth - Constant.weekViewHeight), collectionViewLayout: layout)
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = MainColor
//        collectionView.isScrollEnabled = false

        collectionView.register(HistroyCalendarCollectionViewCell.self, forCellWithReuseIdentifier: Constant.collectionViewCellReuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        addSubview(collectionView)
        
        collectionView.reloadData()

        //Add UISwipeGestureRecognizer
        let rightSwip = UISwipeGestureRecognizer.init(target: self, action: #selector(swipAction(swip:)))
        rightSwip.direction = .right
        addGestureRecognizer(rightSwip)

        let leftSwip = UISwipeGestureRecognizer.init(target: self, action: #selector(swipAction(swip:)))
        leftSwip.direction = .left
        addGestureRecognizer(leftSwip)
    }

    /// Handle swipGes
    ///
    /// - Parameter swip: swipGes event
    @objc func swipAction(swip:UISwipeGestureRecognizer) -> Void {

        if swip.direction == .right {
            guard let model = HistroyCalendarManager.getHistroyCalendarModel(.ahead) else {
                AlertTool.showAlertView(message: "HistoryVC_NoDataWarn".localiz(), cancalTitle: "Ok") { }
                return
            }
            histroyCalendarModel = model

        }else {
            guard let model = HistroyCalendarManager.getHistroyCalendarModel(.next) else {
                AlertTool.showAlertView(message: "HistoryVC_NoDataWarn".localiz(), cancalTitle: "Ok") { }
                return
            }
            histroyCalendarModel = model

        }
    }

    private func setData() {
        dateLabel.text = "\(histroyCalendarModel.thisYear)/\(histroyCalendarModel.thisMonth)/\(histroyCalendarModel.currentDay)"

        let itemWidth = SCREEN_WIDTH / 7
        let weekNumber = histroyCalendarModel.thisMonthWeekNum
        let minimumLineSpacing = (self.height - Constant.weekViewHeight - (CGFloat(weekNumber) * itemWidth)) / CGFloat(weekNumber + 1)
        layout.minimumLineSpacing = minimumLineSpacing

        layout.sectionInset = UIEdgeInsets.init(top: minimumLineSpacing, left: 0, bottom: 0, right: 0)

        collectionView.reloadData()
    }
    
}
// MARK: - UICollectionView delegate. UICollectionView dataSource
extension HistroyCalendarView: UICollectionViewDelegate, UICollectionViewDataSource {


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return histroyCalendarModel.thisMonthWeekNum * 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.collectionViewCellReuseIdentifier, for: indexPath) as! HistroyCalendarCollectionViewCell
        
        cell.model = histroyCalendarModel.dayModels[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        UIView.animate(withDuration: 0.35) {
            self.alpha = 0
            self.removeFromSuperview()
        }

        if selectedDateStrBlock != nil {
            let year = histroyCalendarModel.thisYear.description
            var month = histroyCalendarModel.thisMonth.description
            if month.count == 1 {
                month.insert("0", at: month.startIndex)
            }
            var day = histroyCalendarModel.dayModels[indexPath.row].dayNumber.description
            if day.count == 1 {
                day.insert("0", at: day.startIndex)
            }
            selectedDateStrBlock!(year + "/" + month + "/" + day)
        }
    }
    
}
