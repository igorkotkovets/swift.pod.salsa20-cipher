//
//  Data+Extensions.swift
//  Pods
//
//  Created by Igor Kotkovets on 11/5/17.
//

import Foundation

public extension Data {
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
