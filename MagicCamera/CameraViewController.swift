//
//  CameraViewController.swift
//  MagicCamera
//
//  Created by 板谷晃良 on 2015/12/24.
//  Copyright © 2015年 AkkeyLab. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {

    var mySession : AVCaptureSession!
    var myDevice : AVCaptureDevice!
    var myImageOutput : AVCaptureStillImageOutput!
    
    var myButton: UIButton!
    var backButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        mySession = AVCaptureSession()
        
        let devices = AVCaptureDevice.devices()
        for device in devices{
            if(device.position == AVCaptureDevicePosition.Back){
                myDevice = device as! AVCaptureDevice
            }
        }
        */
        
        // バックカメラからVideoInputを取得.
        //let videoInput = AVCaptureDeviceInput.deviceInputWithDevice(myDevice, error: nil) as! AVCaptureDeviceInput
        let videoInput: AVCaptureInput!
        do{
            videoInput = try AVCaptureDeviceInput.init(device: myDevice)
        }catch{
            videoInput = nil
        }
        
        // セッションに追加.
        mySession.addInput(videoInput)
        
        // 出力先を生成.
        myImageOutput = AVCaptureStillImageOutput()
        
        // セッションに追加.
        mySession.addOutput(myImageOutput)
        
        // 画像を表示するレイヤーを生成.
        //let myVideoLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.layerWithSession(mySession) as! AVCaptureVideoPreviewLayer
        let myVideoLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.init(session: mySession)
        myVideoLayer.frame = self.view.bounds
        myVideoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        // Viewに追加.
        self.view.layer.addSublayer(myVideoLayer)
        
        // セッション開始.
        mySession.startRunning()
        
        // UIボタンを作成.
        myButton = UIButton(frame: CGRectMake(0,0,120,50))
        myButton.backgroundColor = UIColor.redColor();
        myButton.layer.masksToBounds = true
        myButton.setTitle("撮影", forState: .Normal)
        myButton.layer.cornerRadius = 20.0
        myButton.layer.position = CGPoint(x: self.view.bounds.width/2, y:self.view.bounds.height-50)
        myButton.addTarget(self, action: "onClickButton:", forControlEvents: .TouchUpInside)
        
        // UIボタンをViewに追加.
        self.view.addSubview(myButton);
        
        // ボタンを作成.
        backButton = UIButton(frame: CGRectMake(0,0,120,50))
        backButton.backgroundColor = UIColor.redColor();
        backButton.layer.masksToBounds = true
        backButton.setTitle("Back", forState: .Normal)
        backButton.layer.cornerRadius = 20.0
        backButton.layer.position = CGPoint(x: self.view.bounds.width/2 , y:self.view.bounds.height-150)
        backButton.addTarget(self, action: "onClickButton:", forControlEvents: .TouchUpInside)
        self.view.addSubview(backButton);
        
    }
    
    // ボタンイベント.
    func onClickButton(sender: UIButton){
        
        if(sender == myButton){
            // ビデオ出力に接続.
            let myVideoConnection = myImageOutput.connectionWithMediaType(AVMediaTypeVideo)
            
            // 接続から画像を取得.
            self.myImageOutput.captureStillImageAsynchronouslyFromConnection(myVideoConnection, completionHandler: { (imageDataBuffer, error) -> Void in
                
                // 取得したImageのDataBufferをJpegに変換.
                let myImageData : NSData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataBuffer)
                
                // JpegからUIIMageを作成.
                let myImage : UIImage = UIImage(data: myImageData)!
                
                // アルバムに追加.
                UIImageWriteToSavedPhotosAlbum(myImage, self, nil, nil)
                
            })
        }
        else if(sender == backButton){
            let main: UIViewController = ViewController()
            main.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
            self.presentViewController(main, animated: true, completion: nil)
        }
        
    }
}
