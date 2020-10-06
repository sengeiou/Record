//
//  LanguageManager.swift
//
//  Created by abedalkareem omreyh on 10/23/17.
//  Copyright © 2017 abedlkareem omreyh. All rights reserved.
//  GitHub: https://github.com/Abedalkareem/LanguageManager-iOS
//  The MIT License (MIT)
//
//  Copyright (c) 2017 Abedalkareem
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

public class FDLanguageChangeTool {
    
    /// Returns the singleton LanguageManager instance.
    public static let shared: FDLanguageChangeTool = FDLanguageChangeTool()
    
    
    /// Returns the currnet language
    public var currentLanguage: Languages {
        get {
            
            guard let currentLang = UserDefaults.standard.string(forKey: DefaultsKeys.selectedLanguage) else {
                fatalError("Did you set the default language for the app ?")
            }
            return Languages(rawValue: currentLang)!
        }
        set {
            
            UserDefaults.standard.set(newValue.rawValue, forKey: DefaultsKeys.selectedLanguage)
        }
    }
    
    /// Returns the default language that the app will run first time
    public var defaultLanguage: Languages {
        get {
            
            guard let defaultLanguage = UserDefaults.standard.string(forKey: DefaultsKeys.defaultLanguage) else {
//                fatalError("Did you set the default language for the app ?")
                return Languages(rawValue: "unknown")!
            }
            return Languages(rawValue: defaultLanguage)!
        }
        set {
            
            // swizzle the awakeFromNib from nib and localize the text in the new awakeFromNib
            UIView.localize()
            Bundle.localize()
            
            let defaultLanguage = UserDefaults.standard.string(forKey: DefaultsKeys.defaultLanguage)
            guard defaultLanguage == nil else {
                return
            }
            
            UserDefaults.standard.set(newValue.rawValue, forKey: DefaultsKeys.defaultLanguage)
            UserDefaults.standard.set(newValue.rawValue, forKey: DefaultsKeys.selectedLanguage)
            setLanguage(language: newValue)
        }
    }
    
    
    /// Returns the diriction of the language
    public var isRightToLeft: Bool {
        get {
            return isLanguageRightToLeft(language: currentLanguage)
        }
    }
    
    /// Returns the app locale for use it in dates and currency
    public var appLocale: Locale {
        get {
            return Locale(identifier: currentLanguage.rawValue)
        }
    }

    public var currentSystemLanguage: Languages {

        get {
            let preferredLang = Bundle.main.preferredLocalizations.first! as NSString

            print(preferredLang)

            switch String(describing: preferredLang) {
            case "en-US", "en-CN":

                return  Languages(rawValue: "en")!
            case "zh-Hans-US","zh-Hans-CN","zh-Hant-CN","zh-TW","zh-HK","zh-Hans":

                return Languages(rawValue: "zh-Hans")!
            default:
                return Languages(rawValue: "en")!
            }
        }
    }
    
    ///
    /// Set the current language for the app
    ///
    /// - parameter language: The language that you need from the app to run with
    ///
    public func setLanguage(language: Languages) {

        //TODO: 这里可以适配阿拉伯语言。这个属性是适用于iOS9.0及以上的。可适配低版本
        // change the dircation of the views
//        let semanticContentAttribute:UISemanticContentAttribute = isLanguageRightToLeft(language: language) ? .forceRightToLeft : .forceLeftToRight
//        UIView.appearance().semanticContentAttribute = semanticContentAttribute
//        UITextField.appearance().semanticContentAttribute = semanticContentAttribute

        // change app language
        UserDefaults.standard.set([language.rawValue], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        // set current language
        currentLanguage = language
    }
    
    private func isLanguageRightToLeft(language: Languages) -> Bool {
        let rightToLeftLanguages: [Languages] = [.ar, .he, .ur, .fa, .ku, .arc]
        return rightToLeftLanguages.contains(language)
    }
    
}

public enum Languages: String {
    case ar,en,nl,ja,ko,vi,ru,sv,fr,es,pt,it,de,da,fi,nb,tr,el,id,ms,th,hi,hu,pl,cs,sk,uk,hr,ca,ro,he,ur,fa,ku,arc
    case enGB = "en-GB"
    case enAU = "en-AU"
    case enCA = "en-CA"
    case enIN = "en-IN"
    case frCA = "fr-CA"
    case esMX = "es-MX"
    case ptBR = "pt-BR"
    case zhHans = "zh-Hans"
    case zhHant = "zh-Hant"
    case zhHK = "zh-HK"
    case unknown

}


// MARK: Swizzling
fileprivate extension UIView {
    fileprivate static func localize() {
        
        let orginalSelector = #selector(awakeFromNib)
        let swizzledSelector = #selector(swizzledAwakeFromNib)
        
        let orginalMethod = class_getInstanceMethod(self, orginalSelector)
        let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
        
        let didAddMethod = class_addMethod(self, orginalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))
        
        if didAddMethod {
            class_replaceMethod(self, swizzledSelector, method_getImplementation(orginalMethod!), method_getTypeEncoding(orginalMethod!))
        } else {
            method_exchangeImplementations(orginalMethod!, swizzledMethod!)
        }
        
    }
    
    
    
    @objc fileprivate func swizzledAwakeFromNib() {
        swizzledAwakeFromNib()
        
        switch self {
        case let txtf as UITextField:
            txtf.text = txtf.text?.localiz()
            txtf.placeholder = txtf.placeholder?.localiz()
        case let lbl as UILabel:
            lbl.text = lbl.text?.localiz()
        case let btn as UIButton:
            btn.setTitle(btn.title(for: .normal)?.localiz(), for: .normal)
        default:
            break
        }
    }
}

fileprivate extension Bundle {
    fileprivate static func localize() {
        
        let orginalSelector = #selector(localizedString(forKey:value:table:))
        let swizzledSelector = #selector(customLocaLizedString(forKey:value:table:))
        
        let orginalMethod = class_getInstanceMethod(self, orginalSelector)
        let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
        
        let didAddMethod = class_addMethod(self, orginalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))
        
        if didAddMethod {
            class_replaceMethod(self, swizzledSelector, method_getImplementation(orginalMethod!), method_getTypeEncoding(orginalMethod!))
        } else {
            method_exchangeImplementations(orginalMethod!, swizzledMethod!)
        }
    }
    
    @objc  private func customLocaLizedString(forKey key:String,value:String?,table:String?)->String{
        if let bundle = Bundle.main.path(forResource: FDLanguageChangeTool.shared.currentLanguage.rawValue, ofType: "lproj"),
            let langBundle = Bundle(path: bundle){
            return langBundle.customLocaLizedString(forKey: key, value: value, table: table)
        }else {
            return Bundle.main.customLocaLizedString(forKey: key, value: value, table: table)
        }
    }
}


// MARK: String extension
public extension String {
    
    ///
    /// Localize the current string to the selected language
    ///
    /// - returns: The localized string
    ///
    public func localiz(comment: String = "") -> String {
        guard let bundle = Bundle.main.path(forResource: FDLanguageChangeTool.shared.currentLanguage.rawValue, ofType: "lproj") else {
            return NSLocalizedString(self, comment: comment)
        }
        
        let langBundle = Bundle(path: bundle)
        return NSLocalizedString(self, tableName: nil, bundle: langBundle!, comment: comment)
    }
    
}

fileprivate enum DefaultsKeys {
    static let selectedLanguage = "LanguageManagerSelectedLanguage"
    static let defaultLanguage = "LanguageManagerDefaultLanguage"
}

// MARK: UIApplication extension
public extension UIApplication {
    // Get top view controller
    public static var topViewController:UIViewController? {
        get{
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                return topController
            }else{
                return nil
            }
        }
    }
    
}

