//
//  Salsa20HashFunctionTests.swift
//  SalsaCipher_Tests
//
//  Created by Igor Kotkovets on 11/9/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import CleanTests
@testable import Salsa20Cipher

class Salsa20HashFunctionTests: XCTestCase {
    
    func testSalsa20Hash0() {
        let testVector = TestSalsa20HashVector0()
        let seqPtr = testVector.inputBuffer()
        let expect = testVector.expectBuffer()
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: 64)
        Salsa20Cipher.salsa20Hash(input: seqPtr, output: result)
        for i in 0..<64 {
            assertPairsEqual(expected: expect[i], actual: result[i])
        }
    }

    func testSalsa20Hash1() {
        let testVector = TestSalsa20HashVector1()
        let seqPtr = testVector.inputBuffer()
        let expect = testVector.expectBuffer()
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: 64)
        result.initialize(to: 0, count: 64)
        Salsa20Cipher.salsa20Hash(input: seqPtr, output: result)
        for i in 0..<64 {
            assertPairsEqual(expected: expect[i], actual: result[i])
        }
    }

    func testSalsa20Hash2() {
        let testVector = TestSalsa20HashVector2()
        let seqPtr = testVector.inputBuffer()
        let expect = testVector.expectBuffer()
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: 64)
        result.initialize(to: 0, count: 64)
        Salsa20Cipher.salsa20Hash(input: seqPtr, output: result)
        for i in 0..<64 {
            assertPairsEqual(expected: expect[i], actual: result[i])
        }
    }

    func testSalsa20Hash3() {
        let testVector = TestSalsa20HashVector3()
        var seqPtr = testVector.inputBuffer()
        let expect = testVector.expectBuffer()
        var result = UnsafeMutablePointer<UInt8>.allocate(capacity: 64)
        result.initialize(to: 0, count: 64)
        for _ in 0..<1000000 {
            Salsa20Cipher.salsa20Hash(input: seqPtr, output: result)
            let tmpPtr = result
            result = seqPtr
            seqPtr = tmpPtr
        }

        for i in 0..<64 {
            assertPairsEqual(expected: expect[i], actual: seqPtr[i])
        }
    }
    
}
