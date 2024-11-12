//
//  Test.swift
//  ScummCompiler
//
//  Created by Michael Borgmann on 12/11/2024.
//

import XCTest
@testable import ScummCompiler

class ObjectTests: XCTestCase {

    func testStringObjectTypeEquality() {
        XCTAssertEqual(ObjectType.string("hello"), .string("hello"))
        XCTAssertNotEqual(ObjectType.string("hello"), .string("world"))
    }
    
    func testObjectInitialization() {
        // Test that `Object` can initialize with a `.string` ObjectType
        let object = Object(type: .string("hello"))
        XCTAssertEqual(object.type, .string("hello"))
    }
    
    func testObjectIsString() {
        let object = Object(type: .string("hello"))
        XCTAssertTrue(object.isString)
    }
    
    #if CUSTOM_GARBAGE_COLLECTION
    func testObjectNextProperty() {
        let firstObject = Object(type: .string("hello"))
        let secondObject = Object(type: .string("world"), next: firstObject)
        
        XCTAssertEqual(secondObject.next?.type, .string("hello"))
    }
    
    func testObjectNextPropertyChain() {
        let firstObject = Object(type: .string("hello"))
        let secondObject = Object(type: .string("world"), next: firstObject)
        let thirdObject = Object(type: .string("foo"), next: secondObject)
        
        XCTAssertEqual(thirdObject.next?.type, .string("world"))
        XCTAssertEqual(thirdObject.next?.next?.type, .string("hello"))
    }
    
    func testObjectNextPropertyNil() {
        let object = Object(type: .string("hello"))
        XCTAssertNil(object.next)
    }
    #endif
}
