//
//  ServreAPICommone.swift
//  FD070+
//
//  Created by WANG DONG on 2019/1/2.
//  Copyright © 2019 WANG DONG. All rights reserved.
//

import UIKit

struct ServreAPICommone {

    struct APPInfoCommone {
        static var APPID = "23518"

    }

    struct DeviceInfoCommone {
        static let DefaultMac = "F0:13:C3:FF:FF:FF"

    }

    /**
     var accountScheme = "https", accountHost = "pro.smartfenda.com/fd070_plus_account/api"
     var businessScheme = "https", businessHost = "pro.smartfenda.com/fd070_plus_business/api"
     var upgradeScheme = "https", upgradeHost = "pro.smartfenda.com/fd070_plus_upgrade/api"
     var punchScheme = "https", punchHost = "pro.smartfenda.com/monitorsys/backend/back/upload.php"
     */
    struct ServreCommone {
        static var accountBaseUrl = ""
        static var businessBaseUrl = ""
        static var upgradeBaseUrl = ""
        static var punchBaseUrl = ""

    }

    struct ServerSpecify {

        static var rootDomain: String {
            #if RELEASE
            //ProUrl 外网
            return "https://pro.smartfenda.com/"
            #else
            //DevUrl 内网
            return "https://dev.smartfenda.cn/"
            #endif
            
        }
        static let downloadBleZipMainDomain = "https://xlab.fenda.com:8203/php"

    }
}

