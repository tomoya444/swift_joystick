//
//  StudyViewController2.swift
//  UXSDKSwiftSample
//
//  Created by Tomoya Usui on 2023/11/15.
//  Copyright © 2023 DJI. All rights reserved.
//

/*
import UIKit
import DJISDK
import CoreBluetooth
import CoreLocation
import CDJoystick
import DJIUXSDK




class StudyViewController2: UIViewController,BluetoothManagerDelegate,DJISDKManagerDelegate,CLLocationManagerDelegate{
    
    
    func didUpdateDatabaseDownloadProgress(_ progress: Progress) {
        
    }
    var virtualSticksController = VirtualSticksController()
    
    var flightController: DJIFlightController?
    var locationManager = CLLocationManager()
    var missionOperator: DJIWaypointMissionOperator? // Hotpointミッションのための変数
    
    //kokodaiji 10/10*****************
    //var cameraView: CameraViewController?
    //var rectangleView: RectangleView?
    
    
    //この３つはvirtualstickに関するやつ
    @IBOutlet weak var leftJoystick: CDJoystick!
    @IBOutlet weak var rightJoystick: CDJoystick!
    
    @IBOutlet weak var orbitbutton: UIButton!
    @IBOutlet weak var Horizonorbitbutton: UIButton!
    @IBOutlet weak var rollleftrightbutton: UIButton!
    @IBOutlet weak var pitchbutton: UIButton!
    @IBOutlet weak var thottlebutton: UIButton!
    @IBOutlet weak var yawbutton: UIButton!
    @IBOutlet weak var orignalbutton: UIButton!
    @IBOutlet weak var cordinatesegmented: UISegmentedControl!
    @IBOutlet weak var rollpitchsegmented: UISegmentedControl!
    @IBOutlet weak var yawsegmented: UISegmentedControl!
    @IBOutlet weak var yawslider: UISlider!
    
    @IBOutlet weak var yawLabel: UILabel!
    
    //半径と高さに関するラベル
    
    var timer: Timer?
    
    var radians: Float = 0.0
    var velocity: Float = 0.1
    var x: Float = 0.0
    var y: Float = 0.0
    var z: Float = 0.0
    var ya: Float = 0.0
    var yaw: Float = 0.0
    var yawSpeed: Float = 180.0
    var throttle: Float = 0.0
    var roll: Float = 0.0
    var pitch: Float = 0.0
    
    var flightMode: FLIGHT_MODE?
    
    var camera: DJICamera?
    var bluetoothManager: BluetoothManager!
    var mappedValue1: Int = 0 // mappedValueをプロパティとして定義
    var mappedValue2: Int = 0
    var mappedValue3: Int = 0
    var mappedValue4: Int = 0
    var mappedValue5: Int = 0
    var mappedValue6: Int = 0
    var mappedValue7: Int = 0
    var mappedValue8: Int = 0
    
    var speed: Float = 0.0
    var speed2: Float = 0.0
    var speed3: Float = 0.0
    var speed4: Float = 0.0
    var speed5: Float = 0.0
    var speed6: Float = 0.0
    var speed7: Float = 0.0
    var speed8: Float = 0.0
    
    var mutableJoystickData_x: Float = 0.0
    
    var isRecording: Bool = false
    
    fileprivate var _isSimulatorActive: Bool = false
    public var isSimulatorActive: Bool {
        get {
            return _isSimulatorActive
        }
        set {
            _isSimulatorActive = newValue
        }
    }
    @IBOutlet weak var simulatorSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let serviceUUID = "f7355c47-0b31-0360-4a2a-8d50c12be45a"
        let serviceUUID2 = "f7355c47-0b31-0360-4a2a-8d50c12be45b"
        
        let characteristicUUID = "beb5483e-36e1-4688-b7f5-ea07361b26a8"
        let characteristicUUID2 = "beb5483e-36e1-4688-b7f5-ea07361b26a9"
        let characteristicUUID3 = "beb5483e-36e1-4688-b7f5-ea07361b26b1"
        let characteristicUUID4 = "beb5483e-36e1-4688-b7f5-ea07361b26b2"
        let characteristicUUID5 = "aeb5483e-36e1-4688-b7f5-ea07361b26a8"
        let characteristicUUID6 = "aeb5483e-36e1-4688-b7f5-ea07361b26a9"
        let characteristicUUID7 = "aeb5483e-36e1-4688-b7f5-ea07361b26b1"
        let characteristicUUID8 = "aeb5483e-36e1-4688-b7f5-ea07361b26b2"
        
        bluetoothManager = UXSDKSwiftSample.BluetoothManager(serviceUUID: serviceUUID, serviceUUID2: serviceUUID2, characteristicUUID: characteristicUUID, characteristicUUID2: characteristicUUID2, characteristicUUID3: characteristicUUID3, characteristicUUID4: characteristicUUID4, characteristicUUID5: characteristicUUID5, characteristicUUID6: characteristicUUID6, characteristicUUID7: characteristicUUID7, characteristicUUID8: characteristicUUID8,delegate: self)
        valueLabel.text = "No Value"
        valueLabel2.text = "No Value"
        valueLabel3.text = "No Value"
        valueLabel4.text = "No Value"
        valueLabel5.text = "No Value"
        valueLabel6.text = "No Value"
        valueLabel7.text = "No Value"
        valueLabel8.text = "No Value"
        
        statusLabel.text = "Not Connected"
        
        //viewの方の細かい設定
        yawslider.isHidden = true
        
        //kokodaiji 10/10**********
        // カメラビューを作成
        //cameraView = DUXDefaultLayoutViewController()

        // RectangleViewを作成
        //rectangleView = RectangleView(frame: CGRect(x: 180, y: 40, width: 500, height: 240))
        // 初期位置やサイズを設定
        //rectangleView?.targetRect = CGRect(x: 50, y: 50, width: 100, height: 100)
        //view.addSubview(rectangleView!)
        
        // `UIPinchGestureRecognizer` を追加し、`handlePinch` メソッドをセットアップします
        //var pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
       //rectangleView!.addGestureRecognizer(pinchGestureRecognizer)
        

        // カメラビューを表示
        //addChild(cameraView!)
        //view.addSubview(cameraView!.view)
        //cameraView!.didMove(toParent: self)

        // RectangleViewを表示
        //view.addSubview(rectangleView!)
        
        // カメラ映像を表示するコードを追加
        /*
        if let cameraView = cameraView {
            let videoView = cameraView.getFPVWidget()
            // ビデオビューを表示するビューに配置
            videoView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
            videoView.contentMode = .scaleAspectFit
            view.addSubview(videoView)
        }
         */
        
        
        // DJISDKManagerの初期化
        DJISDKManager.registerApp(with: self)
        //virtualSticksController.startVirtualStick()
        //virtualSticksController.startAdvancedVirtualStick()
        //let isVirtualStickEnabled = virtualSticksController.isVirtualStick()
        //let isAdvancedVirtualStickEnabled = virtualSticksController.isVirtualStickAdvanced()
        
        // スマホのGPS情報を取得するための準備
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // ミッションオペレータを初期化
        missionOperator = DJISDKManager.missionControl()?.waypointMissionOperator()
        
        // Grab a reference to the aircraft
        if let aircraft = DJISDKManager.product() as? DJIAircraft {
            
            // Grab a reference to the flight controller
            if let fc = aircraft.flightController {
                
                // Store the flightController
                self.flightController = fc
                
                print("We have a reference to the FC")
                
                // Default the coordinate system to ground
                self.flightController?.rollPitchCoordinateSystem = DJIVirtualStickFlightCoordinateSystem.body
                
                // Default roll/pitch control mode to velocity
                self.flightController?.rollPitchControlMode = DJIVirtualStickRollPitchControlMode.velocity
                
                // Set control modes
                self.flightController?.yawControlMode = DJIVirtualStickYawControlMode.angularVelocity
            }
            
        }
        
        // Setup joysticks
        // Throttle/yaw
        leftJoystick.trackingHandler = { joystickData in
            self.yaw = Float(joystickData.velocity.x) * self.yawSpeed
            /*
             let deadzone = 0.1
             if abs(joystickData.velocity.x) > deadzone {
             self.yaw += Float(joystickData.velocity.x) * 180
             while self.yaw > 180 {
             self.yaw -= 360
             }
             while self.yaw < -180 {
             self.yaw += 360
             }
             }
             
             self.yaw = Float(joystickData.velocity.x) * self.yawSpeed
             */
            print("yaw value\(self.yaw)")
            self.throttle = Float(joystickData.velocity.y) * 5.0 * -1.0 * 0.5 // inverting joystick for throttle
            print("throttle value\(self.throttle)")
            //self.sendControlData(x: 0, y: 0, z: 0, ya: self.yaw)
            self.sendControlData(x: 0, y: 0, z: 0, ya: 0)
            
        }
        
        // Pitch/roll
        rightJoystick.trackingHandler = { joystickData in
            //self.mutableJoystickData_x = Float(joystickData.velocity.x)
            self.pitch = Float(joystickData.velocity.y) * 1.0 * 0.5
            //self.roll = self.mutableJoystickData_x * 1.0 * 0.5 * (-1.0)
            self.roll = Float(joystickData.velocity.x) * 1.0 * 0.5 * (-1.0)
            print("pitch value\(self.pitch)")
            print("roll value\(self.roll)")
            //print(" mappedvalue3" , self.mappedValue3)
            // if self.mappedValue3 > 50{
            //self.mutableJoystickData_x = Float(CGFloat(self.speed3 * 1.0 ))
            
            //}
            //self.roll = self.mutableJoystickData_x * 1.0 * 0.5 * (-1.0)
            self.sendControlData(x: 0, y: 0, z: 0, ya: 0)
        }
        
    }
    
    // User clicks the enter virtual sticks button
    //これは絶対に必要
    @IBAction func enableVirtualSticks(_ sender: Any) {
        toggleVirtualSticks(enabled: true)
    }
    
    // User clicks the exit virtual sticks button
    //これは絶対に必要
    @IBAction func disableVirtualSticks(_ sender: Any) {
        toggleVirtualSticks(enabled: false)
    }
    
    // Handles enabling/disabling the virtual sticks
    private func toggleVirtualSticks(enabled: Bool) {
        
        // Let's set the VS mode
        self.flightController?.setVirtualStickModeEnabled(enabled, withCompletion: { (error: Error?) in
            
            // If there's an error let's stop
            guard error == nil else { return }
            
            print("Are virtual sticks enabled? \(enabled)")
            
        })
        
    }
    
    @IBAction func rollLeftRight(_ sender: Any) {
        setupFlightMode()
        flightMode = FLIGHT_MODE.ROLL_LEFT_RIGHT
        
        // Schedule the timer at 20Hz while the default specified for DJI is between 5 and 25Hz
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(timerLoop), userInfo: nil, repeats: true)
    }
    
    @IBAction func pitchForwardBack(_ sender: Any) {
        setupFlightMode()
        flightMode = FLIGHT_MODE.PITCH_FORWARD_BACK
        
        // Schedule the timer at 20Hz while the default specified for DJI is between 5 and 25Hz
        // Note: changing the frequency will have an impact on the distance flown so BE CAREFUL
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(timerLoop), userInfo: nil, repeats: true)
    }
    
    @IBAction func throttleUpDown(_ sender: Any) {
        setupFlightMode()
        flightMode = FLIGHT_MODE.THROTTLE_UP_DOWN
        
        // Schedule the timer at 20Hz while the default specified for DJI is between 5 and 25Hz
        // Note: changing the frequency will have an impact on the distance flown so BE CAREFUL
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(timerLoop), userInfo: nil, repeats: true)
    }
    
    @IBAction func horizontalOrbit(_ sender: Any) {
        setupFlightMode()
        flightMode = FLIGHT_MODE.HORIZONTAL_ORBIT
        
        // Schedule the timer at 20Hz while the default specified for DJI is between 5 and 25Hz
        // Note: changing the frequency will have an impact on the distance flown so BE CAREFUL
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(timerLoop), userInfo: nil, repeats: true)
    }
    
    @IBAction func verticalOrbit(_ sender: Any) {
        setupFlightMode()
        flightMode = FLIGHT_MODE.VERTICAL_ORBIT
        
        // Schedule the timer at 20Hz while the default specified for DJI is between 5 and 25Hz
        // Note: changing the frequency will have an impact on the distance flown so BE CAREFUL
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(timerLoop), userInfo: nil, repeats: true)
    }
    
    @IBAction func sendYaw() {
        setupFlightMode()
        flightMode = FLIGHT_MODE.YAW
        
        //timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(timerLoop), userInfo: nil, repeats: true)
        
        sendControlData(x: 0, y: 0, z: 0, ya: 0)
        
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(yawLoop), userInfo: nil, repeats: true)
    }
    
    @IBAction func originakorbit() {
        setupFlightMode()
        flightMode = FLIGHT_MODE.ORIGINAL_CIRCLE
        
        // Schedule the timer at 20Hz while the default specified for DJI is between 5 and 25Hz
        // Note: changing the frequency will have an impact on the distance flown so BE CAREFUL
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(timerLoop), userInfo: nil, repeats: true)
        
    }
    // Change the coordinate system between ground/body and observe the behavior
    // HIGHLY recommended to test first in the iOS simulator to observe the values in timerLoop and then test outdoors
    //フライトモードを変更するところ
    @IBAction func changeCoordinateSystem(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            self.flightController?.rollPitchCoordinateSystem = DJIVirtualStickFlightCoordinateSystem.ground
        } else if sender.selectedSegmentIndex == 1 {
            self.flightController?.rollPitchCoordinateSystem = DJIVirtualStickFlightCoordinateSystem.body
        }
        
    }
    
    // Change the control mode between velocity/angle and observe the behavior
    // HIGHLY recommended to test first in the iOS simulator to observe the values in timerLoop and then test outdoors
    @IBAction func changeRollPitchControlMode(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            self.flightController?.rollPitchControlMode = DJIVirtualStickRollPitchControlMode.velocity
        } else if sender.selectedSegmentIndex == 1 {
            self.flightController?.rollPitchControlMode = DJIVirtualStickRollPitchControlMode.angle
        }
    }
    
    // Change the yaw control mode between angular velocity and angle
    @IBAction func changeYawControlMode(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            self.flightController?.yawControlMode = DJIVirtualStickYawControlMode.angularVelocity
            print("angularvelocity")
        } else if sender.selectedSegmentIndex == 1 {
            self.flightController?.yawControlMode = DJIVirtualStickYawControlMode.angle
            print("angula")
        }
    }
    
    @IBAction func setYawAngularVelocity(_ slider: UISlider) {
        
        //self.yawSpeed = slider.value
        //yawLabel.text = "\(slider.value)"
        
    }
    
    var count = 0
    
    @objc func yawLoop() {
        
        sendControlData(x: x, y: y, z: z, ya: yaw)
        
        // Based on 20 hz
        if count > 60 {
            self.timer?.invalidate()
            self.count = 0
            print("done counting")
        }
        
        count = count + 1
        
    }
    
    
    // Timer loop to send values to the flight controller
    // It's recommend to run this in the iOS simulator to see the x/y/z values printed to the debug window
    @objc func timerLoop() {
        
        // Add velocity to radians before we do any calculation
        radians += velocity
        
        // Determine the flight mode so we can set the proper values
        switch flightMode {
        case .ROLL_LEFT_RIGHT:
            x = 0.1*cos(radians)
            y = 0
            z = 0
            //yaw = 0 let's see if this yaws while rolling
        case .PITCH_FORWARD_BACK:
            x = 0
            y = 0.1*sin(radians)
            z = 0
            ya = 0
        case .THROTTLE_UP_DOWN:
            x = 0
            y = 0
            z = 0.1*sin(radians)
            ya = 0
        case .HORIZONTAL_ORBIT:
            x = cos(radians)
            y = sin(radians)
            z = 0
            ya = 0
        case .VERTICAL_ORBIT:
            x = cos(radians)
            y = 0
            z = sin(radians)
            ya = 0
        case .YAW:
            x = 0
            y = 0
            z = 0
        case .ORIGINAL_CIRCLE:
            x = 0.5
            y = 0
            z = 0
            ya = 0.5
            break
        case .VERTICAL_SINE_WAVE:
            break
        case .HORIZONTAL_SINE_WAVE:
            break
        case .none:
            break
        }
        
        sendControlData(x: x, y: y, z: z, ya: yaw)
        
    }
    
    private func sendControlData(x: Float, y: Float, z: Float, ya: Float) {
        print("Sending x: \(x), y: \(y), z: \(z), yaw: \(yaw)")
        
        // Construct the flight control data object
        var controlData = DJIVirtualStickFlightControlData()
        controlData.verticalThrottle = throttle // in m/s
        //rollとpitchがうまくいかないから反転
        controlData.roll = pitch
        controlData.pitch = roll
        controlData.yaw = yaw
        
        // Send the control data to the FC
        self.flightController?.send(controlData, withCompletion: { (error: Error?) in
            
            // There's an error so let's stop
            if error != nil {
                
                print("Error sending data")
                
                // Disable the timer
                self.timer?.invalidate()
            }
            
        })
    }
    
    // Called before any new flight mode is initiated
    private func setupFlightMode() {
        
        // Reset radians
        radians = 0.0
        
        // Invalidate timer if necessary
        // This allows switching between flight modes
        if timer != nil {
            print("invalidating")
            timer?.invalidate()
        }
    }
    //ここまでがvirtualstickの設定
    //*************************
    
    
    
    // DJISDKManagerDelegateのメソッド
    @objc func appRegisteredWithError(_ error: Error?) {
        if error != nil {
            print("SDK registration failed: \(error!)")
        } else {
            print("SDK registration successful")
            // 製品（ドローン）の取得
            let product = DJISDKManager.product()
            
            if product?.isKind(of: DJIAircraft.self) ?? false {
                // ドローンのFlightControllerを取得
                if let aircraft = product as? DJIAircraft {
                    flightController = aircraft.flightController
                    camera = aircraft.camera
                    
                }
            }
        }
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        //virtualSticksController.stopVirtualStick()
        //virtualSticksController.stopAdvancedVirtualStick()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBOutlet weak var valueLabel: UILabel! // 値を表示するためのUILabel
    @IBOutlet weak var valueLabel2: UILabel!
    @IBOutlet weak var valueLabel3: UILabel!
    @IBOutlet weak var valueLabel4: UILabel!
    @IBOutlet weak var valueLabel5: UILabel!
    @IBOutlet weak var valueLabel6: UILabel!
    @IBOutlet weak var valueLabel7: UILabel!
    @IBOutlet weak var valueLabel8: UILabel!
    
    //仮定の半径と高さ
    @IBOutlet weak var currentdis: UILabel!
    @IBOutlet weak var currenthei: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel! // 値を表示するためのUILabel
    @IBOutlet weak var takeoffbutton: UIButton!
    @IBOutlet weak var landbutton: UIButton!
    @IBOutlet weak var moveforwardbutton: UIButton!
    @IBOutlet weak var circlebutton: UIButton!
    @IBOutlet weak var startpointmissionbutton: UIButton!
    // BluetoothManagerDelegateのメソッドの実装
    //************
    @objc(bluetoothManager:didReceiveValue1:) func bluetoothManager(_ bluetoothManager: BluetoothManager, didReceiveValue1 value1: Int8) {
        if value1 >= -127 {
            //print("Received value: \(value)")
            mappedValue1 = Int(value1) + 127 // 値のマッピング
            speed = Float(mappedValue1) / 255.0
            
            
            //virtualSticksController.vsMove(pitch: speed, roll: 0.0, yaw: 0.0, vertical: 0.0)
            
            //print("Mapped value: \(mappedValue)")
            self.statusLabel.text = "connected"
            // 値をUIに表示する
            DispatchQueue.main.async {
                self.valueLabel.text = "左足の前方向: \(self.mappedValue1)"
                
            }
            
            if mappedValue1 > 50{
                //0.5がちょうどいい。室内だったら感度悪めで
                //self.pitch = speed * 1.0 * 0.3 * (-1.0) * (-1.0)
                //self.sendControlData(x: 0, y: 0, z: 0, ya: 0)
                //これはできてない
                //下２行はプレゼン用
                print("send command of increaseHeight")
                increaseHeight(sensorValue: Float(speed))
                
                //比較実験用
                //self.sendControlData(x: 0, y: speed * 0.3, z: 0, ya: 0)
                //self.pitch = speed * 0.3
                //self.sendControlData(x: 0, y: 0, z: 0, ya: 0)
            }
        }
        
        
    }
    func bluetoothManager(_ BluetoothManager: BluetoothManager, didReceiveValue2 value2: Int8){
        if value2 >= -127{
            mappedValue2 = Int(value2) + 127 // 値のマッピング
            speed2 = Float(mappedValue2) / 255.0
            //virtualSticksController.vsMove(pitch: speed2, roll: 0.0, yaw: 0.0, vertical: 0.0)
            // 値をUIに表示する
            DispatchQueue.main.async {
                self.valueLabel2.text = "左足の後方向: \(self.mappedValue2)"
                
            }
            
            
            if mappedValue2 > 50{
                
                //self.pitch = speed2 * 1.0 * 0.3 * (-1.0)
                //self.sendControlData(x: 0, y: 0, z: 0, ya: 0)
                //下１行プレゼン用
                print("send command of decreaseHeight")
                decreaseHeight(sensorValue: Float(speed2))
                
                //比較実験用
                //self.sendControlData(x: -speed2 * 0.3, y: 0, z: 0, ya: 0)
                //self.pitch = -speed2 * 0.3
                //self.sendControlData(x: 0, y: 0, z: 0, ya: 0)
            }
        }
    }
    
    func bluetoothManager(_ BluetoothManager: BluetoothManager, didReceiveValue3 value3: Int8){
        if value3 >= -127{
            mappedValue3 = Int(value3) + 127 // 値のマッピング
            speed3 = Float(mappedValue3) / 255.0
            //virtualSticksController.vsMove(pitch: speed2, roll: 0.0, yaw: 0.0, vertical: 0.0)
            // 値をUIに表示する
            DispatchQueue.main.async {
                self.valueLabel3.text = "右足の右方向: \(self.mappedValue3)"
                
            }
            
            
            if mappedValue3 > 50{
                //print("send command of cir_left")
                //これはできてる
                //プレゼン用
                moveInCircle_left(sensorValue: Float(speed3))
                
                //self.roll = speed3 * 1.0 * 0.3
                //self.sendControlData(x: 0, y: 0, z: 0, ya: 0)
                /*let joystickMaxRange: CGFloat = 1.0 // ジョイスティックの最大範囲を1.0とする
                 let joystickPositionX = CGFloat(speed3) * joystickMaxRange
                 let joystickData = CGPoint(x: joystickPositionX, y: 0.0) // yは0とする
                 
                 rightJoystick.updateStickPosition(usingSensorData: joystickData)
                 */
                
                //比較実験用
                //self.sendControlData(x: speed3 * 0.3, y: 0, z: 0, ya: 0)
                //self.roll = speed3 * 0.3
                //self.sendControlData(x: 0, y: 0, z: 0, ya: 0)
                
            }
        }
    }
    
    func bluetoothManager(_ BluetoothManager: BluetoothManager, didReceiveValue4 value4: Int8){
        if value4 >= -127{
            mappedValue4 = Int(value4) + 127 // 値のマッピング
            speed4 = Float(mappedValue4) / 255.0
            //virtualSticksController.vsMove(pitch: speed2, roll: 0.0, yaw: 0.0, vertical: 0.0)
            // 値をUIに表示する
            DispatchQueue.main.async {
                self.valueLabel4.text = "右足の左方向: \(self.mappedValue4)"
                
            }
            
            
            if mappedValue4 > 50{
                //これもできてる
                //プレゼン用
                moveInCircle_right(sensorValue: Float(speed4))
                
                //下２行無視
                //self.roll = speed4 * 1.0 * 0.3 * (-1.0)
                //self.sendControlData(x: 0, y: 0, z: 0, ya: 0)
                
                //比較実験用
                //self.sendControlData(x: -speed4 * 0.3, y: 0, z: 0, ya: 0)
               // self.roll = -speed4 * 0.3
                //self.sendControlData(x: 0, y: 0, z: 0, ya: 0)
            }
        }
    }
    
    //value5からは右足のセンサ
    var startTimeWhenValueIs255: Date?
    var thresholdTime: TimeInterval = 3.0
    
    func bluetoothManager(_ BluetoothManager: BluetoothManager, didReceiveValue5 value5: Int8){
        if value5 >= -127{
            mappedValue5 = Int(value5) + 127 // 値のマッピング
            speed5 = Float(mappedValue5) / 255.0
            
            //ここから３秒間最大値だと離陸を行うコマンドを実行する
            if mappedValue5 == 255 {
                if startTimeWhenValueIs255 == nil{
                    startTimeWhenValueIs255 = Date()
                } else {
                    let elapsedTime = Date().timeIntervalSince(startTimeWhenValueIs255!)
                    if elapsedTime >= thresholdTime {
                        flightController?.startTakeoff(completion: nil)
                    }
                }
            } else {
                startTimeWhenValueIs255 = nil
            }
            
            // 値をUIに表示する
            DispatchQueue.main.async {
                self.valueLabel5.text = "右足の前方向: \(self.mappedValue5)"
                
            }
        }
    }
    
    func bluetoothManager(_ BluetoothManager: BluetoothManager, didReceiveValue6 value6: Int8){
        if value6 >= -127{
            mappedValue6 = Int(value6) + 127 // 値のマッピング
            speed6 = Float(mappedValue6) / 255.0
            
            //ここから３秒間最大値だと離陸を行うコマンドを実行する
            if mappedValue6 == 255 {
                if startTimeWhenValueIs255 == nil{
                    startTimeWhenValueIs255 = Date()
                } else {
                    let elapsedTime = Date().timeIntervalSince(startTimeWhenValueIs255!)
                    if elapsedTime >= thresholdTime {
                        flightController?.startLanding(completion: nil)
                    }
                }
            } else {
                startTimeWhenValueIs255 = nil
            }
            // 値をUIに表示する
            DispatchQueue.main.async {
                self.valueLabel6.text = "右足の後方向: \(self.mappedValue6)"
                
            }
        }
    }
    
    func bluetoothManager(_ BluetoothManager: BluetoothManager, didReceiveValue7 value7: Int8){
        if value7 >= -127{
            mappedValue7 = Int(value7) + 127 // 値のマッピング
            speed7 = Float(mappedValue7) / 255.0
            //virtualSticksController.vsMove(pitch: speed2, roll: 0.0, yaw: 0.0, vertical: 0.0)
            // 値をUIに表示する
            DispatchQueue.main.async {
                self.valueLabel7.text = "右足の右方向: \(self.mappedValue7)"
                
            }
        }
    }
    
    func bluetoothManager(_ BluetoothManager: BluetoothManager, didReceiveValue8 value8: Int8){
        if value8 >= -127{
            mappedValue8 = Int(value8) + 127 // 値のマッピング
            speed8 = Float(mappedValue8) / 255.0
            //virtualSticksController.vsMove(pitch: speed2, roll: 0.0, yaw: 0.0, vertical: 0.0)
            // 値をUIに表示する
            DispatchQueue.main.async {
                self.valueLabel8.text = "右足の左方向: \(self.mappedValue8)"
                
            }
        }
    }
    
    
    //*************
    
    @IBAction func takeoffButtonTapped(_ sender: UIButton) {
        flightController?.startTakeoff(completion: nil)
        var currentHeight = 1.2
        var currentDistance = 3.0
    }
    @IBAction func landButtonTapped(_ sender: UIButton) {
        flightController?.startLanding(completion: nil)
    }
    
    //高さに応じた半径（水平距離）を求めるプログラム
    func computeDistanceForHeight(h: Float) -> Float {
        let pi = Float.pi
        let angleInRadians = 30 * pi / 180
        let distance = h / tan(angleInRadians)
        return distance
    }
    //初期位置　高さ1.2m 半径3.0m
    var currentHeight: Float = 1.2
    var currentDistance: Float = 3.0

    /*
    //@IBOutlet weak var videoPreviewView: UIView!
    //@IBOutlet var contentView: DUXContentView?
    // 以下の `handlePinch` メソッドでジェスチャーを処理します
    /*
    @objc func handlePinch(_ recognizer: UIPinchGestureRecognizer) {
        print("Pinch gesture recognized")
        if recognizer.state == .changed {
            let scale = recognizer.scale
            let newWidth = rectangleView!.targetRect.width * scale
            let newHeight = rectangleView!.targetRect.height * scale

            // 四角形の最小サイズを設定する場合、ここでチェックできます
            if newWidth >= 50.0 && newHeight >= 50.0 {
                rectangleView!.targetRect.size = CGSize(width: newWidth, height: newHeight)
                rectangleView!.setNeedsDisplay()
            }
        }
    }
    */
    // アクティブトラックミッションオペレーターを取得
    var activeTrackMissionOperator = DJISDKManager.missionControl()?.activeTrackMissionOperator

    // プロパティを初期化する
    var activeTrackMission = DJIActiveTrackMission()
    var targetRect = CGRect.zero
    var currentState: DJIActiveTrackMissionState?
    var trackingMode: DJIActiveTrackMode?
    
    
    // アクティブトラックミッションを開始
    func start(_ mission: DJIActiveTrackMission?, withCompletion completion: DJICompletionBlock) {
    }
    // ステップ1: アプリケーションのUIからトラッキング対象を選択
    func userSelectedTarget() {
        // ユーザーがトラッキング対象を選択した場合、その位置情報を取得
        var selectedRect = targetRect// ユーザーが選択したトラッキング対象の位置情報 (CGRectなど)

        // ステップ2: DJIActiveTrackMissionのtargetRectを設定
        activeTrackMission.targetRect = selectedRect

        // ステップ3: アクティブトラックミッションを開始
        start(activeTrackMission) { error in
            if let error = error {
                print("アクティブトラックミッションの開始に失敗しました: \(error.localizedDescription)")
            } else {
                print("アクティブトラックミッションを開始しました")
            }
        }

    }
    
    var startPoint: CGPoint? // startPointを宣言
    // ステップ2: タッチジェスチャーを検出
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self.view)
            // タッチ位置情報を保存
            startPoint = location
        }
    }

    // ステップ3: タッチ位置情報を使用してトラッキング対象の矩形を指定
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self.view)
            if let startPoint = startPoint {
                let endPoint = location
                // startPointとendPointを使用してトラッキング対象の矩形を指定
                targetRect = CGRect(x: min(startPoint.x, endPoint.x),
                                    y: min(startPoint.y, endPoint.y),
                                    width: abs(endPoint.x - startPoint.x),
                                    height: abs(endPoint.y - startPoint.y))
                
                // ステップ4: アクティブトラックミッションにトラッキング対象を設定
                activeTrackMission.targetRect = targetRect
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !targetRect.isEmpty {
            // ここで `trackingRect` を `selectedRect` に設定し、アクティブトラックミッションを開始するコードを追加します
            userSelectedTarget()
        }
    }
     
    */


    
    
    
    //高さを上げつつ後退させる関数
    func increaseHeight(sensorValue: Float) {
        
        let newHeight = currentHeight + sensorValue
        let newDistance = computeDistanceForHeight(h: newHeight)
        
        let distanceToMoveBackward = newDistance - currentDistance
        // distanceToMoveBackward分だけドローンを後退させる
        //sendControlData(x: 0, y: -distanceToMoveBackward, z: sensorValue, ya: 0)
        //比較実験用
        /*
        self.pitch = -sensorValue * 0.4
        self.roll = 0.0
        print("pitch value\(self.pitch)")
        print("roll value\(self.roll)")
        sendControlData(x: 0, y: 0, z: 0, ya: 0)
        currentHeight = newHeight
        currentDistance = newDistance
        */
        
        self.roll = 0
        self.throttle = sensorValue * 0.5 * 0.5
        self.pitch = -sensorValue * 0.5
        self.currentdis.text = "半径: \(self.currentDistance)"
        self.currentdis.text = "高さ: \(self.currentHeight)"
    }
    //高さを下げつつ前進させる関数
    func decreaseHeight(sensorValue: Float) {
        let newHeight = currentHeight - sensorValue
        let newDistance = computeDistanceForHeight(h: newHeight)
        
        let distanceToMoveForward = currentDistance - newDistance
        // distanceToMoveBackward分だけドローンを前進させる
        //sendControlData(x: 0, y: distanceToMoveForward, z: -sensorValue, ya: 0)
        //比較実験用
        /*
        self.pitch = sensorValue * 0.4
        self.roll = 0.0
        print("pitch value\(self.pitch)")
        print("roll value\(self.roll)")
        sendControlData(x: 0, y: 0, z: 0, ya: 0)
         */
        
        currentHeight = newHeight
        currentDistance = newDistance
        self.roll = 0
        self.throttle = -sensorValue * 0.5 * 0.5
        self.pitch = sensorValue * 0.5
        self.currentdis.text = "半径: \(self.currentDistance)"
        self.currentdis.text = "高さ: \(self.currentHeight)"
    }
    //円周上に右移動させるコマンド
    func moveInCircle_right(sensorValue: Float) {
        print("right circle command")
        let desiredSpeed = sensorValue
        
        let timeToCompleteCircle = 2 * Float.pi * currentDistance / desiredSpeed
        //let timeToCompleteCircle = 2 * Float.pi * 3 / desiredSpeed
        let yawSpeed = 360 * 0.5 / timeToCompleteCircle
        
        // rollValueはドローンの実際の速度に影響するので、これはドローンの具体的な性能に応じて調整する必要があります。
        // ここでは、desiredSpeedの10%としていますが、これは仮定されています。
        let rollValue: Float = desiredSpeed / 10.0
        self.pitch = 0.0
        self.roll = -rollValue
        self.yaw = yawSpeed * 0.5 * 0.7
        
        print("pitch value\(self.pitch)")
        print("roll value\(self.roll)")
        print("yaw value\(self.yaw)")
        //比較実験用
        /*
        self.pitch = 0.0
        self.roll = -sensorValue * 0.4
        print("pitch value\(self.pitch)")
        print("roll value\(self.roll)")
        self.sendControlData(x: 0, y: 0, z: 0, ya: 0)
         */
        
        //self.sendControlData(x: -rollValue, y: 0, z: 0, ya: -yawSpeed)
    }
    
    //円周上に左移動させるコマンド
    func moveInCircle_left(sensorValue: Float) {
        
        print("left circle command")
        let desiredSpeed = sensorValue
        
        let timeToCompleteCircle = 2 * Float.pi * currentDistance / desiredSpeed
        //let timeToCompleteCircle = 2 * Float.pi * 3 / desiredSpeed
        let yawSpeed = 360 * 0.5 / timeToCompleteCircle
        
        // rollValueはドローンの実際の速度に影響するので、これはドローンの具体的な性能に応じて調整する必要があります。
        // ここでは、desiredSpeedの10%としていますが、これは仮定されています。
        let rollValue: Float = desiredSpeed / 10.0
        self.pitch = 0.0
        self.roll = rollValue
        self.yaw = -yawSpeed * 0.5 * 0.7
        print("pitch value\(self.pitch)")
        print("roll value\(self.roll)")
        print("yaw value\(self.yaw)")
        //比較実験用
        /*
        self.pitch = 0.0
        self.roll = sensorValue * 0.4
        print("pitch value\(self.pitch)")
        print("roll value\(self.roll)")
        self.sendControlData(x: 0, y: 0, z: 0, ya: 0)
         */
        self.sendControlData(x: rollValue, y: 0, z: 0, ya: yawSpeed)
        
    }
    
    
    
    
    
    
    

    

    
    
    /*
     @IBAction func startCircleMission2ButtonTapped(_ sender: UIButton) {
     // Hotpointミッションオペレータを取得
     guard let hotpointMissionOperator = DJISDKManager.missionControl()?.hotpointMissionOperator() else {
     print("Failed to get hotpoint mission operator")
     return
     }
     
     // ドローンの位置を取得
     guard let droneLocationKey = DJIFlightControllerKey(param: DJIFlightControllerParamAircraftLocation),
     let droneLocationValue = DJISDKManager.keyManager()?.getValueFor(droneLocationKey),
     let droneLocation = droneLocationValue.value as? CLLocation else {
     print("Failed to get drone's location")
     return
     }
     
     let droneCoordinates = droneLocation.coordinate
     if !CLLocationCoordinate2DIsValid(droneCoordinates) {
     print("Invalid drone coordinates")
     return
     }
     
     // HotpointMissionを作成し、円飛行を設定
     let hotpointMission = DJIHotpointMission()
     hotpointMission.hotpoint = droneCoordinates
     hotpointMission.radius = 5.0
     hotpointMission.altitude = 5.0
     
     DJIHotpointMissionOperator.getMaxAngularVelocity(forRadius: Double(hotpointMission.radius), withCompletion: { (velocity: Float, error: Error?) in
     if let error = error {
     print("Error getting max angular velocity: \(error)")
     return
     }
     hotpointMission.angularVelocity = velocity
     
     // ミッションの開始
     hotpointMissionOperator.start(hotpointMission, withCompletion: { error in
     if let error = error {
     print("Failed to start circle mission: \(error)")
     } else {
     print("Circle mission started")
     }
     })
     })
     }
     */
}


      */*/*/*/
