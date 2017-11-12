//
//  Data+Extensions.swift
//  Pods
//
//  Created by Igor Kotkovets on 11/5/17.
//

import Foundation

public extension Data {

    public init?(hex string: String) {
        func decodeNibble(character: UInt16) -> UInt8? {
            switch character {
            case 0x30 ... 0x39: // 0..9
                return UInt8(character - 0x30)
            case 0x41 ... 0x46: // A..F
                return UInt8(character - 0x41 + 10)
            case 0x61 ... 0x66: // a..f
                return UInt8(character - 0x61 + 10)
            default:
                return nil
            }
        }

        self.init(capacity: string.utf16.count/2)
        var even = true
        var byte: UInt8 = 0

        for c in string.utf16 {
            guard let val = decodeNibble(character: c) else {
                return nil
            }

            if even {
                byte = val << 4
            } else {
                byte += val
                append(byte)
            }
            even = !even
        }

        guard even else {
            return nil
        }
    }

    var hexString: String {
        var result = ""

        var bytes = [UInt8](repeating: 0, count: count)
        copyBytes(to: &bytes, count: count)

        for byte in bytes {
            result += String(format: "%02x", UInt(byte))
        }

        return result
    }

    func salsa20Encrypted(withKey: String, initializationVector: String) -> Data? {
        guard let keyData = withKey.data(using: .utf8),
            let ivData = initializationVector.data(using: .utf8) else {
                return nil
        }

        let dataStream = DataInputStream(withData: self)
        do {
            let salsa20Stream = try Salsa20CipherStream(withStream: dataStream, key: keyData, iv: ivData)
            var resultData = Data(count: self.count)
            var readLength: Int?
            resultData.withUnsafeMutableBytes { (bytes: UnsafeMutablePointer<UInt8>) -> Void in
                readLength = salsa20Stream?.read(bytes, maxLength: self.count)
            }

            guard readLength == self.count else {
                return nil
            }

            return resultData
        } catch {
            return nil
        }
    }
}
