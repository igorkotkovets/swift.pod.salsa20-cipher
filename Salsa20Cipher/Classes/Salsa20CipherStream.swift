//
//  SalsaCipherStream.swift
//  Pods
//
//  Created by Igor Kotkovets on 11/3/17.
//

import Foundation

//http://www.ecrypt.eu.org/stream/svn/viewcvs.cgi/ecrypt/trunk/submissions/salsa20/full/verified.test-vectors?logsort=rev&rev=210&view=markup
public class Salsa20CipherStream: InputStream {
    let blockSize = 64
    var inputBuffer: UnsafeMutablePointer<UInt8>
    var outputBuffer: UnsafeMutablePointer<UInt8>
    var bufferSize = 0
    var bufferOffset = 0
    var eofReached = false
    var inputStream: InputStream
    var cipher: Salsa20Cipher?

    public var hasBytesAvailable: Bool {
        return !eofReached
    }

    public init?(withStream: InputStream, key: Data, iv vector: Data) throws {
        self.inputStream = withStream
        cipher = try Salsa20Cipher(withKey: key, iv: vector)
        inputBuffer = UnsafeMutablePointer.allocate(capacity: blockSize)
        outputBuffer = UnsafeMutablePointer.allocate(capacity: blockSize)
    }

    deinit {
        inputBuffer.deallocate(capacity: blockSize)
        outputBuffer.deallocate(capacity: blockSize)
    }

    public func read(_ buffer: UnsafeMutablePointer<UInt8>, maxLength len: Int) -> Int {
        var remaining = len
        var writePtr = buffer

        while remaining > 0 {
            if bufferOffset >= bufferSize {
                if process() == false {
                    return len - remaining
                }
            }

            let existsData = min(remaining, bufferSize - bufferOffset)
            writePtr.initialize(from: (inputBuffer+bufferOffset), count: existsData)

            bufferOffset += existsData
            writePtr += existsData
            remaining -= existsData
        }

        return len
    }

    func process() -> Bool {
        if eofReached {
            return false
        }

        bufferOffset = 0
        bufferSize = 0
        var inputBytes = 0

        inputBytes = inputStream.read(inputBuffer, maxLength: blockSize)
        if inputBytes < blockSize {
            eofReached = true
        }
        cipher?.encrypt(input: inputBuffer, output: outputBuffer, length: inputBytes)
        bufferSize += inputBytes
        return true
    }
}
