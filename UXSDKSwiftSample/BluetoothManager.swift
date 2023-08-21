//
//  BluetoothManager.swift
//  UXSDKSwiftSample
//
//  Created by Tomoya Usui on 2023/07/05.
//  Copyright © 2023 DJI. All rights reserved.
//

import CoreBluetooth
import os.log

protocol BluetoothManagerDelegate: AnyObject {
    func bluetoothManager(_ bluetoothManager: BluetoothManager, didReceiveValue1 value1: Int8)
    func bluetoothManager(_ bluetoothManager: BluetoothManager, didReceiveValue2 value2: Int8)
}

class BluetoothManager: NSObject {
    
    let serviceUUID: String
    let characteristicUUID: String
    let characteristicUUID2: String
    weak var delegate: BluetoothManagerDelegate?
    
    var centralManager: CBCentralManager!
    var connectedPeripheral: CBPeripheral?
    var targetService: CBService?
    var targetService2: CBService?
    var writableCharacteristic: CBCharacteristic?
    var writableCharacteristic2: CBCharacteristic?
    
    init(serviceUUID: String, characteristicUUID: String, characteristicUUID2: String, delegate: BluetoothManagerDelegate?) {
        self.serviceUUID = serviceUUID
        self.characteristicUUID = characteristicUUID
        self.characteristicUUID2 = characteristicUUID2
        self.delegate = delegate
        
        super.init()
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
    }
    
    func writeValue(value: Int) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic else {
            return
        }
        
        let data = Data.dataWithValue(value: Int8(value))
        peripheral.writeValue(data, for: characteristic, type: .withResponse)
    }
    func writeValue2(value: Int) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic2 else {
            return
        }
        
        let data = Data.dataWithValue(value: Int8(value))
        peripheral.writeValue(data, for: characteristic, type: .withResponse)
    }
    
}

extension BluetoothManager: CBCentralManagerDelegate {
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
        if let name = peripheral.name {
            print("Connected! With \(name)")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        guard let name = peripheral.name else {
            return
        }
        print("Discovered \(name)")
        print("Peripheral UUID: \(peripheral.identifier)")
        if name == "BLE_DEVICE" {
            connectedPeripheral = peripheral
            connectedPeripheral?.delegate = self
            centralManager.connect(peripheral, options: nil)
            centralManager.stopScan()
            // UUIDをクリアする処理を追加
            clearPeripheralCache(peripheral)
        }
    }
    func clearPeripheralCache(_ peripheral: CBPeripheral) {
        guard let services = peripheral.services else {
            return
        }
        
        for service in services {
            peripheral.discoverCharacteristics([service.uuid], for: service)
        }
    }
    
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: nil, options: nil)
            print("poweredON ok")
        }
    }
}


extension BluetoothManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else {
            return
        }
        
        targetService = services.first
        if let service = services.first {
            targetService = service
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else {
            return
        }
        
        for characteristic in characteristics {
            if let descriptor = characteristic.descriptors?.first {
                peripheral.writeValue(Data(), for: descriptor)
            }
            if characteristic.properties.contains(.write) || characteristic.properties.contains(.writeWithoutResponse) {
                writableCharacteristic = characteristic
            }
            peripheral.setNotifyValue(true, for: characteristic)
        }
        // UUIDをチェックして、該当するcharacteristicに対しての処理を行う
        if let characteristic = characteristics.first(where: { $0.uuid == CBUUID(string: characteristicUUID) }) {
            writableCharacteristic = characteristic
            //print("ok1")
        }
        if let characteristic2 = characteristics.first(where: { $0.uuid == CBUUID(string: characteristicUUID2) }) {
            writableCharacteristic2 = characteristic2
            //print("ok2")
        }
        // デバッグログ：検出されたキャラクタリスティックの情報を表示
        print("Discovered characteristics for service: \(service.uuid)")
        for characteristic in characteristics {
            print("Characteristic UUID: \(characteristic.uuid)")
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let data = characteristic.value, let delegate = delegate else {
            return
        }
        print("Received value for characteristic: \(characteristic.uuid)")
        if characteristic.uuid == CBUUID(string: characteristicUUID) {
            let value1 = Int8(bitPattern: data[0])
            print("value1: \(value1)")
            delegate.bluetoothManager(self, didReceiveValue1: value1)
        }
        
        if characteristic.uuid == CBUUID(string: characteristicUUID2) {
            let value2 = Int8(bitPattern: data[0])
            print("value2: \(value2)")
            delegate.bluetoothManager(self, didReceiveValue2: value2)
        }
    }
    
}
