//
//  WorkoutHistoryViewController.swift
//  FD070+
//
//  Created by HaiQuan on 2019/3/8.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import UIKit

class WorkoutHistoryViewController: UIViewController {
    
    struct Constant {
        static let cellReuseIdentifier = "WorkoutHistoryViewController.WorkoutHistoryTableViewCell"
    }
    
    var tableView: UITableView!
    
    var dataSource = WorkoutHistoryManager.getWorkoutHistoryModel()
    
    private var tempDicts = [Int : [WorkoutHistoryDetailModel]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        bindUI()
        
        
    }

    deinit {
        print("WorkoutHistoryViewController.deinit")
    }
    
    private func configUI() {
        
        view.backgroundColor = UIColor.white
        
        self.title = "WorkoutVC_workoutHistory_title".localiz()
        
        
        tableView = UITableView()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(WorkoutHistoryTableViewCell.self, forCellReuseIdentifier: Constant.cellReuseIdentifier)
        
        let headView = WorkoutHistoryTableViewHeadView.init(frame: CGRect.init(x: 0, y: 0, width: view.width, height: (navigationBarHeight * 1.5).auto()))
        let distanceTotal = dataSource.map({$0.summaryModel.summaryDistance.toCGFloat()}).reduce(0, +)
        let distanceTuple = WorkoutHistoryManager.coverDistanceValue(distance: distanceTotal.description)
        headView.descriptionLabel.text = distanceTuple.0 + distanceTuple.1

        tableView.tableHeaderView = headView
        
    }
    private func bindUI() {
        
        
    }
    
}

//MARK: - UITableViewDataSource
extension WorkoutHistoryViewController: UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSource[section].detailModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.cellReuseIdentifier) as! WorkoutHistoryTableViewCell
        cell.detailModel = dataSource[indexPath.section].detailModels[indexPath.row]
        
        return cell
        
    }
}

//MARK: - UITableViewDelegate
extension WorkoutHistoryViewController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80.auto()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80.auto()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = WorkoutHistoryTableViewSectionView()
        headerView.summaryModel = dataSource[section].summaryModel
        
        headerView.delegate = self
        headerView.index = section
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50.auto()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        //            datas[indexPath.section].remove(at: indexPath.row)
        //            tableView.beginUpdates()
        //            tableView.deleteRows(at: [indexPath], with: .none)
        //            tableView.endUpdates()
    }
}

//MARK: - HenryHeaderViewDelegate
extension WorkoutHistoryViewController: WorkoutHistoryHeaderViewDelegate {
    
    func workoutHistoryHeaderView(_ headerView: WorkoutHistoryTableViewSectionView, didSelectAt index: Int) {
        
        if let data = tempDicts[index]  { //打开section
            dataSource[index].detailModels = data
            tempDicts.removeValue(forKey: index)
            
            var indexPathArray: [IndexPath] = []
            for (rowIndex , _) in dataSource[index].detailModels.enumerated() {
                indexPathArray.append(IndexPath(row: rowIndex, section: index))
            }
            
            tableView.beginUpdates()
            tableView.insertRows(at: indexPathArray, with: .none)
            tableView.endUpdates()
            
        }else { //关闭section
            tempDicts[index] = dataSource[index].detailModels
            dataSource[index].detailModels.removeAll()
            
            var indexPathArray: [IndexPath] = []
            for (rowIndex , _) in tempDicts[index]!.enumerated() {
                indexPathArray.append(IndexPath(row: rowIndex, section: index))
            }
            tableView.beginUpdates()
            tableView.deleteRows(at: indexPathArray, with: .none)
            tableView.endUpdates()
        }
        
    }
}
