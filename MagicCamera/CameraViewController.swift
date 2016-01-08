//
//  CameraViewController.swift
//  MagicCamera
//
//  Created by 板谷晃良 on 2015/12/24.
//  Copyright © 2015年 AkkeyLab. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    var cameraSession: AVCaptureSession!
    var cameraDevice:  AVCaptureDevice!
    var videoOutput:   AVCaptureVideoDataOutput!
    
    var takeButton: UIButton!
    var backButton: UIButton!
    
    //Face find object
    let detector = Detector()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup for start
        cameraSession = AVCaptureSession()
        cameraSession.sessionPreset = AVCaptureSessionPresetHigh
        
        //Get VideoInput for select camera
        //*** Swift1.xx -> Swift2.xx Fix ***//
        //let videoInput = AVCaptureDeviceInput.deviceInputWithDevice(myDevice, error: nil) as! AVCaptureDeviceInput
        let videoInput: AVCaptureInput!
        do{
            videoInput = try AVCaptureDeviceInput.init(device: cameraDevice)
        }catch{
            videoInput = nil
        }
        
        //Add session
        cameraSession.addInput(videoInput)
        //Output setting
        videoOutput = AVCaptureVideoDataOutput()
        videoOutput.videoSettings = [ kCVPixelBufferPixelFormatTypeKey: Int(kCVPixelFormatType_32BGRA) ]
        
        //FPS setting
        do {
            try cameraDevice.lockForConfiguration()
            
            cameraDevice.activeVideoMinFrameDuration = CMTimeMake(1, 15)
            cameraDevice.unlockForConfiguration()
        } catch let error {
            NSLog("ERROR:\(error)")
        }
        
        //Delegate setting
        let queue: dispatch_queue_t = dispatch_queue_create("myqueue",  nil)
        videoOutput.setSampleBufferDelegate(self, queue: queue)
        
        //Frame setting
        videoOutput.alwaysDiscardsLateVideoFrames = true
        
        //Add session
        cameraSession.addOutput(videoOutput)
        
        //Camera setting
        for connection in videoOutput.connections {
            if let conn = connection as? AVCaptureConnection {
                if conn.supportsVideoOrientation {
                    conn.videoOrientation = AVCaptureVideoOrientation.Portrait
                }
            }
        }
        
        //Make image layer
        //*** Swift1.xx -> Swift2.xx Fix ***//
        //let myVideoLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.layerWithSession(mySession) as! AVCaptureVideoPreviewLayer
        let videoLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.init(session: cameraSession)
        videoLayer.frame = self.view.bounds
        videoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.addSublayer(videoLayer)
        
        //Session start
        cameraSession.startRunning()
        
        //Make parts
        takeButton = UIButton(frame: CGRectMake(0,0,120,50))
        takeButton.backgroundColor = UIColor.redColor();
        takeButton.layer.masksToBounds = true
        takeButton.setTitle("撮影", forState: .Normal)
        takeButton.layer.cornerRadius = 20.0
        takeButton.layer.position = CGPoint(x: self.view.bounds.width/2, y:self.view.bounds.height-50)
        takeButton.addTarget(self, action: "onClickButton:", forControlEvents: .TouchUpInside)
        self.view.addSubview(takeButton);
        
        backButton = UIButton(frame: CGRectMake(0,0,120,50))
        backButton.backgroundColor = UIColor.redColor();
        backButton.layer.masksToBounds = true
        backButton.setTitle("Back", forState: .Normal)
        backButton.layer.cornerRadius = 20.0
        backButton.layer.position = CGPoint(x: self.view.bounds.width/2 , y:self.view.bounds.height-150)
        backButton.addTarget(self, action: "onClickButton:", forControlEvents: .TouchUpInside)
        self.view.addSubview(backButton);
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!){
        dispatch_sync(dispatch_get_main_queue(), {
            let image = CameraUtil.imageFromSampleBuffer(sampleBuffer)
            //Image resize
            //let size = CGSize(width: 36, height: 48) Not recognize and use CPU is (x2 == self).
            let size = CGSize(width: 72, height: 96)
            UIGraphicsBeginImageContext(size)
            image.drawInRect(CGRectMake(0, 0, size.width, size.height))
            let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            //Face find
            let faceImage = self.detector.recognizeFace(resizeImage)
            
            if faceImage > 0 {
                //self.takeImage()
                NSLog("Find!!")
            }
        })
    }
    
    func onClickButton(sender: UIButton){
        
        if(sender == takeButton){
            //takeImage()
        }
        else if(sender == backButton){
            cameraSession.stopRunning()
            
            let main: UIViewController = ViewController()
            main.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
            self.presentViewController(main, animated: true, completion: nil)
        }
        
    }
}
