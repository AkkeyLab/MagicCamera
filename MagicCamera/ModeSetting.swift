//
//  modeSetting.swift
//  MagicCamera
//
//  Created by 板谷晃良 on 2016/01/29.
//  Copyright © 2016年 AkkeyLab. All rights reserved.
//

import UIKit

class ModeSetting: NSObject {
    
    private var mode: String = "OpenCV"
    private var ble: Bool = true
    private let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    func setMode(data: String){
        mode = data
        
        defaults.setObject(data, forKey: "mode")
    }
    
    func getMode() -> String {
        if defaults.objectForKey("mode") != nil {
            mode = defaults.stringForKey("mode")!
        }
        return mode
    }
    
    func setBle(data: Bool){
        ble = data
        
        defaults.setBool(data, forKey: "ble")
    }
    
    func getBle() -> Bool {
        if defaults.objectForKey("ble") != nil {
            ble = defaults.boolForKey("ble")
        }
        return ble
    }
}
