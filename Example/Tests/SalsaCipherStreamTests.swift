//
//  SalsaInputStreamTests.swift
//  SalsaCipher_Tests
//
//  Created by Igor Kotkovets on 11/3/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import CleanTests
import Salsa20Cipher

class SalsaCipherStreamTests: XCTestCase {
    var encryptStream: Salsa20Stream!
    var decryptStream: Salsa20Stream!
    var dataStream: DataInputStream!

    override func setUp() {
        super.setUp()
        dataStream = DataInputStream(withData: TestConstants.textData)
    }

    func testTypeCasting() {
        var uint32: UInt32 = 252117761
        var uint80: UInt8?
        var uint81: UInt8?
        var uint82: UInt8?
        var uint83: UInt8?
        let count = MemoryLayout<UInt8>.size
        withUnsafePointer(to: &uint32) { (uint32Ptr) -> Void in
            uint32Ptr.withMemoryRebound(to: UInt8.self, capacity: count) { uint8Ptr -> Void in
                uint80 = uint8Ptr[0]
                uint81 = uint8Ptr[1]
                uint82 = uint8Ptr[2]
                uint83 = uint8Ptr[3]
            }
        }

        assertPairsEqual(expected: 1, actual: uint80 ?? 0)
        assertPairsEqual(expected: 3, actual: uint81 ?? 0)
        assertPairsEqual(expected: 7, actual: uint82 ?? 0)
        assertPairsEqual(expected: 15, actual: uint83 ?? 0)
    }

    func testEncryptDecryptData() {
        assertNoThrow( {
            encryptStream = try Salsa20Stream(withStream: dataStream, key: TestConstants.keyData, iv: TestConstants.ivData)
        })

        let length = TestConstants.textLength
        let cipherBufferRaw = UnsafeMutableRawPointer.allocate(bytes: length, alignedTo: MemoryLayout<UInt8>.alignment)
        let cipherBuffer = cipherBufferRaw.initializeMemory(as: UInt8.self, to: 0)
        let cipherReadBytes = encryptStream.read(cipherBuffer, maxLength: length)
        assertPairsEqual(expected: length, actual: cipherReadBytes)
        let cipherData = Data(bytes: cipherBuffer, count: cipherReadBytes)

        let cipherDataStream = DataInputStream(withData: cipherData)
        assertNoThrow( {
            decryptStream = try Salsa20Stream(withStream: cipherDataStream, key: TestConstants.keyData, iv: TestConstants.ivData)
        })
        let originBufferRaw = UnsafeMutableRawPointer.allocate(bytes: length, alignedTo: MemoryLayout<UInt8>.alignment)
        let originBuffer = originBufferRaw.initializeMemory(as: UInt8.self, to: 0)
        let originReadBytes = decryptStream.read(originBuffer, maxLength: length)
        assertPairsEqual(expected: length, actual: originReadBytes)
        let originData = Data(bytes: originBuffer, count: originReadBytes)
        let originText = String(data: originData, encoding: .utf8)
        assertPairsEqual(expected: TestConstants.text, actual: originText ?? "")
    }

    func testVecrot0() {
        assertNoThrow( {
            encryptStream = try Salsa20Stream(withStream: dataStream, key: TestVector0.key, iv: TestVector0.iv)
        })
        let length = TestConstants.textLength
        let cipherBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: length)
        let cipherReadBytes = encryptStream.read(cipherBuffer, maxLength: length)
        assertPairsEqual(expected: length, actual: cipherReadBytes)
        let cipherData = Data(bytes: cipherBuffer, count: cipherReadBytes)
        let cipherDataStream = DataInputStream(withData: cipherData)
        assertNoThrow( {
            decryptStream = try Salsa20Stream(withStream: cipherDataStream, key: TestVector0.key, iv: TestVector0.iv)
        })
        let originBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: length)
        let originReadBytes = decryptStream.read(originBuffer, maxLength: length)
        assertPairsEqual(expected: length, actual: originReadBytes)
        let originData = Data(bytes: originBuffer, count: originReadBytes)
        let originText = String(data: originData, encoding: .utf8)
        assertPairsEqual(expected: TestConstants.text, actual: originText ?? "")
    }

    func testVecrot1() {
        assertNoThrow( {
            encryptStream = try Salsa20Stream(withStream: dataStream, key: TestVector1.key, iv: TestVector1.iv)
        })
        let length = TestConstants.textLength
        let cipherBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: length)
        let cipherReadBytes = encryptStream.read(cipherBuffer, maxLength: length)
        assertPairsEqual(expected: length, actual: cipherReadBytes)
        let cipherData = Data(bytes: cipherBuffer, count: cipherReadBytes)
        let cipherDataStream = DataInputStream(withData: cipherData)
        assertNoThrow( {
            decryptStream = try Salsa20Stream(withStream: cipherDataStream, key: TestVector1.key, iv: TestVector1.iv)
        })
        let originBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: length)
        let originReadBytes = decryptStream.read(originBuffer, maxLength: length)
        assertPairsEqual(expected: length, actual: originReadBytes)
        let originData = Data(bytes: originBuffer, count: originReadBytes)
        let originText = String(data: originData, encoding: .utf8)
        assertPairsEqual(expected: TestConstants.text, actual: originText ?? "")
    }

    func testVectorWith16BytesKey() {
        assertNoThrow({
            encryptStream = try Salsa20Stream(withStream: dataStream, key: TestVector4.key, iv: TestVector4.iv)
            let length = TestConstants.textLength
            let cipherBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: length)
            let cipherReadBytes = encryptStream.read(cipherBuffer, maxLength: length)
            assertPairsEqual(expected: length, actual: cipherReadBytes)
            let cipherData = Data(bytes: cipherBuffer, count: cipherReadBytes)
            let cipherDataStream = DataInputStream(withData: cipherData)
            decryptStream = try Salsa20Stream(withStream: cipherDataStream, key: TestVector4.key, iv: TestVector4.iv)
            let originBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: length)
            let originReadBytes = decryptStream.read(originBuffer, maxLength: length)
            assertPairsEqual(expected: length, actual: originReadBytes)
            let originData = Data(bytes: originBuffer, count: originReadBytes)
            let originText = String(data: originData, encoding: .utf8)
            assertPairsEqual(expected: TestConstants.text, actual: originText ?? "")
        })
    }
    
    
}
