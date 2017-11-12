//
//  TestConstants.swift
//  SalsaCipher_Tests
//
//  Created by Igor Kotkovets on 11/3/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

struct TestConstants {
    static let filePath: String! = Bundle(for: FileInputStreamTests.self).path(forResource: "OpenText", ofType: "txt")
    static let text: String = try! String(contentsOfFile: filePath)
    static let textData: Data! = text.data(using: .utf8)
    static let textLength = text.count
    static let keyString = "0123456789abcdef0123456789abcdef"
    static let keyData = keyString.data(using: .utf8)!
    static let ivString = "01234567"
    static let ivData = ivString.data(using: .utf8)!
}
