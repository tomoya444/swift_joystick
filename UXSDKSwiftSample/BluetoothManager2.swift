//
//  BluetoothManager2.swift
//  UXSDKSwiftSample
//
//  Created by Tomoya Usui on 2023/08/29.
//  Copyright © 2023 DJI. All rights reserved.
//

/*
import CoreBluetooth
import os.log

protocol BluetoothManagerDelegate: AnyObject {
    func bluetoothManager(_ bluetoothManager: BluetoothManager, didReceiveValue1 value1: Int8)
    func bluetoothManager(_ bluetoothManager: BluetoothManager, didReceiveValue2 value2: Int8)
    func bluetoothManager(_ bluetoothManager: BluetoothManager, didReceiveValue3 value3: Int8)
    func bluetoothManager(_ bluetoothManager: BluetoothManager, didReceiveValue4 value4: Int8)
    func bluetoothManager(_ bluetoothManager: BluetoothManager, didReceiveValue5 value5: Int8)
    func bluetoothManager(_ bluetoothManager: BluetoothManager, didReceiveValue6 value6: Int8)
    func bluetoothManager(_ bluetoothManager: BluetoothManager, didReceiveValue7 value7: Int8)
    func bluetoothManager(_ bluetoothManager: BluetoothManager, didReceiveValue8 value8: Int8)

}

class BluetoothManager: NSObject {
    
    let serviceUUID: String
    let serviceUUID2: String
    
    let characteristicUUID: String
    let characteristicUUID2: String
    let characteristicUUID3: String
    let characteristicUUID4: String
    let characteristicUUID5: String
    let characteristicUUID6: String
    let characteristicUUID7: String
    let characteristicUUID8: String
    
    weak var delegate: BluetoothManagerDelegate?
    
    var centralManager: CBCentralManager!
    var connectedPeripheral: CBPeripheral?
    //センサの数に合わせる
    var targetService: CBService?
    var targetService2: CBService?
    var targetService3: CBService?
    var targetService4: CBService?
    var targetService5: CBService?
    var targetService6: CBService?
    var targetService7: CBService?
    var targetService8: CBService?
    
    var writableCharacteristic: CBCharacteristic?
    var writableCharacteristic2: CBCharacteristic?
    var writableCharacteristic3: CBCharacteristic?
    var writableCharacteristic4: CBCharacteristic?
    var writableCharacteristic5: CBCharacteristic?
    var writableCharacteristic6: CBCharacteristic?
    var writableCharacteristic7: CBCharacteristic?
    var writableCharacteristic8: CBCharacteristic?
    
    init(serviceUUID: String, characteristicUUID: String, characteristicUUID2: String, characteristicUUID3: String, characteristicUUID4: String, delegate: BluetoothManagerDelegate?) {
        self.serviceUUID = serviceUUID
        self.serviceUUID2 = serviceUUID2
        self.characteristicUUID = characteristicUUID
        self.characteristicUUID2 = characteristicUUID2
        self.characteristicUUID3 = characteristicUUID3
        self.characteristicUUID4 = characteristicUUID4
        self.characteristicUUID5 = characteristicUUID5
        self.characteristicUUID6 = characteristicUUID6
        self.characteristicUUID7 = characteristicUUID7
        self.characteristicUUID8 = characteristicUUID8
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
    func writeValue3(value: Int) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic3 else {
            return
        }
        
        let data = Data.dataWithValue(value: Int8(value))
        peripheral.writeValue(data, for: characteristic, type: .withResponse)
    }
    
    func writeValue4(value: Int) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic4 else {
            return
        }
        
        let data = Data.dataWithValue(value: Int8(value))
        peripheral.writeValue(data, for: characteristic, type: .withResponse)
    }
    
    func writeValue5(value: Int) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic5 else {
            return
        }
        
        let data = Data.dataWithValue(value: Int8(value))
        peripheral.writeValue(data, for: characteristic, type: .withResponse)
    }
    
    func writeValue6(value: Int) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic6 else {
            return
        }
        
        let data = Data.dataWithValue(value: Int8(value))
        peripheral.writeValue(data, for: characteristic, type: .withResponse)
    }
    
    func writeValue7(value: Int) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic7 else {
            return
        }
        
        let data = Data.dataWithValue(value: Int8(value))
        peripheral.writeValue(data, for: characteristic, type: .withResponse)
    }
    
    func writeValue8(value: Int) {
        guard let peripheral = connectedPeripheral, let characteristic = writableCharacteristic8 else {
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
        
        for service in services {
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
        if let characteristic3 = characteristics.first(where: { $0.uuid == CBUUID(string: characteristicUUID3) }) {
            writableCharacteristic3 = characteristic3
            //print("ok2")
        }

        if let characteristic4 = characteristics.first(where: { $0.uuid == CBUUID(string: characteristicUUID4) }) {
            writableCharacteristic4 = characteristic4
            //print("ok2")
        }
        if let characteristic5 = characteristics.first(where: { $0.uuid == CBUUID(string: characteristicUUID5) }) {
            writableCharacteristic5 = characteristic5
            //print("ok2")
        }
        if let characteristic6 = characteristics.first(where: { $0.uuid == CBUUID(string: characteristicUUID6) }) {
            writableCharacteristic6 = characteristic6
            //print("ok2")
        }
        if let characteristic7 = characteristics.first(where: { $0.uuid == CBUUID(string: characteristicUUID7) }) {
            writableCharacteristic7 = characteristic7
            //print("ok2")
        }
        if let characteristic8 = characteristics.first(where: { $0.uuid == CBUUID(string: characteristicUUID8) }) {
            writableCharacteristic8 = characteristic8
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
        if characteristic.uuid == CBUUID(string: characteristicUUID3) {
            let value3 = Int8(bitPattern: data[0])
            print("value3: \(value3)")
            delegate.bluetoothManager(self, didReceiveValue3: value3)
        }

        if characteristic.uuid == CBUUID(string: characteristicUUID4) {
            let value4 = Int8(bitPattern: data[0])
            print("value4: \(value4)")
            delegate.bluetoothManager(self, didReceiveValue4: value4)
        }
        
        if characteristic.uuid == CBUUID(string: characteristicUUID5) {
            let value5 = Int8(bitPattern: data[0])
            print("value5: \(value5)")
            delegate.bluetoothManager(self, didReceiveValue5: value5)
        }
        
        if characteristic.uuid == CBUUID(string: characteristicUUID6) {
            let value6 = Int8(bitPattern: data[0])
            print("value6: \(value6)")
            delegate.bluetoothManager(self, didReceiveValue6: value6)
        }
        
        if characteristic.uuid == CBUUID(string: characteristicUUID7) {
            let value7 = Int8(bitPattern: data[0])
            print("value7: \(value7)")
            delegate.bluetoothManager(self, didReceiveValue7: value7)
        }
        
        if characteristic.uuid == CBUUID(string: characteristicUUID8) {
            let value8 = Int8(bitPattern: data[0])
            print("value8: \(value8)")
            delegate.bluetoothManager(self, didReceiveValue8: value8)
        }
    }
    
}
*/
