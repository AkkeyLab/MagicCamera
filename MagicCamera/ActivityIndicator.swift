//
//  ActivityIndicator.swift
//  Smartravel
//
//  Created by 板谷晃良 on 2015/12/10.
//  Copyright © 2015年 AkkeyLab. All rights reserved.
//

import UIKit

class ActivityIndicator: NSObject {
    var activityIndicator: UIActivityIndicatorView!
    
    func start(myself: UIViewController){
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRectMake(0, 0, 70, 70)
        activityIndicator.center = myself.view.center
        activityIndicator.backgroundColor = UIColor.grayColor()
        activityIndicator.layer.masksToBounds = true
        activityIndicator.layer.cornerRadius = 10.0
        activityIndicator.layer.opacity = 0.7
        //When Indicator stop
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        activityIndicator.startAnimating()//Start
        myself.view.addSubview(activityIndicator)
    }
}
