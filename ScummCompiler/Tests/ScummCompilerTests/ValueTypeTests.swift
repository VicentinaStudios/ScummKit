//
//  File.swift
//  
//
//  Created by Michael Borgmann on 03/05/2024.
//

import XCTest
@testable import ScummCompiler

class ValueTests: XCTestCase {
    
    private func stringValue(_ str: String) -> Value {
        return .object(Object(type: .string(str)))
    }

    func testEquatable() {
        XCTAssertEqual(Value.int(5), Value.int(5))
        XCTAssertEqual(Value.bool(true), Value.bool(true))
        XCTAssertNotEqual(Value.double(3.14), Value.int(3))
    }

    func testInitialization() {
        XCTAssertEqual(Value.int(10), .int(10))
        XCTAssertEqual(Value.bool(false), .bool(false))
        XCTAssertEqual(Value.double(3.14), .double(3.14))
        XCTAssertEqual(Value.nil, .nil)
        XCTAssertEqual(stringValue("hello"), stringValue("hello"))
    }
    
    func testEquality() {
        // Test equality between two identical `int` values
        XCTAssertEqual(Value.int(5), Value.int(5))
        XCTAssertNotEqual(Value.int(5), Value.int(10))
        
        // Test `int` vs `double`
        XCTAssertNotEqual(Value.int(5), Value.double(5.0))
        
        // Test equality of `bool` values
        XCTAssertEqual(Value.bool(true), Value.bool(true))
        XCTAssertNotEqual(Value.bool(true), Value.bool(false))
        
        // Test equality of `double` values
        XCTAssertEqual(Value.double(3.14), Value.double(3.14))
        XCTAssertNotEqual(Value.double(3.14), Value.double(2.71))
        
        // Test equality of `string` values
        XCTAssertEqual(stringValue("hello"), stringValue("hello"))
        XCTAssertNotEqual(stringValue("hello"), stringValue("world"))
        
        // Test equality of `nil` values
        XCTAssertEqual(Value.nil, Value.nil)
        
        // Test `nil` vs other types
        XCTAssertNotEqual(Value.nil, Value.bool(false))
        
        // Test `nil` vs `bool(false)`
        XCTAssertNotEqual(Value.nil, Value.bool(false))
        
        // Test operator overloading for `==`
        XCTAssertTrue(Value.int(5) == Value.int(5))
        XCTAssertTrue(Value.bool(true) == Value.bool(true))
        XCTAssertTrue(Value.double(3.14) == Value.double(3.14))
        XCTAssertTrue(Value.nil == Value.nil)
        XCTAssertTrue(stringValue("hello") == stringValue("hello"))
    }
    
    func testFalsey() {
        
        // Falsey cases
        XCTAssertTrue(Value.bool(5 == 6).isFalsey)
        XCTAssertTrue(Value.bool(5 > 6).isFalsey)
        XCTAssertTrue(Value.bool(5 >= 6).isFalsey)
        
        // Truthy cases
        XCTAssertFalse(Value.bool(5 != 6).isFalsey)
        XCTAssertFalse(Value.bool(5 < 6).isFalsey)
        XCTAssertFalse(Value.bool(5 <= 6).isFalsey)
        
        // Nil case
        XCTAssertTrue(Value.nil.isFalsey)
    }
}
