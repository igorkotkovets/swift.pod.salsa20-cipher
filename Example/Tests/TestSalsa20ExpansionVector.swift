//
//  TestSalsa20ExpansionVector.swift
//  SalsaCipher_Example
//
//  Created by Igor Kotkovets on 11/10/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

protocol TestSalsa20ExpansionVector {
    var keyText: String { get }
    var ivText: String { get }
    var expansionState: String { get }
    var expectedBufferText: String { get }
}

extension TestSalsa20ExpansionVector {

    func keyData() -> Data {
        let bytes = keyText.bytesArray()
        return Data(bytes: bytes)
    }

    func ivData() -> Data {
        let bytes = ivText.bytesArray()
        return Data(bytes: bytes)
    }

    func expansionStateBuffer() -> UnsafeMutablePointer<UInt8> {
        let ptr = UnsafeMutablePointer<UInt8>.allocate(capacity: 64)
        var bytes = expansionState.bytesArray()
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

struct TestSalsa20ExpansionVector0: TestSalsa20ExpansionVector {
    let expansionState = "101,120,112,97,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,110,100,32,51,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,50,45,98,121,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,116,101,32,107"
    let expectedBufferText = "69,37,68,39,41,15,107,193,255,139,122,6,170,233,217,98,89,144,182,106,21,51,200,65,239,49,222,34,215,114,40,126,104,197,7,225,197,153,31,2,102,78,76,176,84,245,246,184,177,160,133,130,6,72,149,119,192,195,132,236,234,103,246,74"
    let keyText: String = "1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216"
    let ivText: String = "101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116"
}
