//
//  FDEncrytionManager.swift
//  FD070+
//
//  Created by WANG DONG on 2018/12/18.
//  Copyright © 2018 WANG DONG. All rights reserved.
//

import UIKit
import CryptoSwift

public struct FDEncrytionInfo {
    
    static let APP_FD_ID = UserDefaults.LoginSuccessUserDefault.Login_Appid.storedValue
    
    static var APP_FD_AccountKey = "39AB56B017B2B994990B1F6DBD26A77B"
    static var APP_FD_AccountIValue = "A7E479FBD4924C4F4131AAFD28146919"
    
    static var APP_FD_BusinessKey = "40C2A8DA4514D3DD70051044B397E22C"
    static var APP_FD_BusinessIValue = "F6367729150ABD29EBED74566E5DB170"


    static var APP_FD_UpgradeKey = "76B88E0CDD63B2205A1F6950B45D41DF"
    static var APP_FD_UpgradeIValue = "68A61BF15319CB261065D28C8587F889"
    
    static var APP_FD_UserHehaviorKey = "A46547336A7A1664F1418A46C4339155"
    static var APP_FD_UserHehaviorIValue = "296718E8041FC067C9DA390043580247"
}

public struct FDDymanicConfigInfo {
    static var foregroundAndBackgroundSwitchUpdateInterval = 3 * 60
    static var realTimeUpdateInterval = 2 * 60 * 60
    static var general_mode_interval = 0
    static var sleep_detail_interval = 0
    static var sport_detail_interval = 0
}

public enum EncrytionType:Int {
    case AES_128BCBEncrytion = 0
    case AES_128BCBDecrypt
}


public enum EncrytionBubisnessType:Int {
    case AES_128_Account = 0
    case AES_128_Business
    case AES_128_Upgrade
    case AES_128_UserHehavior
}




class FDEncrytionManager: NSObject {

    public static func Endcode_AES_BCB(strToEncode:String,type:EncrytionBubisnessType)->String {
        
        let keyValue:(key:String,IV:String) = self.getDiffkeyIvalue(type)

        print("Key-IV::\(type)\n\(keyValue.key)\n\(keyValue.IV)")
        
        let strToEncodeTrimm = strToEncode.trimmingCharacters(in: .controlCharacters)
        
        // byte 数组
        var encrypted: [UInt8] = []
        do {

            //bytes转Data
            let aes = try! AES(key: FDHexStringToIntArray.HexStrTOIntbytes(from: keyValue.key), blockMode: .CBC(iv: FDHexStringToIntArray.HexStrTOIntbytes(from: keyValue.IV)), padding: .zeroPadding)

            print(strToEncodeTrimm.bytes)
            //开始加密
            encrypted = try aes.encrypt(strToEncodeTrimm.bytes)

            let encryptedBase64 = encrypted.toBase64() //将加密结果转成base64形式
            print("加密结果(base64)：\(encryptedBase64!)")

        } catch AES.Error.dataPaddingRequired {
            print("加密失败---")
        } catch {

        }
//
        //加密结果要用Base64转码并使用特殊格式替换掉
        return  FDEncrytionManager.stringReplaceSpecialMark(originalStr: encrypted.toBase64()!, type: .AES_128BCBEncrytion)
    }
    
    
    public static func Decryption_AES_BCB(strToEncode:String,type:EncrytionBubisnessType)->String {
        
        let keyValue:(key:String,IV:String) = self.getDiffkeyIvalue(type)
        
        let data:Data = NSData(base64Encoded: stringReplaceSpecialMark(originalStr: strToEncode, type: .AES_128BCBDecrypt), options: NSData.Base64DecodingOptions.init(rawValue: 0))! as Data
        // decode AES
        var decrypted: [UInt8] = []
        
        do {
            decrypted = try AES.init(key: FDHexStringToIntArray.HexStrTOIntbytes(from: keyValue.key), blockMode: .CBC(iv: FDHexStringToIntArray.HexStrTOIntbytes(from: keyValue.IV))).decrypt(data.bytes)
        } catch AES.Error.dataPaddingRequired {
            // block size exceeded
        } catch {
            // some error
        }
        
        // byte 转换成NSData
        let encoded = NSData.init(bytes: decrypted, length: decrypted.count)
        var str = ""
        //解密结果从data转成string
        str = String(data: encoded as Data, encoding: String.Encoding.utf8) ?? ""
        
        //去掉后面的其他符号
        let characterSet = CharacterSet(charactersIn: "\0")
        str = str.trimmingCharacters(in: characterSet)
        print("解密结果1：\(str)")
        return str
    }
    
    
    
    static func EntraytionSaltMD5(patams:String,salt:String) -> String {
        
        
        var encrypted: [UInt8] = []
        do {
            
            
            let password: Array<UInt8> = Array(patams.utf8)
            let salt: Array<UInt8> = Array(salt.utf8)
            
//            let saltEncray = try? PKCS5.PBKDF2(password: patams.bytes, salt: salt.bytes).calculate()
            
            //encrypted = try! HKDF(password: password, salt: salt, info: nil, keyLength: nil, variant: .md5).calculate()

            
            encrypted = try! PKCS5.PBKDF1(password: password, salt: salt, variant: .md5, iterations: 4096, keyLength: nil).calculate()


            print(encrypted)

            print("加Salt MD5结果:\(encrypted.toHexString())")

        } catch{
            print("加密出现错误")
        }
        
        return encrypted.toHexString()
    }
    
    
    
    
   static func getDiffkeyIvalue(_ type:EncrytionBubisnessType) -> (key:String,IV:String) {
        
        let key:String?
        let Ivalue:String?
        switch type {
        case .AES_128_Account:
            key = FDEncrytionInfo.APP_FD_AccountKey
            Ivalue = FDEncrytionInfo.APP_FD_AccountIValue
            break
        case .AES_128_Business:
            key = FDEncrytionInfo.APP_FD_BusinessKey
            Ivalue = FDEncrytionInfo.APP_FD_BusinessIValue
            break
        case .AES_128_Upgrade:
            key = FDEncrytionInfo.APP_FD_UpgradeKey
            Ivalue = FDEncrytionInfo.APP_FD_UpgradeIValue
            break
        case .AES_128_UserHehavior:
            key = FDEncrytionInfo.APP_FD_UserHehaviorKey
            Ivalue = FDEncrytionInfo.APP_FD_UserHehaviorIValue
    }
    
    print("key:\(key)---IV:\(Ivalue)")
        return (key:key!,IV:Ivalue!)
    }
    
    
    
    public static func stringReplaceSpecialMark(originalStr:String,type:EncrytionType)->String{
        
        var ase_Nsstring:NSString = originalStr as NSString
        
        switch type {
        case .AES_128BCBEncrytion:
            ase_Nsstring  = ase_Nsstring.replacingOccurrences(of: "+", with: "-", options: NSString.CompareOptions.caseInsensitive, range: NSRange.init(location: 0, length: ase_Nsstring.length)) as NSString
            ase_Nsstring  = ase_Nsstring.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.caseInsensitive, range: NSRange.init(location: 0, length: ase_Nsstring.length)) as NSString
            
            let resultStr:String = ase_Nsstring.replacingOccurrences(of: "/", with: "_", options: NSString.CompareOptions.caseInsensitive, range: NSRange.init(location: 0, length: ase_Nsstring.length))
            
            return resultStr
        case .AES_128BCBDecrypt:
            ase_Nsstring  = ase_Nsstring.replacingOccurrences(of: "-", with: "+", options: NSString.CompareOptions.caseInsensitive, range: NSRange.init(location: 0, length: ase_Nsstring.length)) as NSString
            ase_Nsstring  = ase_Nsstring.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.caseInsensitive, range: NSRange.init(location: 0, length: ase_Nsstring.length)) as NSString
            let resultStr:String = ase_Nsstring.replacingOccurrences(of: "_", with: "/", options: NSString.CompareOptions.caseInsensitive, range: NSRange.init(location: 0, length: ase_Nsstring.length))
            
            return resultStr
        }
    }
    
}
