//
//  DataInputStreamTests.swift
//  SalsaCipher_Tests
//
//  Created by Igor Kotkovets on 11/4/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import CleanTests
import Salsa20Cipher

class DataInputStreamTests: XCTestCase {
    var dataStream: DataInputStream!
    
    override func setUp() {
        super.setUp()
        dataStream = DataInputStream(withData: TestConstants.textData)
    }
    
    func testDataAvailable() {
        var readData = Data()
        let len = 100
        let rawPointer = UnsafeMutableRawPointer.allocate(bytes: len, alignedTo: 0)
        let pointer = rawPointer.initializeMemory(as: UInt8.self, to: 0)

        while dataStream.hasBytesAvailable {
            let readBytes = dataStream.read(pointer, maxLength: len)
            readData += Data(bytes: pointer, count: readBytes)
        }

        let readText = String(data: readData, encoding: .utf8)!
        assertPairsEqual(expected: TestConstants.text, actual: readText)
    }
}
