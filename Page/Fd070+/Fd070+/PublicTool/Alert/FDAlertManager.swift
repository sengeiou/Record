//
//  FDAlertManager.swift
//  Orangetheory
//
//  Created by HaiQuan on 2018/7/11.
//  Copyright © 2018年 WANG DONG. All rights reserved.
//

import Foundation

import UIKit

private class AlertView: UIView {
    fileprivate var alertManager: AlertManager?
}

typealias AlertManagerBlock = (_ actionIndex: NSInteger, _ actionTitle: String?) -> Void
typealias AlertTextFieldTextChangeBlock = (_ textField: UITextField?) -> Void
typealias AlertActionBlock = (_ tempAlertManager: AlertManager?, _ actionIndex: Int, _ actionTitle: String?) -> Void

@available(iOS 8.0, *)
class AlertManager: NSObject {
    weak private var contentView: AlertView?
    private var cancelIndextemp: Int?
    private var destructiveIndextemp: Int?
    private var cancelTitle: String?
    private var destructiveTitle: String?
    private var block: AlertManagerBlock?

    lazy private var textFieldChangedBlockMutDict: [String: AlertTextFieldTextChangeBlock]? = {
        return [String: AlertTextFieldTextChangeBlock]()
    }()

    lazy private var otherTitles: [String]? = {
        return [String]()
    }()

    public var alertController: UIAlertController?

    public var textFields: [UITextField]? {
        get { return self.alertController?.textFields }
    }

    public var cancelIndex: Int {
        get { return self.cancelIndextemp! }
    }
    public var destructiveIndex: Int {
        get { return self.destructiveIndextemp! }
    }

    public var iPad: Bool {
        get { return UIDevice.current.userInterfaceIdiom == .pad }
    }

    override private init() {
        super.init()
        self.cancelIndextemp = -1
        self.destructiveIndextemp = -2
        //        NotificationCenter.default.addObserver(self, selector: #selector(textFieldTextDidChaged(_:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }

    /// 私有
    @objc private func textFieldTextDidChaged(_ notification: Notification) {
        let textField = notification.object as? UITextField
        let pointer = NSString.init(format: "%p", textField!)
        let textChangeBlock = self.textFieldChangedBlockMutDict?[pointer as String]
        textChangeBlock?(textField)
    }

    /// 初始化方法
    public class func alertManager(withStyle style: UIAlertControllerStyle, title: String?, messgae: String?) -> AlertManager {
        return AlertManager.init().then(block: { (manager) in
            manager.alertController = UIAlertController.init(title: title, message: messgae, preferredStyle: style)
        })
    }

    public func configue(withCancelTitle cancelTitle: String?, destructiveIndex: Int, otherTitles: [String]?) {
        self.cancelTitle = cancelTitle
        self.destructiveIndextemp = destructiveIndex
        self.addCancelAction()

        self.otherTitles?.appendArrayObject(fromArray: otherTitles)
        if self.destructiveIndex >= 0 && self.destructiveIndex < (self.otherTitles?.count)! {
            self.destructiveTitle = self.otherTitles?[destructiveIndex]
        }
        self.addOtherActions()
    }

    public func configuePopoverControllerForActionSheetStyle(withSourceView sourceView: UIView?, sourceRect: CGRect) {
        if self.iPad == true && self.alertController != nil {
            assert(self.alertController?.preferredStyle == UIAlertControllerStyle.actionSheet, "\nAlertManagerError: 不能在UIAlertControllerStyleAlert类型中设置PopoverController\n")
            let popoerController = self.alertController?.popoverPresentationController
            if popoerController != nil {
                popoerController?.sourceView = sourceView
                popoerController?.sourceRect = sourceRect
                popoerController?.permittedArrowDirections = .any
            }
        }
    }

    public func addTextField(withPlaceHolder placeHolder: String?, isSecureTextEntry: Bool, configuretionHandle: ((UITextField) -> Void)?, textChangeBlock: AlertTextFieldTextChangeBlock?) {
        if self.alertController != nil {
            weak var weakSelf = self
            self.alertController?.addTextField(configurationHandler: { (textField) in
                guard let strongSelf = weakSelf else { return }
                textField.placeholder = placeHolder
                textField.isSecureTextEntry = isSecureTextEntry
                configuretionHandle?(textField)
                if textChangeBlock != nil {
                    let pointer = NSString.init(format: "%p", textField)
                    strongSelf.textFieldChangedBlockMutDict!.updateValue(textChangeBlock!, forKey: pointer as String)
                }
            })
        }
    }

    public func showAlertController(fromVC controller: UIViewController, actionBlock: AlertActionBlock?) {
        let alertView = AlertView.init(frame: CGRect.zero)
        controller.view.addSubview(alertView)
        self.contentView = alertView
        alertView.alertManager = self

        controller.present(self.alertController!, animated: true, completion: nil)

        /// 解除循环引用
        weak var weakSelf = self
        self.block = { (actionIndex, actionTitle) in
            guard let strongSelf = weakSelf else { return }
            actionBlock?(strongSelf, actionIndex, actionTitle)
            NotificationCenter.default.removeObserver(strongSelf)
            strongSelf.alertController = nil
            strongSelf.textFieldChangedBlockMutDict = nil
            strongSelf.otherTitles = nil
            strongSelf.contentView?.removeFromSuperview()
            strongSelf.block = nil
        }
    }

    /// 添加Actions
    private func addCancelAction() {
        if self.cancelTitle != nil {
            let cancelAction = UIAlertAction.init(title: self.cancelTitle, style: .default, handler: { (_) in
                self.block?(self.cancelIndex, self.cancelTitle)
            })
            self.alertController?.addAction(cancelAction)
        }
    }

    private func addOtherActions() {
        for (index, item) in self.otherTitles!.enumerated() {
            if self.destructiveIndex == index {
                self.addDestructiveAction()
                continue
            }

            let action = UIAlertAction.init(title: item, style: .default, handler: { (_) in
                self.block?(index, item)
            })
            self.alertController?.addAction(action)
        }
    }

    private func addDestructiveAction() {
        if self.destructiveTitle != nil {
            let action = UIAlertAction.init(title: self.destructiveTitle, style: .default, handler: { (_) in
                self.block?(self.destructiveIndex, self.destructiveTitle)
            })
            self.alertController?.addAction(action)
        }
    }

    deinit {
//        print("AlertManager deinit")
    }
}
