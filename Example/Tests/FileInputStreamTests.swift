//
//  FileInputStreamTests.swift
//  SalsaCipher_Tests
//
//  Created by Igor Kotkovets on 11/3/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import CleanTests
import Salsa20Cipher

class FileInputStreamTests: XCTestCase {
    var fileStream: FileInputStream!

    override func setUp() {
        super.setUp()
        let fileHandle: FileHandle! = FileHandle(forReadingAtPath: TestConstants.filePath)
        fileStream = FileInputStream(withFileHandle: fileHandle)
    }
    
    func testRead() {
        let len = TestConstants.textLength - 100
        let rawPointer = UnsafeMutableRawPointer.allocate(bytes: len, alignedTo: MemoryLayout<UInt8>.alignment)
        let pointer = rawPointer.initializeMemory(as: UInt8.self, to: 0)
        let readBytes = fileStream.read(pointer, maxLength: len)
        assertPairsEqual(expected: len, actual: readBytes)
        let readData = Data(bytes: pointer, count: readBytes)
        let readText = String(data: readData, encoding: .utf8)!
        
        let originTextData = TestConstants.textData[0..<len]
        let originText = String(data: originTextData, encoding: .utf8)!
        assertPairsEqual(expected: originText, actual: readText)
        rawPointer.deallocate(bytes: len, alignedTo: MemoryLayout<UInt8>.alignment)
    }

    func testDataAvailable() {
        var readData = Data()
        let len = 100
        let rawPointer = UnsafeMutableRawPointer.allocate(bytes: len, alignedTo: MemoryLayout<UInt8>.alignment)
        let pointer = rawPointer.initializeMemory(as: UInt8.self, to: 0)

        while fileStream.hasBytesAvailable {
            let readBytes = fileStream.read(pointer, maxLength: len)
            readData += Data(bytes: pointer, count: readBytes)
        }

        let readText = String(data: readData, encoding: .utf8)!
        assertPairsEqual(expected: TestConstants.text, actual: readText)
        rawPointer.deallocate(bytes: len, alignedTo: MemoryLayout<UInt8>.alignment)
    }
    
}
