//
//  WorkOutResultView.swift
//  FD070+
//
//  Created by HaiQuan on 2019/2/26.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import UIKit

class WorkOutResultView: UIView {
    
    struct Constant {
        static let dividingLineX = 20
        static let collectionViewCellReuseIdentifier = "WorkOutResultView.collectionViewCellReuseIdentifier"
        static let mainBGColor = UIColor.RGB(r: 0, g: 125, b: 255)
        static let collectionCellSpace:CGFloat  = 5
        static let collectionCellWidth = (SCREEN_WIDTH / 2) - CGFloat(collectionCellSpace * 2)
    }
    
    private lazy var dateLabel: UILabel = {
        return getWorkoutResultLabel(20.auto())
    }()
    
    private lazy var resultTitleLabel: UILabel = {
        return getWorkoutResultLabel(15.auto())
    }()
    
    private lazy var resultValueLabel: UILabel = {
        return getWorkoutResultLabel(50.auto())
    }()
    
    var tapBlock: (()-> Void)?
    var isNewestData = true
    
    
    var collectionView: UICollectionView!
    private var layout: UICollectionViewFlowLayout!
    
    var model: WorkOutResultModel = WorkOutResultModel() {
        didSet {
            setData()
        }
    }
    
    init(frame: CGRect, isNewestData: Bool = true) {
        super.init(frame: frame)
        self.isNewestData = isNewestData
        configUI()
        bindUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI() {
        
        self.backgroundColor = Constant.mainBGColor
        
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(statusBarHeight)
        }
        
        //是否显示最新的workout数据
        if isNewestData {
            addSubview(resultValueLabel)
            resultValueLabel.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.width.equalTo(SCREEN_WIDTH)
                make.top.equalTo(dateLabel.snp.bottom).offset(2.auto())
            }
        }else {
            addSubview(resultTitleLabel)
            resultTitleLabel.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(dateLabel.snp.bottom).offset(5.auto())
            }
            
            addSubview(resultValueLabel)
            resultValueLabel.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.width.equalTo(SCREEN_WIDTH)
                make.top.equalTo(resultTitleLabel.snp.bottom).offset(2.auto())
            }
        }
        
        
        
        //下面的那四个大方块
        //设置Collectionview的Layout
        layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: Constant.collectionCellWidth , height: Constant.collectionCellWidth)
        
        //添加Collectionview 到Scroller
        let collectionViewWidth = self.width - (Constant.collectionCellSpace * 2)
        let collectionViewHeigth = (Constant.collectionCellWidth * 2) + (Constant.collectionCellSpace * 2)
        
        collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(WorkOutResultItemCell.self, forCellWithReuseIdentifier: Constant.collectionViewCellReuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(resultValueLabel.snp.bottom).offset(10.auto())
            make.centerX.equalToSuperview()
            make.width.equalTo(collectionViewWidth)
            make.height.equalTo(collectionViewHeigth)
            
        }
        
        //设置圆角
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = self.bounds
        let bezierPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 10.auto(), height: 10.auto()))
        shapeLayer.path = bezierPath.cgPath
        collectionView.layer.mask = shapeLayer
        
        
    }
    
    private func bindUI() {
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer()
        addGestureRecognizer(tap)
        tap.addTarget(self, action: #selector(self.tapGesClick))
    }
    
    @objc func tapGesClick(sender: UITapGestureRecognizer) {
        
        if tapBlock != nil {
            tapBlock!()
        }
        
    }
    
    private func setData() {
        dateLabel.text = model.date
        resultTitleLabel.text = model.title
        resultValueLabel.text = model.value
        collectionView.reloadData()
    }
    
}
// MARK: - UICollectionView delegate. UICollectionView dataSource
extension WorkOutResultView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return  model.workOutResultItemModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.collectionViewCellReuseIdentifier, for: indexPath) as! WorkOutResultItemCell
        
        cell.model = model.workOutResultItemModels[indexPath.row]
        return cell
    }
    
    
    
}
extension WorkOutResultView {
    
    private func getWorkoutResultLabel(_ size: CGFloat) ->UILabel {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.init(name: "Helvetica-BoldOblique", size: size)
        return label
    }
    
    
}


