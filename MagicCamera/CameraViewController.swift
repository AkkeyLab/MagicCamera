//
//  CameraViewController.swift
//  MagicCamera
//
//  Created by 板谷晃良 on 2015/12/24.
//  Copyright © 2015年 AkkeyLab. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, AVSpeechSynthesizerDelegate {

    private var cameraSession: AVCaptureSession!
            var cameraDevice:  AVCaptureDevice!
    private var videoOutput:   AVCaptureVideoDataOutput!
    
    private let talker = AVSpeechSynthesizer()
    private var takePhotoBool = false
            var photo: UIImage!
    
    private var talkTmp = 0
    private var takeInterval: Int = 0
    
    private let returnButton: UIButton = UIButton()
    
    //object
    private let nowBLE = NowController()
    private let modeSetting = ModeSetting()
    
    //private var oneTake: Bool = true
    
    //Face find object
    let detector = Detector()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.talker.delegate = self
        
        takeInterval = 0
        nowBLE.setNowBLE(false)
        
        //Setup for start
        cameraSession = AVCaptureSession()
        cameraSession.sessionPreset = AVCaptureSessionPresetHigh
        takePhotoBool = false
        
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
            
            cameraDevice.activeVideoMinFrameDuration = CMTimeMake(1, 15)//one frame 1/15 s -> 1s 15frame
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
        
        //Now orientation
        let deviceOrientation: UIDeviceOrientation!  = UIDevice.currentDevice().orientation
        
        //Camera setting
        for connection in videoOutput.connections {
            if let conn = connection as? AVCaptureConnection {
                if conn.supportsVideoOrientation {
                    if UIDeviceOrientationIsLandscape(deviceOrientation) {
                        conn.videoOrientation = AVCaptureVideoOrientation.LandscapeRight
                    }else{
                        conn.videoOrientation = AVCaptureVideoOrientation.Portrait
                    }
                }
            }
        }
        
        //Make image layer
        //*** Swift1.xx -> Swift2.xx Fix ***//
        //let myVideoLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.layerWithSession(mySession) as! AVCaptureVideoPreviewLayer
        let videoLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.init(session: cameraSession)
        //videoLayer.frame = self.view.bounds
        if UIDeviceOrientationIsLandscape(deviceOrientation) {
            videoLayer.frame = CGRectMake(0, 0, self.view.frame.height, self.view.frame.width)
        }else{
            videoLayer.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        }
        
        videoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.addSublayer(videoLayer)
        
        //Session start
        cameraSession.startRunning()
        
        makeParts()
    }
    
    func makeParts(){
        returnButton.frame = CGRectMake(0, 0, 50, 50)
        returnButton.backgroundColor = UIColor.whiteColor()
        returnButton.layer.masksToBounds = true
        returnButton.setTitle("BACK", forState: UIControlState.Normal)
        returnButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        returnButton.layer.cornerRadius = 25.0
        returnButton.layer.position = CGPoint(x: 50, y: 50) //Right hand hold iPhone. Left hand push button.
        returnButton.alpha = 0.5
        returnButton.addTarget(self, action: "onClickButton:", forControlEvents: .TouchUpInside)
        self.view.addSubview(returnButton)
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!){
        dispatch_sync(dispatch_get_main_queue(), {
            let image = CameraUtil.imageFromSampleBuffer(sampleBuffer)
            self.photo = image
            
            self.takeInterval++
            
            if self.modeSetting.getMode() == "OpenCV" {
                if !self.takePhotoBool && self.takeInterval > 4 {
                    //Image resize
                    //let size = CGSize(width: 36, height: 48) Not recognize and use CPU is (x2 == self).
                    //let size = CGSize(width: 72, height: 96)
                    let size = CGSize(width: image.size.width / 5, height: image.size.height / 5)
                    UIGraphicsBeginImageContext(size)
                    image.drawInRect(CGRectMake(0, 0, size.width, size.height))
                    let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    
                    /*
                    //Now orientation
                    let deviceOrientation: UIDeviceOrientation!  = UIDevice.currentDevice().orientation
                    if UIDeviceOrientationIsLandscape(deviceOrientation) {
                        resizeImage = UIImage(CGImage: resizeImage.CGImage!, scale: 1.0, orientation: UIImageOrientation.Left)
                    }
                    */
                    
                    //Face find
                    let faceImage = self.detector.recognizeFace(resizeImage)
                    let boolPoint = self.detector.returnFace()
                    
                    if boolPoint > 0 {
                        //self.takeImage()
                        if !self.takePhotoBool {
                            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate)) //Vibrate
                            self.helloPhoto()
                            self.takePhotoBool = true
                            
                            UIImageWriteToSavedPhotosAlbum(faceImage, self, nil, nil)
                        }
                    }
                    self.takeInterval = 0
                }
            }else{
                if !self.takePhotoBool && self.takeInterval > 4 {
                    //Image resize
                    //let size = CGSize(width: 36, height: 48) Not recognize and use CPU is (x2 == self).
                    //let size = CGSize(width: 72, height: 96)
                    let size = CGSize(width: image.size.width / 5, height: image.size.height / 5)
                    UIGraphicsBeginImageContext(size)
                    image.drawInRect(CGRectMake(0, 0, size.width, size.height))
                    var resizeImage = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    
                    //!! Option is CIDetectorAccuracy**
                    let options : NSDictionary = NSDictionary(object: CIDetectorAccuracyHigh, forKey: CIDetectorAccuracy)
                    let detector : CIDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: options as? [String : AnyObject])
                    let faces : NSArray = detector.featuresInImage(CIImage(image: resizeImage)!)
                    
                    //point
                    var transform : CGAffineTransform = CGAffineTransformMakeScale(1, -1)
                    transform = CGAffineTransformTranslate(transform, 0, -resizeImage.size.height)
                    
                    var outcnt: Int = 0
                    
                    //mark output
                    let feature : CIFaceFeature = CIFaceFeature()
                    for feature in faces {
                        outcnt++
                        
                        let faceRect : CGRect = CGRectApplyAffineTransform(feature.bounds, transform)
                        
                        let faceOutline = UIView(frame: faceRect)
                        faceOutline.layer.borderWidth = 1
                        faceOutline.layer.borderColor = UIColor.redColor().CGColor
                        
                        //let faceOutlineImage = self.getUIImageFromUIView(faceOutline)
                        let faceOutlineImage = UIImage(named: "ios_face.png")
                        
                        UIGraphicsBeginImageContext(CGSizeMake(resizeImage.size.width, resizeImage.size.height))
                        resizeImage.drawAtPoint(CGPointMake(0, 0))
                        faceOutlineImage!.drawInRect(faceRect)
                        resizeImage = UIGraphicsGetImageFromCurrentImageContext()
                        UIGraphicsEndImageContext()
                    }
                    
                    //take
                    if outcnt != 0 {
                        //self.takeImage()
                        if !self.takePhotoBool {
                            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate)) //Vibrate
                            self.helloPhoto()
                            self.takePhotoBool = true
                            
                            UIImageWriteToSavedPhotosAlbum(resizeImage, self, nil, nil)
                        }
                    }
                    
                    self.takeInterval = 0
                }
            }
        })
    }
    
    //UIView -> UIImage
    func getUIImageFromUIView(myUIView:UIView) ->UIImage {
        UIGraphicsBeginImageContextWithOptions(myUIView.frame.size, true, 0);
        let context:CGContextRef = UIGraphicsGetCurrentContext()!;
        CGContextTranslateCTM(context, -myUIView.frame.origin.x, -myUIView.frame.origin.y);
        myUIView.layer.renderInContext(context);
        let renderedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return renderedImage;
    }
    
    func helloPhoto(){
        let talk = ["撮影します。", "3", "2", "1"]
        let utterance = AVSpeechUtterance(string: talk[talkTmp])
        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        utterance.pitchMultiplier = 1.2
        talker.speakUtterance(utterance)
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didStartSpeechUtterance utterance: AVSpeechUtterance){
        //talk start
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didFinishSpeechUtterance utterance: AVSpeechUtterance){
        //talk stop
        if talkTmp < 3 {
            talkTmp++
            NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "helloPhoto", userInfo: nil, repeats: false)
        }else if talkTmp == 3 {
            talkTmp = 0
            NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "takePhoto", userInfo: nil, repeats: false)
        }
    }
    
    func takePhoto(){
        //Now orientation
        let deviceOrientation: UIDeviceOrientation!  = UIDevice.currentDevice().orientation
        
        if photo != nil {
            if UIDeviceOrientationIsLandscape(deviceOrientation) {
                //photo = UIImage(CGImage: photo.CGImage!, scale: 1.0, orientation: UIImageOrientation.Left)
            }
            AudioServicesPlaySystemSound(1108)
            UIImageWriteToSavedPhotosAlbum(photo, self, nil, nil)
            //AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate)) //Vibrate
            NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "returnMain", userInfo: nil, repeats: false)
        }
    }
    
    func onClickButton(sender: UIButton){
        returnMain()
    }
    
    func returnMain(){
        cameraSession.stopRunning()
        
        //let main: UIViewController = ViewController()
        //main.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        //self.presentViewController(main, animated: true, completion: nil)
        nowBLE.setNowBLE(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func shouldAutorotate() -> Bool{
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        let orientation: UIInterfaceOrientationMask = [UIInterfaceOrientationMask.Portrait, UIInterfaceOrientationMask.PortraitUpsideDown]
        return orientation
    }
}
