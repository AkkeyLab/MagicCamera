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

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate, LTMorphingLabelDelegate {
    
    //New BLE
    var ble_new: Bool = true
    
    //Define
    let UUID_VSP: [CBUUID] = [CBUUID(string: "bd011f22-7d3c-0db6-e441-55873d44ef40")]
    let UUID_TX:   CBUUID  =  CBUUID(string: "2a750d7d-bd9a-928f-b744-7d5a70cef1f9")
    let UUID_RX:   CBUUID  =  CBUUID(string: "0503b819-c75b-ba9b-3641-6a7f338dd9bd")
    
    private var passIndicator: Bool = false
    //BLE
    private var ble_Uuids: NSMutableArray = NSMutableArray()
    private var ble_Names: NSMutableArray = NSMutableArray()
    private var ble_Peripheral: NSMutableArray = NSMutableArray()
    
    private var ble_CentralManager: CBCentralManager!
    private var ble_TargetPeripheral: CBPeripheral!
    
    //Indicator
    private let indicator = ActivityIndicator()
    private var indicatorBool = true

    //Text
    private let mainLabel: LTMorphingLabel = LTMorphingLabel()
    private var outStringCnt = 0
    
    //Debug
    private var debugButton: UIButton!
    
    
    override func viewDidAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onOrientationChange:", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        ble_CentralManager = CBCentralManager(delegate: self, queue: nil, options: nil)
        //Indicator
        indicator.start(self)
        
        makeParts()
    }
    
    func outString(){
        var textArray = ["MagicCamera", "will work", "in conjunction with", "MysticSD"]
        mainLabel.text = textArray[outStringCnt]
        
        if outStringCnt == 3 {
            outStringCnt = 0
        }else{
            outStringCnt++
        }
    }
    
    func onOrientationChange(notification: NSNotification){
        mainLabel.layer.position = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 3)
        debugButton.layer.position = CGPoint(x: self.view.frame.width - 50, y: self.view.frame.height - 50)
        if indicatorBool {
            indicator.activityIndicator.stopAnimating()
            indicator.start(self)
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
        debugButton.setTitle("＊", forState: UIControlState.Normal)
        debugButton.layer.cornerRadius = 10.0
        debugButton.layer.position = CGPoint(x: self.view.frame.width - 50, y: self.view.frame.height - 50)
        debugButton.alpha = 0.7
        debugButton.addTarget(self, action: "onClickButton:", forControlEvents: .TouchUpInside)
        self.view.addSubview(debugButton)
    }
    
    //BLE setting start. ++++++++++++++++++++++++++
    func centralManagerDidUpdateState(central: CBCentralManager) {
        switch(central.state){
        case .PoweredOff:
            NSLog("Bluetooth OFF")
            alert("Bluetooth OFF",messageString: "設定でBluetoothをオンにしてください", buttonString: "OK")
            //Setting open
            //let url = NSURL(string: UIApplicationOpenSettingsURLString)
            //UIApplication.sharedApplication().openURL(url!)
        case .PoweredOn:
            NSLog("Bluetooth ON")
            //BLE Start
            ble_CentralManager.scanForPeripheralsWithServices(UUID_VSP, options: nil)
        case .Resetting:
            NSLog("Resetting")
            alert("Resetting",messageString: "開発担当までご連絡ください", buttonString: "OK")
        case .Unauthorized:
            NSLog("Unauthorized")
            alert("Unauthorized",messageString: "開発担当までご連絡ください", buttonString: "OK")
        case .Unknown:
            NSLog("Unknown")
            alert("Unknown",messageString: "開発担当までご連絡ください", buttonString: "OK")
        case .Unsupported:
            NSLog("Unsupported")
            alert("Unsupported",messageString: "お使いの端末はBluetooth非対応です", buttonString: "OK")
        }
    }
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral,
        advertisementData: [String: AnyObject], RSSI: NSNumber) {
            //NSLog("centralManager")
            
            var name:NSString? = advertisementData["kCBAdvDataLocalName"] as? NSString
            if(name == nil){
                name = "No name"
            }
            ble_Names.addObject(name!)
            ble_Peripheral.addObject(peripheral)
            ble_Uuids.addObject(peripheral.identifier.UUIDString)
            
            if name == "BLESerial2" {
                //Indicator stop
                indicator.activityIndicator.stopAnimating()
                indicatorBool = false
                
                //View remove
                //removeAllSubviews(self.view, kind: "ble_start")
                
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
        
        //Find characteristics -> Go to "Find "Service" !"
        peripheral.delegate = self;
        peripheral.discoverServices(nil)
        
    }
    
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        //showNotification("MysticSDとの接続に失敗しました！")//MapCoreViewController class
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
            NSLog("Read value: \(bytes[0])")
            
            if(bytes[0] == 1){
                bootCamera()
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
            camera.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
            self.presentViewController(camera, animated: true, completion: nil)
            
        }else
        if UIDeviceOrientationIsPortrait(deviceOrientation){
            let camera: UIViewController = FrontCameraMode()
            camera.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
            self.presentViewController(camera, animated: true, completion: nil)
        }
    }
    
    internal func onClickButton(sender: UIButton){
        if sender == debugButton {
            bootCamera()
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

