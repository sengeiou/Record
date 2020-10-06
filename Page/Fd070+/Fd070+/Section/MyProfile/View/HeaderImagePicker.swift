//
//  HeaderImagePicker.swift
//  FD070+
//
//  Created by Payne on 2018/12/14.
//  Copyright © 2018年 WANG DONG. All rights reserved.
//

import UIKit

class HeaderImagePicker: NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var viewController = UIViewController()
    var ImagePickerAction: ((String) -> ())?
    var isAllowsEditing : Bool!

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
        viewController.present(alert, animated: true, completion: nil)
    }

    //从本地获取
    func localImage(){
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = self.isAllowsEditing//允许用户裁剪移动缩放
            imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary//设置图片来源为图库
            //            imagePickerController.modalPresentationStyle = UIModalPresentationCustom
            imagePickerController.modalPresentationStyle = UIModalPresentationStyle.custom
            //设置图片拾取器导航条的前景色
            imagePickerController.navigationBar.barTintColor = UIColor.orange
            //设置图片拾取器标题颜色为白色
            imagePickerController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
            //设置导航条的着色颜色为白色
            imagePickerController.navigationBar.tintColor = UIColor.white
            //在当前视图控制器窗口展示图片拾取器
            viewController.present(imagePickerController, animated: true, completion : nil )
        }else{
            print("读取相册失败")
        }
    }
    
    //打开相机获取
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePickerController = UIImagePickerController()
            
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = self.isAllowsEditing//允许用户裁剪移动缩放
            imagePickerController.sourceType = UIImagePickerControllerSourceType.camera//设置图片来源为相机
            //设置图片拾取器导航条的前景色
            imagePickerController.navigationBar.barTintColor = UIColor.orange
            //设置图片拾取器标题颜色为白色
            imagePickerController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
            //设置导航条的着色颜色为白色
            imagePickerController.navigationBar.tintColor = UIColor.white
            //在当前视图控制器窗口展示图片拾取器
            self.viewController.present(imagePickerController, animated: true, completion : nil )
            
        }else{
            
            print("相机不可用，您可能使用的是模拟器，请切换到真机调试")
        }
    }
    
    func showImagePickerFromViewController(picker:UIViewController, allowsEditing:Bool)
    {
        self.viewController = picker
        self.isAllowsEditing = allowsEditing
        showActionSheet()
    }

    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("22222222222222")
        //        判断是否允许裁剪
        if(picker.allowsEditing){
            
            //裁剪后图片
            let image = info["UIImagePickerControllerEditedImage"]as? UIImage
            //             self.imageview.image = image
           
            let type: String = (info[UIImagePickerControllerMediaType] as! String)
            print(type)
            let imagePath:String = saveImage(image: image!)
            
            if self.ImagePickerAction != nil{
                self.ImagePickerAction!(imagePath)
            }
            //根据保存路径获取并显示图片
//            let lastData = NSData(contentsOfFile: imagePath)
//            self.imgView.image = UIImage(data: lastData! as Data)
            
            
        }else{
            //原始图片
            let image = info["UIImagePickerControllerOriginalImage"]as? UIImage
            
            let type: String = (info[UIImagePickerControllerMediaType] as! String)
            print(type)
            let imagePath:String = saveImage(image: image!)
            if self.ImagePickerAction != nil{
                self.ImagePickerAction!(imagePath)
            }
            //根据路径获取图片并显示
//            let lastData = NSData(contentsOfFile: imagePath)
//
//            self.imgView.image = UIImage(data: lastData! as Data)
            
        }
        
        viewController.dismiss(animated: true, completion: nil )
        
        
    }
    
    
    //添加代理方法，执行用户取消的代码
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //隐藏图片拾取器
        viewController.dismiss(animated: true, completion: nil )
    }
    
    //把选择的头像保存到本地
    func saveImage(image:UIImage)->String{
      
        //先把图片转成NSData
        let data = UIImageJPEGRepresentation(image, 0.5)
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

  
   
}

