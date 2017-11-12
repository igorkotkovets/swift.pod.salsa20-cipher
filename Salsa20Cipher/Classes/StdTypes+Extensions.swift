//
//  StdTypes+Extensions.swift
//  Pods
//
//  Created by Igor Kotkovets on 11/8/17.
//

import Foundation

protocol BytesRepresentable {}

extension BytesRepresentable {
    var hexString: String {
        var copy = self

        return withUnsafePointer(to: &copy) { ptr -> String in
            let count = MemoryLayout<Self>.size
            return ptr.withMemoryRebound(to: UInt8.self, capacity: count) { (bytes) -> String in
                var str = "0x"
                for i in 0..<count {
                    str += String(format: "%02x", bytes[i])
                }
                return str
            }
        }
    }
}

extension UInt32: BytesRepresentable {}
extension Int32: BytesRepresentable {}
