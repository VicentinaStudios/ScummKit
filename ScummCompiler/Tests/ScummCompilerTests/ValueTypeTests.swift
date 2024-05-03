//
//  File.swift
//  
//
//  Created by Michael Borgmann on 03/05/2024.
//

import XCTest
@testable import ScummCompiler

class ValueTests: XCTestCase {

    func testEquatable() {
        XCTAssertEqual(Value.int(5), Value.int(5))
        XCTAssertEqual(Value.bool(true), Value.bool(true))
        XCTAssertNotEqual(Value.double(3.14), Value.int(3))
    }

    func testInitialization() {
        XCTAssertEqual(Value.int(10), .int(10))
        XCTAssertEqual(Value.bool(false), .bool(false))
        XCTAssertEqual(Value.double(3.14), .double(3.14))
        XCTAssertEqual(Value.string("hello"), .string("hello"))
        XCTAssertEqual(Value.nil, .nil)
    }

    func testEquality() {
        XCTAssertEqual(Value.int(5), Value.int(5))
        XCTAssertNotEqual(Value.int(5), Value.int(10))
        XCTAssertNotEqual(Value.int(5), Value.double(5.0))
    }
}
