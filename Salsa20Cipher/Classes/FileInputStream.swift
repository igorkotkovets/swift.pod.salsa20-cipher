//
//  FileInputStream.swift
//  Pods
//
//  Created by Igor Kotkovets on 11/3/17.
//

import Foundation

public class FileInputStream: InputStream {
    let fileHandle: FileHandle
    var eofReached = false

    public init(withFileHandle: FileHandle) {
        self.fileHandle = withFileHandle
    }

    public var hasBytesAvailable: Bool {
        return !eofReached
    }

    public func read(_ buffer: UnsafeMutablePointer<UInt8>, maxLength len: Int) -> Int {
        let readData = fileHandle.readData(ofLength: len)
        eofReached = (readData.count != len)
        readData.withUnsafeBytes { (ptr: UnsafePointer<UInt8>) in
            buffer.initialize(from: ptr, count: readData.count)
        }

        return readData.count
    }
}
