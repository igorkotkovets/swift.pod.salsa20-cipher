//
//  Salsa20CryptorTests.swift
//  SalsaCipher_Tests
//
//  Created by Igor Kotkovets on 11/5/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import CleanTests
@testable import Salsa20Cipher

class Salsa20CipherTests: XCTestCase {

    func testByteOrder() {
        let uint32: UInt32 = 252117761
        var uint32Little: UInt32 = uint32.littleEndian
        var uint80: UInt8?
        var uint81: UInt8?
        var uint82: UInt8?
        var uint83: UInt8?
        let count = MemoryLayout<UInt8>.size
        withUnsafePointer(to: &(uint32Little)) { (uint32Ptr) -> Void in
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

    func testSumUInt8WithOverflow() {
        let lhs: UInt8 = 255
        let rhs0: UInt8 = 2
        let result: UInt8 = 1
        assertPairsEqual(expected: result, actual: lhs &+ rhs0)
    }

    func testSumUInt32WithOverflow() {
        let lhs: UInt32 = 0xc0a8787e
        let rhs0: UInt32 = 0x9fd1161d
        let result: UInt32 = 0x60798E9B
        assertPairsEqual(expected: result, actual: lhs &+ rhs0)
    }

    func testRotl() {
        let arg: UInt32 = 0xc0a8787e
        assertPairsEqual(expected: 0x150f0fd8, actual: Salsa20Cipher.rotl(value: arg, shift: 5))
        assertPairsEqual(expected: 1431655765, actual: Salsa20Cipher.rotl(value: 1431655765, shift: 8))

    }

    func testQuarterRound0() {
        let seqPtr = UnsafeMutablePointer<UInt32>.allocate(capacity: 4)
        seqPtr.initialize(to: 0, count: 4)
        seqPtr[0] = 0x00000000
        seqPtr[1] = 0x00000000
        seqPtr[2] = 0x00000000
        seqPtr[3] = 0x00000000
        Salsa20Cipher.printQuarterRound(seqPtr)
        Salsa20Cipher.quarterRound(ptr0: seqPtr, ptr1: (seqPtr+1), ptr2: (seqPtr+2), ptr3: (seqPtr+3))
        Salsa20Cipher.printQuarterRound(seqPtr)
        assertPairsEqual(expected: 0x00000000, actual: seqPtr[0])
        assertPairsEqual(expected: 0x00000000, actual: seqPtr[1])
        assertPairsEqual(expected: 0x00000000, actual: seqPtr[2])
        assertPairsEqual(expected: 0x00000000, actual: seqPtr[3])
    }

    func testQuarterRound1() {
        let seqPtr = UnsafeMutablePointer<UInt32>.allocate(capacity: 4)
        seqPtr.initialize(to: 0, count: 4)
        seqPtr[0] = 0x00000001
        seqPtr[1] = 0x00000000
        seqPtr[2] = 0x00000000
        seqPtr[3] = 0x00000000
        Salsa20Cipher.printQuarterRound(seqPtr)
        Salsa20Cipher.quarterRound(ptr0: seqPtr, ptr1: (seqPtr+1), ptr2: (seqPtr+2), ptr3: (seqPtr+3))
        Salsa20Cipher.printQuarterRound(seqPtr)
        assertPairsEqual(expected: 0x08008145, actual: seqPtr[0])
        assertPairsEqual(expected: 0x00000080, actual: seqPtr[1])
        assertPairsEqual(expected: 0x00010200, actual: seqPtr[2])
        assertPairsEqual(expected: 0x20500000, actual: seqPtr[3])
    }

    func testQuarterRound2() {
        let seqPtr = UnsafeMutablePointer<UInt32>.allocate(capacity: 4)
        seqPtr[0] = 0x00000000
        seqPtr[1] = 0x00000001
        seqPtr[2] = 0x00000000
        seqPtr[3] = 0x00000000
        Salsa20Cipher.printQuarterRound(seqPtr)
        Salsa20Cipher.quarterRound(ptr0: seqPtr, ptr1: (seqPtr+1), ptr2: (seqPtr+2), ptr3: (seqPtr+3))
        Salsa20Cipher.printQuarterRound(seqPtr)
        assertPairsEqual(expected: 0x88000100, actual: seqPtr[0])
        assertPairsEqual(expected: 0x00000001, actual: seqPtr[1])
        assertPairsEqual(expected: 0x00000200, actual: seqPtr[2])
        assertPairsEqual(expected: 0x00402000, actual: seqPtr[3])
    }

    func testQuarterRound3() {
        let seqPtr = UnsafeMutablePointer<UInt32>.allocate(capacity: 4)
        seqPtr[0] = 0x00000000
        seqPtr[1] = 0x00000000
        seqPtr[2] = 0x00000001
        seqPtr[3] = 0x00000000
        Salsa20Cipher.printQuarterRound(seqPtr)
        Salsa20Cipher.quarterRound(ptr0: seqPtr, ptr1: (seqPtr+1), ptr2: (seqPtr+2), ptr3: (seqPtr+3))
        Salsa20Cipher.printQuarterRound(seqPtr)
        assertPairsEqual(expected: 0x80040000, actual: seqPtr[0])
        assertPairsEqual(expected: 0x00000000, actual: seqPtr[1])
        assertPairsEqual(expected: 0x00000001, actual: seqPtr[2])
        assertPairsEqual(expected: 0x00002000, actual: seqPtr[3])
    }

    func testQuarterRound4() {
        let seqPtr = UnsafeMutablePointer<UInt32>.allocate(capacity: 4)
        seqPtr.initialize(to: 0, count: 4)
        seqPtr[0] = 0x00000000
        seqPtr[1] = 0x00000000
        seqPtr[2] = 0x00000000
        seqPtr[3] = 0x00000001
        Salsa20Cipher.printQuarterRound(seqPtr)
        Salsa20Cipher.quarterRound(ptr0: seqPtr, ptr1: (seqPtr+1), ptr2: (seqPtr+2), ptr3: (seqPtr+3))
        Salsa20Cipher.printQuarterRound(seqPtr)
        assertPairsEqual(expected: 0x00048044, actual: seqPtr[0])
        assertPairsEqual(expected: 0x00000080, actual: seqPtr[1])
        assertPairsEqual(expected: 0x00010000, actual: seqPtr[2])
        assertPairsEqual(expected: 0x20100001, actual: seqPtr[3])
    }

    func testQuarterRound5() {
        let seqPtr = UnsafeMutablePointer<UInt32>.allocate(capacity: 4)
        seqPtr.initialize(to: 0, count: 4)
        seqPtr[0] = 0xe7e8c006
        seqPtr[1] = 0xc4f9417d
        seqPtr[2] = 0x6479b4b2
        seqPtr[3] = 0x68c67137
        Salsa20Cipher.printQuarterRound(seqPtr)
        Salsa20Cipher.quarterRound(ptr0: seqPtr, ptr1: (seqPtr+1), ptr2: (seqPtr+2), ptr3: (seqPtr+3))
        Salsa20Cipher.printQuarterRound(seqPtr)
        assertPairsEqual(expected: 0xe876d72b, actual: seqPtr[0])
        assertPairsEqual(expected: 0x9361dfd5, actual: seqPtr[1])
        assertPairsEqual(expected: 0xf1460244, actual: seqPtr[2])
        assertPairsEqual(expected: 0x948541a3, actual: seqPtr[3])
    }

    func testQuarterRound6() {
        let seqPtr = UnsafeMutablePointer<UInt32>.allocate(capacity: 4)
        seqPtr.initialize(to: 0, count: 4)
        seqPtr[0] = 0xd3917c5b
        seqPtr[1] = 0x55f1c407
        seqPtr[2] = 0x52a58a7a
        seqPtr[3] = 0x8f887a3b
        Salsa20Cipher.printQuarterRound(seqPtr)
        Salsa20Cipher.quarterRound(ptr0: seqPtr, ptr1: (seqPtr+1), ptr2: (seqPtr+2), ptr3: (seqPtr+3))
        Salsa20Cipher.printQuarterRound(seqPtr)
        assertPairsEqual(expected: 0x3e2f308c, actual: seqPtr[0])
        assertPairsEqual(expected: 0xd90a8f36, actual: seqPtr[1])
        assertPairsEqual(expected: 0x6ab2a923, actual: seqPtr[2])
        assertPairsEqual(expected: 0x2883524c, actual: seqPtr[3])
    }

    func testRowRound0() {
        let seqPtr = UnsafeMutablePointer<UInt32>.allocate(capacity: 16)
        seqPtr[00] = 0x00000001
        seqPtr[01] = 0x00000000
        seqPtr[02] = 0x00000000
        seqPtr[03] = 0x00000000
        seqPtr[04] = 0x00000001
        seqPtr[05] = 0x00000000
        seqPtr[06] = 0x00000000
        seqPtr[07] = 0x00000000
        seqPtr[08] = 0x00000001
        seqPtr[09] = 0x00000000
        seqPtr[10] = 0x00000000
        seqPtr[11] = 0x00000000
        seqPtr[12] = 0x00000001
        seqPtr[13] = 0x00000000
        seqPtr[14] = 0x00000000
        seqPtr[15] = 0x00000000
        Salsa20Cipher.printQuarterRound(seqPtr)
        Salsa20Cipher.rowRound(seqPtr)
        Salsa20Cipher.printQuarterRound(seqPtr)
        assertPairsEqual(expected: 0x08008145, actual: seqPtr[00])
        assertPairsEqual(expected: 0x00000080, actual: seqPtr[01])
        assertPairsEqual(expected: 0x00010200, actual: seqPtr[02])
        assertPairsEqual(expected: 0x20500000, actual: seqPtr[03])
        assertPairsEqual(expected: 0x20100001, actual: seqPtr[04])
        assertPairsEqual(expected: 0x00048044, actual: seqPtr[05])
        assertPairsEqual(expected: 0x00000080, actual: seqPtr[06])
        assertPairsEqual(expected: 0x00010000, actual: seqPtr[07])
        assertPairsEqual(expected: 0x00000001, actual: seqPtr[08])
        assertPairsEqual(expected: 0x00002000, actual: seqPtr[09])
        assertPairsEqual(expected: 0x80040000, actual: seqPtr[10])
        assertPairsEqual(expected: 0x00000000, actual: seqPtr[11])
        assertPairsEqual(expected: 0x00000001, actual: seqPtr[12])
        assertPairsEqual(expected: 0x00000200, actual: seqPtr[13])
        assertPairsEqual(expected: 0x00402000, actual: seqPtr[14])
        assertPairsEqual(expected: 0x88000100, actual: seqPtr[15])
    }

    func testRowRound1() {
        let seqPtr = UnsafeMutablePointer<UInt32>.allocate(capacity: 16)
        seqPtr[00] = 0x08521bd6
        seqPtr[01] = 0x1fe88837
        seqPtr[02] = 0xbb2aa576
        seqPtr[03] = 0x3aa26365
        seqPtr[04] = 0xc54c6a5b
        seqPtr[05] = 0x2fc74c2f
        seqPtr[06] = 0x6dd39cc3
        seqPtr[07] = 0xda0a64f6
        seqPtr[08] = 0x90a2f23d
        seqPtr[09] = 0x067f95a6
        seqPtr[10] = 0x06b35f61
        seqPtr[11] = 0x41e4732e
        seqPtr[12] = 0xe859c100
        seqPtr[13] = 0xea4d84b7
        seqPtr[14] = 0x0f619bff
        seqPtr[15] = 0xbc6e965a
        Salsa20Cipher.printQuarterRound(seqPtr)
        Salsa20Cipher.rowRound(seqPtr)
        Salsa20Cipher.printQuarterRound(seqPtr)
        assertPairsEqual(expected: 0xa890d39d, actual: seqPtr[00])
        assertPairsEqual(expected: 0x65d71596, actual: seqPtr[01])
        assertPairsEqual(expected: 0xe9487daa, actual: seqPtr[02])
        assertPairsEqual(expected: 0xc8ca6a86, actual: seqPtr[03])
        assertPairsEqual(expected: 0x949d2192, actual: seqPtr[04])
        assertPairsEqual(expected: 0x764b7754, actual: seqPtr[05])
        assertPairsEqual(expected: 0xe408d9b9, actual: seqPtr[06])
        assertPairsEqual(expected: 0x7a41b4d1, actual: seqPtr[07])
        assertPairsEqual(expected: 0x3402e183, actual: seqPtr[08])
        assertPairsEqual(expected: 0x3c3af432, actual: seqPtr[09])
        assertPairsEqual(expected: 0x50669f96, actual: seqPtr[10])
        assertPairsEqual(expected: 0xd89ef0a8, actual: seqPtr[11])
        assertPairsEqual(expected: 0x0040ede5, actual: seqPtr[12])
        assertPairsEqual(expected: 0xb545fbce, actual: seqPtr[13])
        assertPairsEqual(expected: 0xd257ed4f, actual: seqPtr[14])
        assertPairsEqual(expected: 0x1818882d, actual: seqPtr[15])
    }

    func testColumnRound0() {
        let seqPtr = UnsafeMutablePointer<UInt32>.allocate(capacity: 16)
        seqPtr[00] = 0x00000001
        seqPtr[01] = 0x00000000
        seqPtr[02] = 0x00000000
        seqPtr[03] = 0x00000000
        seqPtr[04] = 0x00000001
        seqPtr[05] = 0x00000000
        seqPtr[06] = 0x00000000
        seqPtr[07] = 0x00000000
        seqPtr[08] = 0x00000001
        seqPtr[09] = 0x00000000
        seqPtr[10] = 0x00000000
        seqPtr[11] = 0x00000000
        seqPtr[12] = 0x00000001
        seqPtr[13] = 0x00000000
        seqPtr[14] = 0x00000000
        seqPtr[15] = 0x00000000
        Salsa20Cipher.printQuarterRound(seqPtr)
        Salsa20Cipher.columnRound(seqPtr)
        Salsa20Cipher.printQuarterRound(seqPtr)
        assertPairsEqual(expected: 0x10090288, actual: seqPtr[00])
        assertPairsEqual(expected: 0x00000000, actual: seqPtr[01])
        assertPairsEqual(expected: 0x00000000, actual: seqPtr[02])
        assertPairsEqual(expected: 0x00000000, actual: seqPtr[03])
        assertPairsEqual(expected: 0x00000101, actual: seqPtr[04])
        assertPairsEqual(expected: 0x00000000, actual: seqPtr[05])
        assertPairsEqual(expected: 0x00000000, actual: seqPtr[06])
        assertPairsEqual(expected: 0x00000000, actual: seqPtr[07])
        assertPairsEqual(expected: 0x00020401, actual: seqPtr[08])
        assertPairsEqual(expected: 0x00000000, actual: seqPtr[09])
        assertPairsEqual(expected: 0x00000000, actual: seqPtr[10])
        assertPairsEqual(expected: 0x00000000, actual: seqPtr[11])
        assertPairsEqual(expected: 0x40a04001, actual: seqPtr[12])
        assertPairsEqual(expected: 0x00000000, actual: seqPtr[13])
        assertPairsEqual(expected: 0x00000000, actual: seqPtr[14])
        assertPairsEqual(expected: 0x00000000, actual: seqPtr[15])
    }

    func testColumnRound1() {
        let seqPtr = UnsafeMutablePointer<UInt32>.allocate(capacity: 16)
        seqPtr[00] = 0x08521bd6
        seqPtr[01] = 0x1fe88837
        seqPtr[02] = 0xbb2aa576
        seqPtr[03] = 0x3aa26365
        seqPtr[04] = 0xc54c6a5b
        seqPtr[05] = 0x2fc74c2f
        seqPtr[06] = 0x6dd39cc3
        seqPtr[07] = 0xda0a64f6
        seqPtr[08] = 0x90a2f23d
        seqPtr[09] = 0x067f95a6
        seqPtr[10] = 0x06b35f61
        seqPtr[11] = 0x41e4732e
        seqPtr[12] = 0xe859c100
        seqPtr[13] = 0xea4d84b7
        seqPtr[14] = 0x0f619bff
        seqPtr[15] = 0xbc6e965a
        Salsa20Cipher.printQuarterRound(seqPtr)
        Salsa20Cipher.columnRound(seqPtr)
        Salsa20Cipher.printQuarterRound(seqPtr)
        assertPairsEqual(expected: 0x8c9d190a, actual: seqPtr[00])
        assertPairsEqual(expected: 0xce8e4c90, actual: seqPtr[01])
        assertPairsEqual(expected: 0x1ef8e9d3, actual: seqPtr[02])
        assertPairsEqual(expected: 0x1326a71a, actual: seqPtr[03])
        assertPairsEqual(expected: 0x90a20123, actual: seqPtr[04])
        assertPairsEqual(expected: 0xead3c4f3, actual: seqPtr[05])
        assertPairsEqual(expected: 0x63a091a0, actual: seqPtr[06])
        assertPairsEqual(expected: 0xf0708d69, actual: seqPtr[07])
        assertPairsEqual(expected: 0x789b010c, actual: seqPtr[08])
        assertPairsEqual(expected: 0xd195a681, actual: seqPtr[09])
        assertPairsEqual(expected: 0xeb7d5504, actual: seqPtr[10])
        assertPairsEqual(expected: 0xa774135c, actual: seqPtr[11])
        assertPairsEqual(expected: 0x481c2027, actual: seqPtr[12])
        assertPairsEqual(expected: 0x53a8e4b5, actual: seqPtr[13])
        assertPairsEqual(expected: 0x4c1f89c5, actual: seqPtr[14])
        assertPairsEqual(expected: 0x3f78c9c8, actual: seqPtr[15])
    }

    func testDoubleRound0() {
        let seqPtr = UnsafeMutablePointer<UInt32>.allocate(capacity: 16)
        seqPtr[00] = 0x00000001
        seqPtr[01] = 0x00000000
        seqPtr[02] = 0x00000000
        seqPtr[03] = 0x00000000
        seqPtr[04] = 0x00000000
        seqPtr[05] = 0x00000000
        seqPtr[06] = 0x00000000
        seqPtr[07] = 0x00000000
        seqPtr[08] = 0x00000000
        seqPtr[09] = 0x00000000
        seqPtr[10] = 0x00000000
        seqPtr[11] = 0x00000000
        seqPtr[12] = 0x00000000
        seqPtr[13] = 0x00000000
        seqPtr[14] = 0x00000000
        seqPtr[15] = 0x00000000
        Salsa20Cipher.printQuarterRound(seqPtr)
        Salsa20Cipher.doubleRound(seqPtr)
        Salsa20Cipher.printQuarterRound(seqPtr)
        assertPairsEqual(expected: 0x8186a22d, actual: seqPtr[00])
        assertPairsEqual(expected: 0x0040a284, actual: seqPtr[01])
        assertPairsEqual(expected: 0x82479210, actual: seqPtr[02])
        assertPairsEqual(expected: 0x06929051, actual: seqPtr[03])
        assertPairsEqual(expected: 0x08000090, actual: seqPtr[04])
        assertPairsEqual(expected: 0x02402200, actual: seqPtr[05])
        assertPairsEqual(expected: 0x00004000, actual: seqPtr[06])
        assertPairsEqual(expected: 0x00800000, actual: seqPtr[07])
        assertPairsEqual(expected: 0x00010200, actual: seqPtr[08])
        assertPairsEqual(expected: 0x20400000, actual: seqPtr[09])
        assertPairsEqual(expected: 0x08008104, actual: seqPtr[10])
        assertPairsEqual(expected: 0x00000000, actual: seqPtr[11])
        assertPairsEqual(expected: 0x20500000, actual: seqPtr[12])
        assertPairsEqual(expected: 0xa0000040, actual: seqPtr[13])
        assertPairsEqual(expected: 0x0008180a, actual: seqPtr[14])
        assertPairsEqual(expected: 0x612a8020, actual: seqPtr[15])
    }

    func testDoubleRound1() {
        let seqPtr = UnsafeMutablePointer<UInt32>.allocate(capacity: 16)
        seqPtr[00] = 0xde501066
        seqPtr[01] = 0x6f9eb8f7
        seqPtr[02] = 0xe4fbbd9b
        seqPtr[03] = 0x454e3f57
        seqPtr[04] = 0xb75540d3
        seqPtr[05] = 0x43e93a4c
        seqPtr[06] = 0x3a6f2aa0
        seqPtr[07] = 0x726d6b36
        seqPtr[08] = 0x9243f484
        seqPtr[09] = 0x9145d1e8
        seqPtr[10] = 0x4fa9d247
        seqPtr[11] = 0xdc8dee11
        seqPtr[12] = 0x054bf545
        seqPtr[13] = 0x254dd653
        seqPtr[14] = 0xd9421b6d
        seqPtr[15] = 0x67b276c1
        Salsa20Cipher.printQuarterRound(seqPtr)
        Salsa20Cipher.doubleRound(seqPtr)
        Salsa20Cipher.printQuarterRound(seqPtr)
        assertPairsEqual(expected: 0xccaaf672, actual: seqPtr[00])
        assertPairsEqual(expected: 0x23d960f7, actual: seqPtr[01])
        assertPairsEqual(expected: 0x9153e63a, actual: seqPtr[02])
        assertPairsEqual(expected: 0xcd9a60d0, actual: seqPtr[03])
        assertPairsEqual(expected: 0x50440492, actual: seqPtr[04])
        assertPairsEqual(expected: 0xf07cad19, actual: seqPtr[05])
        assertPairsEqual(expected: 0xae344aa0, actual: seqPtr[06])
        assertPairsEqual(expected: 0xdf4cfdfc, actual: seqPtr[07])
        assertPairsEqual(expected: 0xca531c29, actual: seqPtr[08])
        assertPairsEqual(expected: 0x8e7943db, actual: seqPtr[09])
        assertPairsEqual(expected: 0xac1680cd, actual: seqPtr[10])
        assertPairsEqual(expected: 0xd503ca00, actual: seqPtr[11])
        assertPairsEqual(expected: 0xa74b2ad6, actual: seqPtr[12])
        assertPairsEqual(expected: 0xbc331c5c, actual: seqPtr[13])
        assertPairsEqual(expected: 0x1dda24c7, actual: seqPtr[14])
        assertPairsEqual(expected: 0xee928277, actual: seqPtr[15])
    }

    func testLoadLE0() {
        let uint32 = UnsafeMutablePointer<UInt8>.allocate(capacity: 4)
        uint32[00] = 0x00
        uint32[01] = 0x00
        uint32[02] = 0x00
        uint32[03] = 0x00
        let leUInt32: UInt32 = Salsa20Cipher.read(uint32)
        assertPairsEqual(expected: 0x00000000, actual: leUInt32)
        print(leUInt32.hexString)
    }

    func testLoadLE1() {
        let uint32 = UnsafeMutablePointer<UInt8>.allocate(capacity: 4)
        uint32[00] = 86
        uint32[01] = 75
        uint32[02] = 30
        uint32[03] = 09
        let leUInt32: UInt32 = Salsa20Cipher.read(uint32)
        assertPairsEqual(expected: 0x091e4b56, actual: leUInt32)
    }

    func testLoadLE2() {
        let uint32 = UnsafeMutablePointer<UInt8>.allocate(capacity: 4)
        uint32[00] = 255
        uint32[01] = 255
        uint32[02] = 255
        uint32[03] = 250
        let leUInt32: UInt32 = Salsa20Cipher.read(uint32)
        assertPairsEqual(expected: 0xfaffffff, actual: leUInt32)
    }

    func testStoreLE0() {
        let bytesRawPtr = UnsafeMutableRawPointer.allocate(bytes: 4, alignedTo: MemoryLayout<UInt32>.alignment)
        let bytesPtr = bytesRawPtr.initializeMemory(as: UInt8.self, count: 4, to: 0xFF)

        var uint32: UInt32 = 0x00000000
        withUnsafeMutablePointer(to: &uint32) { uint32Ptr -> Void in
            Salsa20Cipher.write(uint32Ptr, to: bytesPtr)
        }
        assertPairsEqual(expected: 0x00, actual: bytesPtr[0])
        assertPairsEqual(expected: 0x00, actual: bytesPtr[1])
        assertPairsEqual(expected: 0x00, actual: bytesPtr[2])
        assertPairsEqual(expected: 0x00, actual: bytesPtr[3])
    }

    func testStoreLE1() {
        let bytesRawPtr = UnsafeMutableRawPointer.allocate(bytes: 4, alignedTo: MemoryLayout<UInt32>.alignment)
        let bytesPtr = bytesRawPtr.initializeMemory(as: UInt8.self, count: 4, to: 0xFF)

        var uint32: UInt32 = 0x091e4b56
        print(uint32.hexString)
        withUnsafeMutablePointer(to: &uint32) { uint32Ptr -> Void in
            Salsa20Cipher.write(uint32Ptr, to: bytesPtr)
        }
        assertPairsEqual(expected: 0x56, actual: bytesPtr[0])
        assertPairsEqual(expected: 0x4b, actual: bytesPtr[1])
        assertPairsEqual(expected: 0x1e, actual: bytesPtr[2])
        assertPairsEqual(expected: 0x09, actual: bytesPtr[3])
    }

    func testStoreLE2() {
        let bytesRawPtr = UnsafeMutableRawPointer.allocate(bytes: 4, alignedTo: MemoryLayout<UInt32>.alignment)
        let bytesPtr = bytesRawPtr.initializeMemory(as: UInt8.self, count: 4, to: 0xFF)

        var uint32: UInt32 = 0xfaffffff
        withUnsafeMutablePointer(to: &uint32) { uint32Ptr -> Void in
            Salsa20Cipher.write(uint32Ptr, to: bytesPtr)
        }
        assertPairsEqual(expected: 255, actual: bytesPtr[0])
        assertPairsEqual(expected: 255, actual: bytesPtr[1])
        assertPairsEqual(expected: 255, actual: bytesPtr[2])
        assertPairsEqual(expected: 250, actual: bytesPtr[3])
    }

    func testVector0() {
        let cryptor: Salsa20Cipher! = try! Salsa20Cipher(withKey: TestVector0.key, iv: TestVector0.iv)
        let dataLength = TestVector1.stream.count
        let encryptedBytes = UnsafeMutablePointer<UInt8>.allocate(capacity: dataLength)
        encryptedBytes.initialize(to: 0, count: dataLength)
        TestVector0.stream.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> Void in
            cryptor.encrypt(input: bytes, output: encryptedBytes, length: dataLength)
        }

        let decryptor: Salsa20Cipher! = try! Salsa20Cipher(withKey: TestVector0.key, iv: TestVector0.iv)
        let decryptedBytes = UnsafeMutablePointer<UInt8>.allocate(capacity: dataLength)
        decryptedBytes.initialize(to: 0, count: dataLength)
        decryptor.encrypt(input: encryptedBytes, output: decryptedBytes, length: dataLength)
        let decryptedResult = Data(bytes: decryptedBytes, count: dataLength)
        assertPairsEqual(expected: TestVector0.stream, actual: decryptedResult)
    }

    func testVector1() {
        let cryptor: Salsa20Cipher! = try! Salsa20Cipher(withKey: TestVector1.key, iv: TestVector1.iv)
        let dataLength = TestVector1.stream.count
        let encryptedBytes = UnsafeMutablePointer<UInt8>.allocate(capacity: dataLength)
        encryptedBytes.initialize(to: 0, count: dataLength)
        TestVector1.stream.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> Void in
            cryptor.encrypt(input: bytes, output: encryptedBytes, length: dataLength)
        }

        let decryptor: Salsa20Cipher! = try! Salsa20Cipher(withKey: TestVector1.key, iv: TestVector1.iv)
        let decryptedBytes = UnsafeMutablePointer<UInt8>.allocate(capacity: dataLength)
        decryptedBytes.initialize(to: 0, count: dataLength)
        decryptor.encrypt(input: encryptedBytes, output: decryptedBytes, length: dataLength)
        let decryptedResult = Data(bytes: decryptedBytes, count: dataLength)
        assertPairsEqual(expected: TestVector1.stream, actual: decryptedResult)
    }

    func testVector2() {
        let cryptor: Salsa20Cipher! = try! Salsa20Cipher(withKey: TestVector2.key, iv: TestVector2.iv)
        let dataLength = TestVector2.stream.count
        let encryptedBytes = UnsafeMutablePointer<UInt8>.allocate(capacity: dataLength)
        encryptedBytes.initialize(to: 0, count: dataLength)
        TestVector2.stream.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> Void in
            cryptor.encrypt(input: bytes, output: encryptedBytes, length: dataLength)
        }

        let decryptor: Salsa20Cipher! = try! Salsa20Cipher(withKey: TestVector2.key, iv: TestVector2.iv)
        let decryptedBytes = UnsafeMutablePointer<UInt8>.allocate(capacity: dataLength)
        decryptedBytes.initialize(to: 0, count: dataLength)
        decryptor.encrypt(input: encryptedBytes, output: decryptedBytes, length: dataLength)
        let decryptedResult = Data(bytes: decryptedBytes, count: dataLength)
        assertPairsEqual(expected: TestVector2.stream, actual: decryptedResult)
    }

    func testVector3() {
        let cryptor: Salsa20Cipher! = try! Salsa20Cipher(withKey: TestVector3.key, iv: TestVector3.iv)
        let dataLength = TestVector3.stream.count
        let encryptedBytes = UnsafeMutablePointer<UInt8>.allocate(capacity: dataLength)
        encryptedBytes.initialize(to: 0, count: dataLength)
        TestVector3.stream.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> Void in
            cryptor.encrypt(input: bytes, output: encryptedBytes, length: dataLength)
        }

        let decryptor: Salsa20Cipher! = try! Salsa20Cipher(withKey: TestVector3.key, iv: TestVector3.iv)
        let decryptedBytes = UnsafeMutablePointer<UInt8>.allocate(capacity: dataLength)
        decryptedBytes.initialize(to: 0, count: dataLength)
        decryptor.encrypt(input: encryptedBytes, output: decryptedBytes, length: dataLength)
        let decryptedResult = Data(bytes: decryptedBytes, count: dataLength)
        assertPairsEqual(expected: TestVector3.stream, actual: decryptedResult)
    }
}



