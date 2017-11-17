//
//  Salsa20ExpansionFunctionTests.swift
//  SalsaCipher_Tests
//
//  Created by Igor Kotkovets on 11/9/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import CleanTests
@testable import Salsa20Cipher

class Salsa20ExpansionFunctionTests: XCTestCase {
    
    func testSalsa20ExpansionFunctionFor32Key() {
        let testVector = TestSalsa20ExpansionVector0()
        assertNoThrow ({ () -> Void in
            let expansionStateBuffer = testVector.expansionStateBuffer()
            let cryptor: Salsa20Cipher! = try! Salsa20Cipher(withKey: testVector.keyData(), iv: testVector.ivData())
            cryptor.state.withMemoryRebound(to: UInt8.self, capacity: 64) { (bytes) -> Void in
                for i in 0..<64 {
                    assertPairsEqual(expected: expansionStateBuffer[i], actual: bytes[i], message: " index \(i)")
                }
            }

            let expected = testVector.expectBuffer()
            let result = UnsafeMutablePointer<UInt8>.allocate(capacity: 64)
            result.initialize(to: 0, count: 64)
            cryptor.salsa20()
            cryptor.state.withMemoryRebound(to: UInt8.self, capacity: 64) { (bytes) -> Void in
                for i in 0..<64 {
                    assertPairsEqual(expected: expected[i], actual: bytes[i], message: " index \(i)")
                }
            }
        })
    }

//    func testSalsa20ExpansionFunctionFor16Key() {
//        let testVector = TestSalsa20ExpansionVector0()
//        assertNoThrow ({ () -> Void in
//            let expansionStateBuffer = testVector.expansionStateBuffer()
//            let cryptor: Salsa20Cryptor! = try! Salsa20Cryptor(withKey: testVector.keyData(), iv: testVector.ivData())
//            cryptor.state.withMemoryRebound(to: UInt8.self, capacity: 64) { (bytes) -> Void in
//                for i in 0..<64 {
//                    assertPairsEqual(expected: expansionStateBuffer[i], actual: bytes[i], message: " index \(i)")
//                }
//            }
//
//            let expected = testVector.expectBuffer()
//            let result = UnsafeMutablePointer<UInt8>.allocate(capacity: 64)
//            result.initialize(to: 0, count: 64)
//            Salsa20Cryptor.salsa20Hash(input: cryptor.state, output: result, rounds: 10)
//            for i in 0..<64 {
//                assertPairsEqual(expected: expected[i], actual: result[i], message: " index \(i)")
//            }
//        })
//    }
}
