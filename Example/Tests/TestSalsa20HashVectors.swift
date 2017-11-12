//
//  TestSalsa20HashVectors.swift
//  SalsaCipher_Tests
//
//  Created by Igor Kotkovets on 11/7/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

protocol TestSalsa20HashVector {
    var inputBufferText: String { get }
    var expectedBufferText: String { get }
}

extension TestSalsa20HashVector {

    func inputBuffer() -> UnsafeMutablePointer<UInt8> {
        let ptr = UnsafeMutablePointer<UInt8>.allocate(capacity: 64)
        var bytes = inputBufferText.bytesArray()
        for i in 0..<64 {
            ptr[i] = bytes[i]
        }

        return ptr
    }

    func expectBuffer() -> UnsafeMutablePointer<UInt8> {
        let ptr = UnsafeMutablePointer<UInt8>.allocate(capacity: 64)
        var bytes = expectedBufferText.bytesArray()
        for i in 0..<64 {
            ptr[i] = bytes[i]
        }

        return ptr
    }
}

struct TestSalsa20HashVector0: TestSalsa20HashVector {
    let inputBufferText = "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
    let expectedBufferText = "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"
}

struct TestSalsa20HashVector1: TestSalsa20HashVector {
    let inputBufferText = "211,159,13,115,76,55,82,183,3,117,222,37,191,187,234,136,49,237,179,48,1,106,178,219,175,199,166,48,86,16,179,207,31,240,32,63,15,83,93,161,116,147,48,113,238,55,204,36,79,201,235,79,3,81,156,47,203,26,244,243,88,118,104,54"
    let expectedBufferText = "109,42,178,168,156,240,248,238,168,196,190,203,26,110,170,154,29,29,150,26,150,30,235,249,190,163,251,48,69,144,51,57,118,40,152,157,180,57,27,94,107,42,236,35,27,111,114,114,219,236,232,135,111,155,110,18,24,232,95,158,179,19,48,202"
}

struct TestSalsa20HashVector2: TestSalsa20HashVector {
    let inputBufferText = "88,118,104,54,79,201,235,79,3,81,156,47,203,26,244,243,191,187,234,136,211,159,13,115,76,55,82,183,3,117,222,37,86,16,179,207,49,237,179,48,1,106,178,219,175,199,166,48,238,55,204,36,31,240,32,63,15,83,93,161,116,147,48,113"
    let expectedBufferText = "179,19,48,202,219,236,232,135,111,155,110,18,24,232,95,158,26,110,170,154,109,42,178,168,156,240,248,238,168,196,190,203,69,144,51,57,29,29,150,26,150,30,235,249,190,163,251,48,27,111,114,114,118,40,152,157,180,57,27,94,107,42,236,35"
}

struct TestSalsa20HashVector3: TestSalsa20HashVector {
    let inputBufferText = "6,124,83,146,38,191,9,50,4,161,47,222,122,182,223,185,75,27,0,216,16,122,7,89,162,104,101,147,213,21,54,95,225,253,139,176,105,132,23,116,76,41,176,207,221,34,157,108,94,94,99,52,90,117,91,220,146,190,239,143,196,176,130,186"
    let expectedBufferText = "8,18,38,199,119,76,215,67,173,127,144,162,103,212,176,217,192,19,233,33,159,197,154,160,128,243,219,65,171,136,135,225,123,11,68,86,237,82,20,155,133,189,9,83,167,116,194,78,122,127,195,185,185,204,188,90,245,9,183,248,226,85,245,104"
}

extension String {
    func charsArray() -> [String] {
        return self.components(separatedBy: [","])
    }

    func bytesArray() -> [UInt8] {
        return self.charsArray().flatMap { UInt8($0, radix: 10) }
    }
}
