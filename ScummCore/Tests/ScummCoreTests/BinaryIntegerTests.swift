//
//  XorEncryptionTests.swift
//  
//
//  Created by Michael Borgmann on 15/09/2023.
//

import XCTest

final class BinaryIntegerTests: XCTestCase {
    
    func testXORDecryption() {
        
        let encryptedValue: UInt32 = 0x12345678
        let key: UInt32 = 0x69
        let expectedDecryptedValue: UInt32 = 0x7B5D3F11
        
        let decryptedValue = encryptedValue.xorDecrypt(key: key)
        
        XCTAssertEqual(decryptedValue, expectedDecryptedValue, "XOR decryption failed")
    }
    
    func testUInt32ToString() {
        
        let uint32: UInt32 = 1380860237
        
        let string = uint32.string
            
        XCTAssertEqual(string, "RNAM")
    }
}
