//
//  String+Extensions.swift
//  Pods
//
//  Created by Igor Kotkovets on 11/12/17.
//

import Foundation

public extension String {
    func salsa20Encrypted(withKey key: String, initializationVector vector: String) -> Data? {
        guard let strData = self.data(using: .utf8) else {
                return nil
        }

        return strData.salsa20Encrypted(withKey: key, initializationVector: vector)
    }
}
