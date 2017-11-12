//
//  Salsa20CipherDataTests.swift
//  SalsaCipher_Tests
//
//  Created by Igor Kotkovets on 11/12/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import CleanTests
import Salsa20Cipher

class Salsa20CipherDataTests: XCTestCase {
    
    let key = "0123456789abcdef"
    let vector = "01234567"

    func testThatEncryptDecriptString() {
        let plainText = "Hello world!"
        let plainTextData = plainText.data(using: .utf8)
        let encryptedData = plainText.salsa20Encrypted(withKey: key, initializationVector: vector)
        let decryptedData = encryptedData?.salsa20Encrypted(withKey: key, initializationVector: vector)
        assertPairsEqual(expected: plainTextData, actual: decryptedData)
    }
    
}
