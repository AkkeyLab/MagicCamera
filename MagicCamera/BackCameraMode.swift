//
//  BackCameraMode.swift
//  MagicCamera
//
//  Created by 板谷晃良 on 2016/01/07.
//  Copyright © 2016年 AkkeyLab. All rights reserved.
//

import UIKit
import AVFoundation

class BackCameraMode: CameraViewController {
    
    override func viewDidLoad() {
        
        let devices = AVCaptureDevice.devices()
        for device in devices{
            if(device.position == AVCaptureDevicePosition.Back){
                cameraDevice = device as! AVCaptureDevice
            }
        }
        
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
