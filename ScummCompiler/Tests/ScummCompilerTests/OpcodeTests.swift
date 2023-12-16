//
//  OpcodeTests.swift
//  
//
//  Created by Michael Borgmann on 14/12/2023.
//

import XCTest
@testable import ScummCompiler

final class OpcodeTests: XCTestCase {


    func testExistingOpcodes() throws {
        
        XCTAssertTrue(Opcode.allCases.count == 1)
        
        XCTAssertTrue(Opcode.allCases.contains(.breakHere))
    }
}
