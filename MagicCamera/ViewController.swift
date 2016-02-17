//
//  ViewController.swift
//  MagicCamera
//
//  Created by 板谷晃良 on 2015/12/24.
//  Copyright © 2015年 AkkeyLab. All rights reserved.
//

import UIKit
import CoreBluetooth
import LTMorphingLabel
import AVFoundation

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, LTMorphingLabelDelegate {
    
    //New BLE
    private var ble_new: Bool = true
    private var segcon: UISegmentedControl!
    
    //Define
    let UUID_VSP: [CBUUID] = [CBUUID(string: "bd011f22-7d3c-0db6-e441-55873d44ef40")]
    let UUID_TX:   CBUUID  =  CBUUID(string: "2a750d7d-bd9a-928f-b744-7d5a70cef1f9")
    let UUID_RX:   CBUUID  =  CBUUID(string: "0503b819-c75b-ba9b-3641-6a7f338dd9bd")
    
    private var passIndicator: Bool = false
    //BLE
    private var ble_CentralManager: CBCentralManager!
    private var ble_TargetPeripheral: CBPeripheral!
    private var ble_characteristic: CBCharacteristic!
    private let nowBLE = NowController()
    private let bleButton: UIButton = UIButton()
    private let swicth: UISwitch = UISwitch()
    private let bleB    = BLEButton()
    private var bleBool: Bool = false
    
    //Indicator
    private let indicator = ActivityIndicator()
    private var indicatorBool = true

    //Text
    private let mainLabel: LTMorphingLabel = LTMorphingLabel()
    private var outStringCnt = 0
    private var infoLabel: UILabel!
    private var switchLabel: UILabel!
    
    //Debug
    private var debugButton: UIButton!
    
    //Object
    private let modeSetting = ModeSetting()
    
    private var addImageButton: UIButton!
    
    
    override func viewDidAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onOrientationChange:", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        if modeSetting.getBle() {
            ble_CentralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: true])
            //Indicator
            indicatorBool = true
            indicator.start(self)
        }else{
            indicatorBool = false
        }
        
        makeParts()
        bleB.settingButton(self, button: self.bleButton)
    }
    
    func outString(){
        var textArray = ["MagicCamera", "will work", "in conjunction with", "MysticSD."]
        mainLabel.text = textArray[outStringCnt]
        
        if outStringCnt == 3 {
            outStringCnt = 0
        }else{
            outStringCnt++
        }
    }
    
    func onOrientationChange(notification: NSNotification){
        let x_size = UIScreen.mainScreen().bounds.size.width
        let y_size = UIScreen.mainScreen().bounds.size.height
        mainLabel.layer.position = CGPoint(x: x_size / 2, y: y_size / 3)
        debugButton.layer.position = CGPoint(x: x_size - 50, y: y_size - 50)
        infoLabel.layer.position = CGPoint(x: x_size / 2, y: (y_size / 2) + 50)
        bleButton.layer.position = CGPoint(x: 50, y: y_size - 50)
        segcon.center = CGPoint(x: x_size / 2, y: 50)
        addImageButton.layer.position = CGPoint(x: x_size - 50, y: 50)
        
        if indicatorBool {
            indicator.activityIndicator.stopAnimating()
            indicator.start(self)
        }
        
        //Now orientation
        let deviceOrientation: UIDeviceOrientation!  = UIDevice.currentDevice().orientation
        if UIDeviceOrientationIsPortrait(deviceOrientation) {
            infoLabel.text = "FaceTime camera mode"
        }else if UIDeviceOrientationIsLandscape(deviceOrientation) {
            infoLabel.text = "iSight camera mode"
        }else{
            infoLabel.text = "FaceTime camera mode"
        }
    }

    func makeParts(){
        mainLabel.delegate = self
        mainLabel.frame = CGRectMake(0, 0, 320, 200)
        mainLabel.textAlignment = NSTextAlignment.Center
        mainLabel.adjustsFontSizeToFitWidth = true
        mainLabel.layer.position = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 3)
        mainLabel.font = UIFont(name: "TimesNewRomanPSMT", size: 30)
        self.mainLabel.text = "Hello"
        self.view.backgroundColor = UIColor.whiteColor()
        mainLabel.textColor = UIColor.blackColor()
        self.view.addSubview(mainLabel)
        
        mainLabel.morphingEffect = .Scale
        NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "outString", userInfo: nil, repeats: true)
        
        debugButton = UIButton()
        debugButton.frame = CGRectMake(0, 0, 50, 50)
        debugButton.backgroundColor = UIColor.grayColor()
        debugButton.layer.masksToBounds = true
        debugButton.setTitle("GO", forState: UIControlState.Normal)
        debugButton.layer.cornerRadius = 10.0
        debugButton.layer.position = CGPoint(x: self.view.frame.width - 50, y: self.view.frame.height - 50)
        debugButton.alpha = 0.7
        debugButton.addTarget(self, action: "onClickButton:", forControlEvents: .TouchUpInside)
        self.view.addSubview(debugButton)
        
        infoLabel = UILabel(frame: CGRectMake(0, 0, 200, 50))
        infoLabel.text = "FaceTime camera mode"
        infoLabel.textAlignment = NSTextAlignment.Center
        infoLabel.layer.position = CGPoint(x: self.view.frame.width / 2, y: (self.view.frame.height / 2) + 50)
        self.view.addSubview(infoLabel)
        
        let array: NSArray = ["OpenCV","CIFaceFeature"]
        segcon = UISegmentedControl(items: array as [AnyObject])
        segcon.center = CGPoint(x: self.view.frame.width / 2, y: 50)
        segcon.backgroundColor = UIColor.whiteColor()
        segcon.tintColor = UIColor.blueColor()
        segcon.addTarget(self, action: "segconChanged:", forControlEvents: UIControlEvents.ValueChanged)
        if modeSetting.getMode() == "OpenCV" {
            segcon.selectedSegmentIndex = 0
        }else{
            segcon.selectedSegmentIndex = 1
        }
        self.view.addSubview(segcon)
        
        swicth.layer.position = CGPoint(x: 50, y: 50)
        swicth.tintColor = UIColor.grayColor()
        if modeSetting.getBle() {
            swicth.on = true
        }else{
            swicth.on = false
        }
        swicth.addTarget(self, action: "onClickSwicth:", forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(swicth)
        
        switchLabel = UILabel(frame: CGRectMake(0, 0, 100, 50))
        switchLabel.text = "MysticSD"
        switchLabel.font = UIFont.systemFontOfSize(10)
        switchLabel.textAlignment = NSTextAlignment.Center
        switchLabel.layer.position = CGPoint(x: 50, y: 75)
        self.view.addSubview(switchLabel)
        
        addImageButton = UIButton(type: UIButtonType.ContactAdd)
        addImageButton.layer.position = CGPoint(x: self.view.frame.width - 50, y: 50)
        addImageButton.addTarget(self, action: "onClickButton:", forControlEvents: .TouchUpInside)
        self.view.addSubview(addImageButton)
    }
    
    //BLE setting start. ++++++++++++++++++++++++++
    func centralManagerDidUpdateState(central: CBCentralManager) {
        switch(central.state){
        case .PoweredOff:
            NSLog("Bluetooth OFF")
        case .PoweredOn:
            //BLE Start
            ble_CentralManager.scanForPeripheralsWithServices(UUID_VSP, options: nil)
        case .Resetting:
            alert("Resetting",messageString: "開発担当までご連絡ください", buttonString: "OK")
        case .Unauthorized:
            alert("Unauthorized",messageString: "開発担当までご連絡ください", buttonString: "OK")
        case .Unknown:
            alert("Unknown",messageString: "開発担当までご連絡ください", buttonString: "OK")
        case .Unsupported:
            alert("Unsupported",messageString: "お使いの端末はBluetooth非対応です", buttonString: "OK")
        }
    }
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral,
        advertisementData: [String: AnyObject], RSSI: NSNumber) {
            //NSLog("centralManager")
            
            let name:NSString? = advertisementData["kCBAdvDataLocalName"] as? NSString
            
            if name == "BLESerial2" {
                //Indicator stop
                indicator.activityIndicator.stopAnimating()
                indicatorBool = false
                
                //Start connect
                self.ble_TargetPeripheral = peripheral
                ble_CentralManager.connectPeripheral(self.ble_TargetPeripheral, options: nil)
            }
    }
    
    //*** Swift 2 worning ***//
    //func centralManager(central: CBCentralManager, var didConnectPeripheral peripheral: CBPeripheral) {
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        //showNotification("MysticSDとの接続に成功しました！")//MapCoreViewController class
        ble_CentralManager.stopScan()
        
        bleBool = true
        bleButton.setTitle("^_^", forState: UIControlState.Normal)
        bleButton.backgroundColor = UIColor.redColor()
        
        //Find characteristics -> Go to "Find "Service" !"
        peripheral.delegate = self;
        peripheral.discoverServices(UUID_VSP)
        
    }
    
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        //showNotification("MysticSDとの接続に失敗しました！")//MapCoreViewController class
        alert("Error",messageString: "MysticSDとの接続に失敗しました", buttonString: "OK")
        ble_CentralManager.stopScan()
    }
    
    //Find "Service" !
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        NSLog("Find service!")
        
        let services: NSArray = peripheral.services!
        
        for obj in services{
            if let service = obj as? CBService{
                //Find characteristics -> Go to "Find "Characteristics" !"
                peripheral.discoverCharacteristics(nil, forService: service)
                
            }
        }
    }
    
    //Find "Characteristics" !
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        NSLog("Find characteristics!")
        
        let characteristics: NSArray = service.characteristics!
        
        for obj in characteristics{
            if let characteristic = obj as? CBCharacteristic{
                //First write successful -> Go to "First write result"
                
                let value: [UInt8] = [3];
                let data: NSData = NSData(bytes: value, length: sizeof(Int))
                
                /*
                var value: CUnsignedChar = 0x01
                let data: NSData = NSData(bytes: &value, length: 1)
                */
                peripheral.writeValue(data, forCharacteristic: characteristic, type: CBCharacteristicWriteType.WithoutResponse)
                
                // move to "First write result"
                //peripheral.readValueForCharacteristic(characteristic) // Read only once
                peripheral.setNotifyValue(true, forCharacteristic: characteristic) // Notify
                ble_characteristic = characteristic
            }
        }
    }
    
    //When call notify start and end
    func peripheral(peripheral: CBPeripheral, didUpdateNotificationStateForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        if error != nil{
            NSLog("Notify error")
        }else{
            NSLog("Notify success")
        }
    }
    
    //When call get data
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        
        if characteristic.UUID.isEqual(UUID_TX){
            //NSLog("Read success!!")
            let data = characteristic.value
            let ptr = UnsafePointer<UInt8>(characteristic.value!.bytes)
            let bytes = UnsafeBufferPointer<UInt8>(start:ptr, count:data!.length)
            //NSLog("Read value: \(bytes[0])")
            
            if(bytes[0] == 1){
                //ble_CentralManager.cancelPeripheralConnection(peripheral)
                
                if nowBLE.getNowBLE() {
                    bootCamera()
                }
            }
        }
    }
    
    //First write result
    func peripheral(peripheral: CBPeripheral!, didWriteValueForCharactertistic characteristic: CBCharacteristic!, error: NSError!){
        NSLog("First write result")
        //peripheral.readValueForCharacteristic(characteristic) // Read only once
        //peripheral.setNotifyValue(true, forCharacteristic: characteristic) // Notify
    }
    //BLE setting end. ++++++++++++++++++++++++++++
    
    func bootCamera(){
        //Now orientation
        let deviceOrientation: UIDeviceOrientation!  = UIDevice.currentDevice().orientation
    
        if UIDeviceOrientationIsLandscape(deviceOrientation) {
            let camera: UIViewController = BackCameraMode()
            camera.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
            self.presentViewController(camera, animated: true, completion: nil)
            
        }else
        if UIDeviceOrientationIsPortrait(deviceOrientation){
            let camera: UIViewController = FrontCameraMode()
            camera.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
            self.presentViewController(camera, animated: true, completion: nil)
        }else{
            let camera: UIViewController = FrontCameraMode()
            camera.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
            self.presentViewController(camera, animated: true, completion: nil)
        }
    }
    
    internal func onClickButton(sender: UIButton){
        if sender == debugButton {
            bootCamera()
        }else if(sender == addImageButton){
            usePicker()
        }else if(sender == bleButton){
            if bleBool {
                ble_TargetPeripheral.setNotifyValue(false, forCharacteristic: ble_characteristic) //cut notification
                ble_CentralManager.cancelPeripheralConnection(ble_TargetPeripheral) //cut ble
                bleBool = false
                bleButton.setTitle("-_-", forState: UIControlState.Normal)
                bleButton.backgroundColor = UIColor.blueColor()
            }else{
                if modeSetting.getBle() {
                    indicator.activityIndicator.stopAnimating()
                }
                ble_CentralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: true])
                //Indicator
                indicator.start(self)
                swicth.on = true
                modeSetting.setBle(true)
            }
        }
    }
    
    func usePicker(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            controller.allowsEditing = false
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    //func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, info: [String : AnyObject]?) {
        if info[UIImagePickerControllerOriginalImage] != nil {
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            //!! Option is CIDetectorAccuracy**
            let options : NSDictionary = NSDictionary(object: CIDetectorAccuracyHigh, forKey: CIDetectorAccuracy)
            let detector : CIDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: options as? [String : AnyObject])
            let faces : NSArray = detector.featuresInImage(CIImage(image: image)!)
            
            //point
            var transform : CGAffineTransform = CGAffineTransformMakeScale(1, -1)
            transform = CGAffineTransformTranslate(transform, 0, -image.size.height)
            
            var outcnt: Int = 0
            var outImage: UIImage = image
            //mark output
            let feature : CIFaceFeature = CIFaceFeature()
            for feature in faces {
                outcnt++
                let faceRect : CGRect = CGRectApplyAffineTransform(feature.bounds, transform)
                let faceOutlineImage = UIImage(named: "ios_face.png")
                
                UIGraphicsBeginImageContext(CGSizeMake(image.size.width, image.size.height))
                image.drawAtPoint(CGPointMake(0, 0))
                faceOutlineImage!.drawInRect(faceRect)
                outImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
            }
            
            if outcnt != 0 {
                UIImageWriteToSavedPhotosAlbum(outImage, self, nil, nil)
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate)) //Vibrate
            }
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    internal func segconChanged(segcon: UISegmentedControl){
        
        switch segcon.selectedSegmentIndex {
        case 0:
            modeSetting.setMode("OpenCV")
            
        case 1:
            modeSetting.setMode("CIFaceFeature")
            
        default:
            NSLog("Error")
        }
    }
    
    internal func onClickSwicth(sender: UISwitch){
        
        if sender.on {
            modeSetting.setBle(true)
            //Indicator
            indicatorBool = true
            indicator.start(self)
        }
        else {
            modeSetting.setBle(false)
        }
    }
    
    func alert(titleString: String, messageString: String, buttonString: String){
        //Create UIAlertController
        let alert: UIAlertController = UIAlertController(title: titleString, message: messageString, preferredStyle: .Alert)
        //Create action
        let action = UIAlertAction(title: buttonString, style: .Default) { action in
            NSLog("\(titleString):Push button!")
        }
        //Add action
        alert.addAction(action)
        //Start
        presentViewController(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

