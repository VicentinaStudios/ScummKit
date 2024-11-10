//
//  OpcodeTests.swift
//  
//
//  Created by Michael Borgmann on 14/12/2023.
//

import XCTest
@testable import ScummCompiler

final class OpcodeTests: XCTestCase {
    
    func testExistingMojoOpcodes() throws {
        XCTAssertTrue(MojoOpcode.allCases.count == 11)
        XCTAssertTrue(MojoOpcode.allCases.contains(.add))
        XCTAssertTrue(MojoOpcode.allCases.contains(.subtract))
        XCTAssertTrue(MojoOpcode.allCases.contains(.multiply))
        XCTAssertTrue(MojoOpcode.allCases.contains(.divide))
        XCTAssertTrue(MojoOpcode.allCases.contains(.return))
        XCTAssertTrue(MojoOpcode.allCases.contains(.constant))
        XCTAssertTrue(MojoOpcode.allCases.contains(.negate))
        XCTAssertTrue(MojoOpcode.allCases.contains(.true))
        XCTAssertTrue(MojoOpcode.allCases.contains(.false))
        XCTAssertTrue(MojoOpcode.allCases.contains(.nil))
        XCTAssertTrue(MojoOpcode.allCases.contains(.not))
    }
    
    func testExistingScummOpcodes() throws {
        XCTAssertTrue(ScummOpcode.allCases.count == 2)
        XCTAssertTrue(ScummOpcode.allCases.contains(.breakHere))
        XCTAssertTrue(ScummOpcode.allCases.contains(.expression))
    }
}
