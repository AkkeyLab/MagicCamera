//
//  BLEButton.swift
//  Smartravel
//
//  Created by 板谷晃良 on 2016/01/17.
//  Copyright © 2016年 AkkeyLab. All rights reserved.
//

import UIKit

class BLEButton: NSObject {
    
    func settingButton(myself: UIViewController, button: UIButton){
        
        button.frame = CGRectMake(0, 0, 50, 50)
        button.backgroundColor = UIColor.blueColor()
        button.alpha = 0.7
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 25.0
        button.setTitle("-_-", forState: UIControlState.Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button.layer.position = CGPoint(x: 50, y: myself.view.frame.height - 50)
        button.addTarget(myself, action: "onClickButton:", forControlEvents: .TouchUpInside)
        button.tag = 200
        myself.view.addSubview(button)
    }
}
