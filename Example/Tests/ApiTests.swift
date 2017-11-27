//
//  ApiTests.swift
//  Salsa20Cipher_Tests
//
//  Created by Igor Kotkovets on 11/27/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import Salsa20Cipher

class ApiTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testApi() {
        let url = Bundle(for: ApiTests.self).url(forResource: "OpenText", withExtension: "txt")!
        do {
            let fileHandle = try FileHandle(forReadingFrom: url)
            let stream = FileInputStream(withFileHandle: fileHandle)
            let key = Data(count: 16)
            let iv = Data(count: 8)
            _ = try Salsa20CipherStream(withStream: stream, key: key, iv: iv)
        } catch {

        }
    }
    
}
