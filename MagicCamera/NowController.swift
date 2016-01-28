//
//  NowController.swift
//  MagicCamera
//
//  Created by 板谷晃良 on 2016/01/27.
//  Copyright © 2016年 AkkeyLab. All rights reserved.
//

import UIKit

class NowController: NSObject {
    
    private var nowBLE: Bool = true
    private let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    func setNowBLE(data: Bool){
        nowBLE = data
        
        defaults.setBool(data, forKey: "now_BLE")
    }
    
    func getNowBLE() -> Bool {
        if defaults.objectForKey("now_BLE") != nil {
            nowBLE = defaults.boolForKey("now_BLE")
        }
        return nowBLE
    }
}
