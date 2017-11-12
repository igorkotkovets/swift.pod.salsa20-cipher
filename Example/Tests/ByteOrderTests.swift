//
//  ByteOrderTests.swift
//  SalsaCipher_Tests
//
//  Created by Igor Kotkovets on 11/7/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import CleanTests
@testable import Salsa20Cipher

// Decimal: 133124
//32 bit representation in memory:
//
// Big Endian:
// Hex: 0x00020804
// _____________________________________
// |00000000|00000010|00001000|00000100|
// |31    25|24    16|15     8|7      0|
// ⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺
// Little Endian:
// Hex: 0x04080200
// _____________________________________
// |00000100|00001000|00000010|00000000|
// |7      0|15     8|24    16|31    25|
// ⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺


class ByteOrderTests: XCTestCase {

    func testUInt32ByteOrder0() {
        var beInteger = UInt32(bigEndian: 0x01040000)
        var leInteger = UInt32(littleEndian: 0x01040000)
        var defInteger: UInt32 = 0x01040000
        print(beInteger, leInteger, defInteger)
        withUnsafePointer(to: &beInteger) { ptr -> Void in
            Salsa20Cipher.printUInt32(ptr)
        }

        withUnsafePointer(to: &leInteger) { ptr -> Void in
            Salsa20Cipher.printUInt32(ptr)
        }

        withUnsafePointer(to: &defInteger) { ptr -> Void in
            Salsa20Cipher.printUInt32(ptr)
        }
    }

    // https://www.scadacore.com/tools/programming-calculators/online-hex-converter/
    // Big Endian (ABCD) 67633664:
    // Hex: 0x04080200
    // _____________________________________
    // |00000000|00000010|00001000|00000100|
    // |31    25|24    16|15     8|7      0|
    // ⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺
    // Little Endian (DCBA) 133124:
    // Hex: 0x00020804
    // _____________________________________
    // |00000100|00001000|00000010|00000000|
    // |7      0|15     8|24    16|31    25|
    // ⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺
    func testBigEndianUInt32ByteOrder() {
        var defaultUInt32: UInt32 = 0x04080200
        withUnsafePointer(to: &defaultUInt32) { ptr -> Void in
            Salsa20Cipher.printUInt32(ptr)
        }
        assertPairsEqual(expected: 67633664, actual: defaultUInt32)

        var leUInt32: UInt32 = UInt32(bigEndian: 0x04080200)
        withUnsafePointer(to: &leUInt32) { ptr -> Void in
            Salsa20Cipher.printUInt32(ptr)
        }
        assertPairsEqual(expected: 133124, actual: leUInt32)
    }

    // Big Endian (ABCD) 4133    10 25
    // Little Endian (DCBA) 133124   00 02 08 04
    // Big Endian:
    // Hex: 0x00020804
    // _____________________________________
    // |00000000|00000010|00001000|00000100|
    // |31    25|24    16|15     8|7      0|
    // ⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺
    // Little Endian:
    // Hex: 0x04080200
    // _____________________________________
    // |00000100|00001000|00000010|00000000|
    // |7      0|15     8|24    16|31    25|
    // ⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺
    func testBigEndianUInt16ByteOrder() {
        var defaultUInt16: UInt16 = 0x1025
        withUnsafePointer(to: &defaultUInt16) { ptr -> Void in
            Salsa20Cipher.printUInt16(ptr)
        }
        assertPairsEqual(expected: 4133, actual: defaultUInt16)

        var leUInt16: UInt16 = UInt16(bigEndian: 0x1025)
        withUnsafePointer(to: &leUInt16) { ptr -> Void in
            Salsa20Cipher.printUInt16(ptr)
        }
        assertPairsEqual(expected: 9488, actual: leUInt16)
    }

    // Big Endian:
    // Hex: 0x00020804
    // _____________________________________
    // |00000000|00000010|00001000|00000100|
    // |31    25|24    16|15     8|7      0|
    // ⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺
    // Little Endian:
    // Hex: 0x04080200
    // _____________________________________
    // |00000100|00001000|00000010|00000000|
    // |7      0|15     8|24    16|31    25|
    // ⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺

    func testUInt32ByteOrder1() {
        var beInteger = UInt32(bigEndian: 0x04080200)
        assertPairsEqual(expected: 133124, actual: beInteger)
        var leInteger = UInt32(littleEndian: 0x00020804)
        assertPairsEqual(expected: 133124, actual: leInteger)
        var defInteger: UInt32 = 0x00020804
        assertPairsEqual(expected: 133124, actual: defInteger)

        print(beInteger, leInteger, defInteger)
        withUnsafePointer(to: &beInteger) { ptr -> Void in
            Salsa20Cipher.printUInt32(ptr)
        }

        withUnsafePointer(to: &leInteger) { ptr -> Void in
            Salsa20Cipher.printUInt32(ptr)
        }

        withUnsafePointer(to: &defInteger) { ptr -> Void in
            Salsa20Cipher.printUInt32(ptr)
        }
    }

    func testUInt32ByteOrder2() {
        var beInteger = UInt32(bigEndian: 0x04080200)
        assertPairsEqual(expected: 133124, actual: beInteger)
        var leInteger = UInt32(littleEndian: 0x00020804)
        assertPairsEqual(expected: 133124, actual: leInteger)
        var defInteger: UInt32 = 0x00020804
        assertPairsEqual(expected: 133124, actual: defInteger)

        print(beInteger, leInteger, defInteger)
        withUnsafePointer(to: &beInteger) { ptr -> Void in
            Salsa20Cipher.printUInt32(ptr)
        }

        withUnsafePointer(to: &leInteger) { ptr -> Void in
            Salsa20Cipher.printUInt32(ptr)
        }

        withUnsafePointer(to: &defInteger) { ptr -> Void in
            Salsa20Cipher.printUInt32(ptr)
        }
    }
}
