//
//  UIViewUtil.swift
//  costpang
//
//  Created by FENGBOLAI on 15/8/10.
//  Copyright (c) 2015年 FENGBOLAI. All rights reserved.
//

import UIKit
//import SDWebImage

class ViewUtil {
    
    // 网络异常
    static func requestError(_ inView: UIView){
        ToastUtil.textTop(inView, text: "出错啦，小伙伴稍后再试")
    }
    
    // 自适应文字高度
    static func heightForView(_ text: String?, lineSpacing: CGFloat, font: UIFont, width: CGFloat) -> CGFloat{
        if StringUtil.isEmpty(text){
            return 0.0
        }
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        if lineSpacing > 0{
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpacing; // 间距大小 默认行距传0，间距大些的传5
            
            let attributes = NSDictionary(objects: [font, paragraphStyle], forKeys: [NSFontAttributeName as NSCopying, NSParagraphStyleAttributeName as NSCopying])
            
            label.attributedText = NSAttributedString(string: text!, attributes: attributes as? [String : AnyObject])
        }
        else{
            label.font = font
            label.text = text
        }
        
        label.sizeToFit()
        return label.frame.height
    }
    
    // 自适应文字高度
    static func heightForView(_ text: String?, lineSpacing: CGFloat, font: UIFont, width: CGFloat, numberOfLines: Int) -> CGFloat{
        if StringUtil.isEmpty(text){
            return 0.0
        }
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = numberOfLines
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        if lineSpacing > 0{
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpacing; // 间距大小 默认行距传0，间距大些的传5
            
            let attributes = NSDictionary(objects: [font, paragraphStyle], forKeys: [NSFontAttributeName as NSCopying, NSParagraphStyleAttributeName as NSCopying])
            
            label.attributedText = NSAttributedString(string: text!, attributes: attributes as? [String : AnyObject])
        }
        else{
            label.font = font
            label.text = text
        }
        
        label.sizeToFit()
        return label.frame.height
    }
    
    // 获取静态字符串的高度、宽度
    static func getSizeOfString(_ text: String? ,font: UIFont) -> CGSize{
        let tv = UILabel()
        tv.text = text
        tv.font = font
        return tv.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
    }
    
    //获取某个view的某个constraint，如果没有返回nil
    static func getConstraintOfaView(_ aView: UIView, layoutAttribute : NSLayoutAttribute) -> NSLayoutConstraint?{
        let constrains = aView.constraints as [AnyObject]
        for constraint in constrains{
            if let const = constraint as? NSLayoutConstraint
            {
                if const.firstAttribute == layoutAttribute{
                    return const
                }
            }
        }
        return nil
    }
    
    // 根据constraint的id，找到对应的constaint实例
    static func findConstraintById(_ aView: UIView, id : String) -> NSLayoutConstraint?{
        let constrains = aView.constraints as [AnyObject]
        for constraint in constrains{
            if let const = constraint as? NSLayoutConstraint
            {
                if const.identifier == id{
                    return const
                }
            }
        }
        return nil

    }
    
    //获取某个rootView下的某个aView的某个constraint，如果没有返回nil
    static func getConstraintsOfaViewFromRootView(_ rootView:UIView, aView:UIView, layoutAttribute: NSLayoutAttribute) -> NSLayoutConstraint?{
        let constrains = rootView.constraints as [AnyObject]
        for constraint in constrains{
            let const = constraint as! NSLayoutConstraint
            if let obj = const.secondItem as? UIView{
                if obj == aView{
                    if const.firstAttribute == layoutAttribute{
                        return const
                    }
                }
            }
        }
        return nil
    }
    
    //自定义导航栏  leftBarItemTap  rightBarItemTap   66
    static func initCustomNavBar(_ rootVC: UIViewController, title: String?, rightImageName: String?){
        rootVC.navigationController?.setNavigationBarHidden(true, animated: false)
        rootVC.tabBarController?.tabBar.isHidden = true
        
        // 第64个像素是一条深灰色的分割线，用来分割导航栏与业务界面
        let bar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: Constants.WIDTH_SCREEN, height: 63))
        bar.backgroundColor = ColorUtil.facebookBlue1()
        bar.alpha = 1.0
        
        let item = UINavigationItem()
        
        //1.title
        if !StringUtil.isEmpty(title){
            let label = UILabel()
            label.textColor = UIColor.gray
            label.text = title
            label.textAlignment = NSTextAlignment.center
            label.font = FontUtil.biggerFont()
            label.sizeToFit()
            label.tag = 99997 // image process更新当前选中的图片时用到
            item.titleView = label
        }
        
        //2.导航面板左边的后退按钮
        let leftButton = UIButton()
        
        leftButton.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
        leftButton.setImage(UIImage(named: "Back_button.png"), for: UIControlState())
        leftButton.addTarget(rootVC, action: "back:", for: UIControlEvents.touchUpInside)
        let leftButtonItem = UIBarButtonItem(customView: leftButton)
        
        leftButtonItem.tag = 99998 // needLogin时用到
        
        item.setLeftBarButton(leftButtonItem, animated: false)
        
        //3.导航面板右边的某设置按钮或者文字
        if rightImageName != nil && rightImageName != ""{
            let rightButton = UIButton()
            rightButton.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
            
            if let image = UIImage(named: rightImageName!){
                rightButton.setImage(image, for: UIControlState())
            }
            else{
                rightButton.setTitle(rightImageName, for: UIControlState())
                rightButton.setTitleColor(ColorUtil.airBnBRed(), for: UIControlState())
                rightButton.titleLabel?.font = FontUtil.bigBoldFont()
                rightButton.titleLabel?.sizeToFit()
                rightButton.sizeToFit()
            }
            
            rightButton.addTarget(rootVC, action: "setting:", for: UIControlEvents.touchUpInside)
            let rightButtonItem = UIBarButtonItem(customView: rightButton)
            item.setRightBarButton(rightButtonItem, animated: false)
        }
        
        bar.pushItem(item, animated: false)
        bar.tag = 99999 // loading 时用到
        
        rootVC.view.addSubview(bar)
    }
    
    // 压缩，改变图片大小，把图片转换成指定长宽的图片
    static func getSizedImage(_ image: UIImage, scaledToSize: CGSize) -> UIImage{
        UIGraphicsBeginImageContext( scaledToSize )
        image.draw(in: CGRect(x: 0, y: 0, width: scaledToSize.width, height: scaledToSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!;
    }
    
    // 压缩，牺牲图片质量  compressionQuality 0.1~0.9
    static func getCompressedImage(_ image: UIImage, compressionQuality: CGFloat) -> UIImage{
        if let compressedImageData = UIImageJPEGRepresentation(image, compressionQuality){
            if let compressedImage = UIImage(data: compressedImageData){
                return compressedImage
            }
            else{
                return image
            }
        }
        else{
            return image
        }
    }
    
    // 压缩，牺牲图片质量  compressionQuality 0.1~0.9
    static func getCompressedImageData(_ image: UIImage, compressionQuality: CGFloat) -> Data?{
        return UIImageJPEGRepresentation(image, compressionQuality)
    }
    
    
    // 淡入淡出效果
    static func setWebImage(_ imageView:UIImageView, URL url: URL!)
    {
        SDWebImageManager.shared().downloadImage(with: url, options: SDWebImageOptions.cacheMemoryOnly, progress: nil) { (downloadedImage, error, cacheType, isDownloaded, withURL) in
            imageView.alpha = 0.0
            
            UIView.transition(with: imageView, duration: 0.2, options: UIViewAnimationOptions(), animations: { () -> Void in
                imageView.image = downloadedImage
                imageView.alpha = 1
                }, completion: nil)
        }
    }
    
    // 设置行间距 返回高度 lineSpacing is Constants.LINE_SPACE.BIG.rawValue or Constants.LINE_SPACE.DEFAULT.rawValue
    static func setLineSpacing(_ lineSpacing: CGFloat, font: UIFont, text: String, label: UILabel) -> CGFloat{
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing // 间距大小
        
        let attributes = NSDictionary(objects: [font, paragraphStyle], forKeys: [NSFontAttributeName as NSCopying, NSParagraphStyleAttributeName as NSCopying])
        
        label.attributedText = NSAttributedString(string: text, attributes: attributes as? [String : AnyObject])
        
        //调整高度 自适应文字宽度 自适应文字高度
        let height = ViewUtil.heightForView(text, lineSpacing: lineSpacing, font: font, width: label.frame.width)
        
        return height
    }
}
