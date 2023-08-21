//
//  NSData+int8.swift
//  UXSDKSwiftSample
//
//  Created by Tomoya Usui on 2023/07/05.
//  Copyright © 2023 DJI. All rights reserved.
//

import Foundation

extension Data {
    static func dataWithValue(value: Int8) -> Data {
        var variableValue = value
        return Data(buffer: UnsafeBufferPointer(start: &variableValue, count: 1))
    }
    
    func int8Value() -> Int8 {
        return Int8(bitPattern: self[0])
    }
}
