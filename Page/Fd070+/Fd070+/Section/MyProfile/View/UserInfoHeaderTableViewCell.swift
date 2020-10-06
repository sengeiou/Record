//
//  UserInfoHeaderTableViewCell.swift
//  FD070+
//
//  Created by Payne on 2018/12/14.
//  Copyright © 2018年 WANG DONG. All rights reserved.
//

import UIKit
import Kingfisher

class UserInfoHeaderTableViewCell: UITableViewCell,UIImagePickerControllerDelegate,UINavigationControllerDelegate  {

    var headerBtn = UIButton(type: .custom)

    var headerImageView = UIImageView().then() {
        $0.image = UIImage.init(named: "use_photo")
        
    }
    
    var uploadLabel = UILabel().then(){
        $0.textColor = UIColor.hexColor(0x727171)
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.textAlignment = NSTextAlignment.center
        $0.text = ""
        $0.numberOfLines = 0
    }
    
    var firstLabel = UILabel().then(){
        $0.textColor = UIColor.hexColor(0x696969)
        $0.font = UIFont.boldSystemFont(ofSize: 25)
        $0.text = "First"
    }
    
    var lastLabel = UILabel().then(){
        $0.textColor = UIColor.hexColor(0x696969)
        $0.font = UIFont.boldSystemFont(ofSize: 25)
        $0.text = "Last"
    }
    var userModel = UserInfoModel()
    var userManager = UserInfoManager()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configUI()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI() {

        //        self.backgroundColor = UIColor.randomColor

        uploadLabel.text = "UserInformationVC_uploadPhotos".localiz()

        headerImageView.layer.masksToBounds = true
        headerImageView.layer.cornerRadius = 50
        headerImageView.layer.borderColor = UIColor.hexColor(0x1b8dfb).cgColor
        headerImageView.layer.borderWidth = 3
        addSubview(headerImageView)
        headerImageView.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.left.equalTo(20)
            make.width.height.equalTo(100)
        }
        
        headerBtn.addTarget(self, action: #selector(headerBtnClick(sender:)), for: .touchUpInside)
        addSubview(headerBtn)
        headerBtn.snp.makeConstraints { (make) in
            make.center.equalTo(headerImageView.snp.center)
            make.width.height.equalTo(100)
        }
        
        addSubview(uploadLabel)
        uploadLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headerImageView.snp.bottom)
            make.centerX.equalTo(headerImageView.snp.centerX)
            make.left.equalTo(headerImageView.snp.left)
            make.right.equalTo(headerImageView.snp.right)
        }

        addSubview(firstLabel)
        firstLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headerImageView.snp.right).offset(40)
            make.top.equalTo(headerImageView.snp.top).offset(30)
            make.right.equalTo(-10)
            make.height.equalTo(50)
        }
        
        addSubview(lastLabel)
        lastLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headerImageView.snp.right).offset(40)
            make.top.equalTo(firstLabel.snp.bottom)
            make.right.equalTo(-10)
            make.height.equalTo(50)
        }
        
        let topLayer = UIView()
        topLayer.backgroundColor = UIColor.hexColor(0xdddddd)
        addSubview(topLayer)
        topLayer.snp.makeConstraints { (make) in
            make.left.equalTo(headerImageView.snp.right).offset(40)
            make.top.equalTo(firstLabel.snp.top)
            make.right.equalTo(-10)
            make.height.equalTo(1)
        }

        let midLayer = UIView()
        midLayer.backgroundColor = UIColor.hexColor(0xdddddd)
        addSubview(midLayer)
        midLayer.snp.makeConstraints { (make) in
            make.left.equalTo(headerImageView.snp.right).offset(40)
            make.top.equalTo(firstLabel.snp.bottom)
            make.right.equalTo(-10)
            make.height.equalTo(1)
        }
        
        let bottomLayer = UIView()
        bottomLayer.backgroundColor = UIColor.hexColor(0xdddddd)
        addSubview(bottomLayer)
        bottomLayer.snp.makeConstraints { (make) in
            make.left.equalTo(headerImageView.snp.right).offset(40)
            make.top.equalTo(lastLabel.snp.bottom)
            make.right.equalTo(-10)
            make.height.equalTo(1)
        }
    }
    
    func userInfoDisplayData(_ item: UserInfoModel) {
        headerImageView.kf.indicatorType = .activity
        self.headerImageView.kf.setImage(with: URL(string: item.icon), placeholder: UIImage(named: "use_photo"), options: nil, progressBlock: nil, completionHandler: nil)

        firstLabel.text = item.firstname
        lastLabel.text = item.lastname
        self.userModel = item

    }

    @objc func headerBtnClick(sender:UIButton){

        showActionSheet()
    }

    //以下头像选择的方法，本来是封装好的，但是调用不能选择照片，所以暂时放这里使用，后续再做更改
    func showActionSheet(){
        let alert = UIAlertController(title:nil ,message: nil ,preferredStyle: UIAlertControllerStyle.actionSheet)
        let openImagesAction = UIAlertAction(title:"UserInforNameVC_chooseFromAlbum".localiz(),style:UIAlertActionStyle.default,handler: {(alerts:UIAlertAction)-> Void in
            print("你点击了打开相册按钮")
            self.localImage()
        })
        let openCameraAction = UIAlertAction(title:"UserInforNameVC_takeAPhoto".localiz(),style:UIAlertActionStyle.default,handler: {(alerts:UIAlertAction)-> Void in
            print("你点击了打开相机按钮")
            self.openCamera()
        })
        
        let cancleAction = UIAlertAction(title:"Cancel".localiz(),style: UIAlertActionStyle.cancel,handler:{(alerts:UIAlertAction)->Void in
            print("你点击了取消按钮")
            
        })
        
        
        alert.addAction(openCameraAction)
        alert.addAction(openImagesAction)
        alert.addAction(cancleAction)
        UIViewController.topViewController()!.present(alert, animated: true, completion: nil)
    }
    
    //从本地获取
    func localImage(){
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = true//允许用户裁剪移动缩放
            imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary//设置图片来源为图库
            //            imagePickerController.modalPresentationStyle = UIModalPresentationCustom
            imagePickerController.modalPresentationStyle = UIModalPresentationStyle.custom
            //设置图片拾取器导航条的前景色
            imagePickerController.navigationBar.barTintColor = UIColor.hexColor(0x1b8dfb)
            //设置图片拾取器标题颜色为白色
            imagePickerController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
            //设置导航条的着色颜色为白色
            imagePickerController.navigationBar.tintColor = UIColor.white
            //在当前视图控制器窗口展示图片拾取器
            UIViewController.topViewController()!.present(imagePickerController, animated: true, completion : nil )
        }else{
            print("读取相册失败")
        }
    }
    
    //打开相机获取
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePickerController = UIImagePickerController()
            
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = true//允许用户裁剪移动缩放
            imagePickerController.sourceType = UIImagePickerControllerSourceType.camera//设置图片来源为相机
            //设置图片拾取器导航条的前景色
            imagePickerController.navigationBar.barTintColor = UIColor.hexColor(0x1b8dfb)
            //设置图片拾取器标题颜色为白色
            imagePickerController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
            //设置导航条的着色颜色为白色
            imagePickerController.navigationBar.tintColor = UIColor.white
            //在当前视图控制器窗口展示图片拾取器
            UIViewController.topViewController()!.present(imagePickerController, animated: true, completion : nil )
            
        }else{
            
            print("相机不可用，您可能使用的是模拟器，请切换到真机调试")
        }
    }
    //把选择的头像保存到本地
    func saveImage(image:UIImage)->String{
        //修正图片的位置
        //下面一句代码报错，暂时没有找到解决方法，以后有时间再弄吧
        //let image = fixOrientation((info[UIImagePickerControllerOriginalImage] as! UIImage))
        
        //先把图片转成NSData
        
        let data = UIImageJPEGRepresentation(image, 0.5)
        //显示图片
        //self.imageview.image = UIImage(data: data!)
        
        //图片保存的路径
        
        //这里将图片放在沙盒的documents文件夹中
        //Home目录
        
        let homeDirectory = NSHomeDirectory()
        
        let documentPath = homeDirectory + "/Documents"
        
        //文件管理器
        
        let fileManager: FileManager = FileManager.default
        
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        do {
            try fileManager.createDirectory(atPath: documentPath, withIntermediateDirectories: true, attributes: nil)
        }
        catch _ {
            
        }
        
        fileManager.createFile(atPath: documentPath.appendingFormat("/image.png"), contents: data, attributes: nil)
        
        //得到选择后沙盒中图片的完整路径
        
        let filePath: String = String(format: "%@%@", documentPath, "/image.png")
        
        print("filePath:" + filePath)

        return filePath
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        //裁剪后图片
        let image = info["UIImagePickerControllerEditedImage"]as? UIImage

        let imagePath:String = self.saveImage(image: image!)
        picker.dismiss(animated: true) {
            //            //根据保存路径获取并显示图片
            let lastData = NSData(contentsOfFile: imagePath)
            self.headerImageView.image = UIImage(data: lastData! as Data)

        }

        UserDefaults.LocalUserInfoKey.iconPath.store(value: imagePath)

        UIViewController.topViewController()!.dismiss(animated: true, completion: nil )
        
    }
    
    
    //添加代理方法，执行用户取消的代码
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //隐藏图片拾取器
        UIViewController.topViewController()!.dismiss(animated: true, completion: nil )
    }
    
}

extension UIViewController {
    
    static func topViewController(_ viewController: UIViewController? = nil) -> UIViewController? {
        let viewController = viewController ?? UIApplication.shared.keyWindow?.rootViewController
        
        if let navigationController = viewController as? UINavigationController,
            !navigationController.viewControllers.isEmpty
        {
            return self.topViewController(navigationController.viewControllers.last)
            
        } else if let tabBarController = viewController as? UITabBarController,
            let selectedController = tabBarController.selectedViewController
        {
            return self.topViewController(selectedController)
            
        } else if let presentedController = viewController?.presentedViewController {
            return self.topViewController(presentedController)
            
        }
        
        return viewController
    }
    
}
