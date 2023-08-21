//
//  StudyViewController.swift
//  UXSDKSwiftSample
//
//  Created by Tomoya Usui on 2023/07/05.
//  Copyright © 2023 DJI. All rights reserved.
//

import UIKit
import DJISDK
import CoreBluetooth
import CoreLocation
import CDJoystick


enum FLIGHT_MODE {
    case ROLL_LEFT_RIGHT
    case PITCH_FORWARD_BACK
    case THROTTLE_UP_DOWN
    case HORIZONTAL_ORBIT
    case VERTICAL_ORBIT
    case VERTICAL_SINE_WAVE
    case HORIZONTAL_SINE_WAVE
    case YAW
    case ORIGINAL_CIRCLE
}

class StudyViewController: UIViewController,BluetoothManagerDelegate,DJISDKManagerDelegate,CLLocationManagerDelegate{
    
    
    func didUpdateDatabaseDownloadProgress(_ progress: Progress) {
        
    }
    var virtualSticksController = VirtualSticksController()
    
    var flightController: DJIFlightController?
    var locationManager = CLLocationManager()
    var missionOperator: DJIWaypointMissionOperator? // Hotpointミッションのための変数
    
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
    var speed: Float = 0.0
    var speed2: Float = 0.0
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
        let characteristicUUID = "beb5483e-36e1-4688-b7f5-ea07361b26a8"
        let characteristicUUID2 = "beb5483e-36e1-4688-b7f5-ea07361b26a9"
        bluetoothManager = UXSDKSwiftSample.BluetoothManager(serviceUUID: serviceUUID, characteristicUUID: characteristicUUID, characteristicUUID2: characteristicUUID2, delegate: self)
        valueLabel.text = "No Value"
        valueLabel2.text = "No Value"
        statusLabel.text = "Not Connected"
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
                self.flightController?.rollPitchCoordinateSystem = DJIVirtualStickFlightCoordinateSystem.ground
                
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
            
            self.sendControlData(x: 0, y: 0, z: 0, ya: self.yaw)
        }
        
        // Pitch/roll
        rightJoystick.trackingHandler = { joystickData in
            
            self.pitch = Float(joystickData.velocity.y) * 1.0 * 0.5
            self.roll = Float(joystickData.velocity.x) * 1.0 * 0.5 * (-1.0)
            self.sendControlData(x: 0, y: 0, z: 0, ya: 0)
        }
        
    }
    
    // User clicks the enter virtual sticks button
    @IBAction func enableVirtualSticks(_ sender: Any) {
        toggleVirtualSticks(enabled: true)
    }
    
    // User clicks the exit virtual sticks button
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
    @IBOutlet weak var statusLabel: UILabel! // 値を表示するためのUILabel
    @IBOutlet weak var takeoffbutton: UIButton!
    @IBOutlet weak var landbutton: UIButton!
    @IBOutlet weak var moveforwardbutton: UIButton!
    @IBOutlet weak var circlebutton: UIButton!
    @IBOutlet weak var startpointmissionbutton: UIButton!
    // BluetoothManagerDelegateのメソッドの実装
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
                self.valueLabel.text = "Value 1: \(self.mappedValue1)"
                
            }
            if mappedValue1 > 150{
                //flightController?.startTakeoff(completion: nil)
            }
        }
        
        
    }
    func bluetoothManager(_ BluetoothManager: BluetoothManager, didReceiveValue2 value2: Int8){
        if value2 >= -127{
            mappedValue2 = Int(value2) + 127 // 値のマッピング
            speed2 = Float(mappedValue1) / 255.0
            //virtualSticksController.vsMove(pitch: speed2, roll: 0.0, yaw: 0.0, vertical: 0.0)
            // 値をUIに表示する
            DispatchQueue.main.async {
                self.valueLabel2.text = "Value 2: \(self.mappedValue2)"
                
            }
            if mappedValue2 > 150{
                //flightController?.startLanding(completion: nil)
            }
        }
    }
    @IBAction func takeoffButtonTapped(_ sender: UIButton) {
        flightController?.startTakeoff(completion: nil)
    }
    @IBAction func landButtonTapped(_ sender: UIButton) {
        flightController?.startLanding(completion: nil)
    }
    
    
    @IBAction func forwardButtonTapped(_ sender: UIButton) {
        //virtualSticksController.vsMove(pitch: 1.0, roll: 1.0, yaw: 1.0, vertical: 1.0)
    }
    
    @IBAction func controlDroneWithMappedValue(_ mappedValue: Int) {
        // 速度の範囲を設定
        let minSpeed: Float = 0.0 // 最小速度
        let maxSpeed: Float = 10.0 // 最大速度
        
        // mappedValueを0〜255の範囲から0〜1の範囲に変換
        let normalizedValue = Float(mappedValue) / 255.0
        
        // 速度の変化率を計算
        let speedChangeRate = (maxSpeed - minSpeed) * normalizedValue
        
        // 速度を設定
        let speed = minSpeed + speedChangeRate
        
        // ドローンを前進させる処理を実行
        let flightControlData = DJIVirtualStickFlightControlData(pitch: speed, roll: 0.0, yaw: 0.0, verticalThrottle: 0.0)
        flightController?.send(flightControlData, withCompletion: nil)
        
    }
    
    @IBAction func startCircleMissionButtonTappedFromObjC(_ sender: UIButton) {
        startCircleMissionFromSwift()
        
    }
    func defaultHotPointAction() -> DJIHotpointAction? {
        let mission = DJIHotpointMission()
        /*
         guard let droneLocationKey = DJIFlightControllerKey(param: DJIFlightControllerParamAircraftLocation) else {
         print("Failed to generate droneLocationKey.")
         return nil
         }
         
         guard let droneLocationValue = DJISDKManager.keyManager()?.getValueFor(droneLocationKey) else {
         print("Failed to get droneLocationValue.")
         return nil
         }
         */
        // 仮の座標を設定
        let droneCoordinates = CLLocationCoordinate2D(latitude: 35.71104, longitude: 139.62681)
        //let droneLocation = droneLocationValue.value as! CLLocation
        //let droneCoordinates = droneLocation.coordinate
        print("Drone Coordinates: \(droneCoordinates.latitude), \(droneCoordinates.longitude)")
        
        /*
         if !CLLocationCoordinate2DIsValid(droneCoordinates) {
         print("Drone Coordinates are not valid.")
         return nil
         }
         */
        let offset = 0.0000899322
        
        mission.hotpoint = CLLocationCoordinate2DMake(droneCoordinates.latitude + offset, droneCoordinates.longitude)
        mission.altitude = 15
        mission.radius = 15
        DJIHotpointMissionOperator.getMaxAngularVelocity(forRadius: Double(mission.radius), withCompletion: {(velocity:Float, error:Error?) in
            mission.angularVelocity = velocity
        })
        mission.startPoint = .nearest
        mission.heading = .alongCircleLookingForward
        
        return DJIHotpointAction(mission: mission, surroundingAngle: 180)
    }
    
    @IBAction func startHotpointMission(_ sender: UIButton) {
        // デフォルトのHotpointミッションを取得
        guard let hotpointAction = defaultHotPointAction() else {
            print("Failed to get default hotpoint action.")
            return
        }
        
        // ミッションオペレーターを取得
        if let missionOperator = DJISDKManager.missionControl()?.hotpointMissionOperator() {
            // 既存のミッションが実行中であれば停止
            missionOperator.stopMission { (error: Error?) in
                if let error = error {
                    print("Error stopping existing mission: \(error.localizedDescription)")
                }
                
                // 新しいミッションを開始
                missionOperator.start(hotpointAction.mission, withCompletion: { (error: Error?) in
                    if let error = error {
                        print("Error starting hotpoint mission: \(error.localizedDescription)")
                    } else {
                        print("Hotpoint mission started successfully!")
                    }
                })
            }
        }
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


