//
//  EnvironmentTests.swift
//  ScummCompiler
//
//  Created by Michael Borgmann on 19/11/2024.
//

import XCTest
@testable import ScummCompiler

class EnvironmentTests: XCTestCase {
    
    var environment: Environment!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        environment = Environment()
    }

    override func tearDownWithError() throws {
        environment = nil
        try super.tearDownWithError()
    }
    
    func testDefineVariable() throws {
        let env = Environment()
        
        env.define(name: "x", value: 10)
        
        let result = try env.get(name: Token(type: .identifier, lexeme: "x", line: 1))
        XCTAssertEqual(result as? Int, 10)
    }
    
    func testDefineMultipleVariables() throws {
        let env = Environment()
        
        env.define(name: "x", value: 10)
        env.define(name: "y", value: 20)
        
        let resultX = try env.get(name: Token(type: .identifier, lexeme: "x", line: 1))
        XCTAssertEqual(resultX as? Int, 10)
        
        let resultY = try env.get(name: Token(type: .identifier, lexeme: "y", line: 1))
        XCTAssertEqual(resultY as? Int, 20)
    }
    
    func testGetUndefinedVariable() throws {
        let env = Environment()
        
        XCTAssertThrowsError(try env.get(name: Token(type: .identifier, lexeme: "x", line: 1))) { error in
            XCTAssertTrue(error is RuntimeError)
            XCTAssertEqual(error as? RuntimeError, RuntimeError.undefinedVariable(name: "x"))
        }
    }
    
    func testAssignToExistingVariable() throws {
        let env = Environment()
        env.define(name: "x", value: 10)
        
        try env.assign(name: Token(type: .identifier, lexeme: "x", line: 1), value: 20)
        
        let result = try env.get(name: Token(type: .identifier, lexeme: "x", line: 1))
        XCTAssertEqual(result as? Int, 20)
    }
    
    func testAssignToUndefinedVariable() throws {
        let env = Environment()
        
        XCTAssertThrowsError(try env.assign(name: Token(type: .identifier, lexeme: "x", line: 1), value: 20)) { error in
            XCTAssertTrue(error is RuntimeError)
            XCTAssertEqual(error as? RuntimeError, RuntimeError.undefinedVariable(name: "x"))
        }
    }
    
    func testNestedEnvironment() throws {
        let parentEnv = Environment()
        parentEnv.define(name: "x", value: 10)
        
        let childEnv = Environment(enclosing: parentEnv)
        
        let result = try childEnv.get(name: Token(type: .identifier, lexeme: "x", line: 1))
        XCTAssertEqual(result as? Int, 10)
    }
    
    func testOverrideVariableInNestedEnvironment() throws {
        let parentEnv = Environment()
        parentEnv.define(name: "x", value: 10)
        
        let childEnv = Environment(enclosing: parentEnv)
        childEnv.define(name: "x", value: 20)
        
        let result = try childEnv.get(name: Token(type: .identifier, lexeme: "x", line: 1))
        XCTAssertEqual(result as? Int, 20)
    }
    
    func testAccessParentEnvironmentAfterOverride() throws {
        let parentEnv = Environment()
        parentEnv.define(name: "x", value: 10)
        
        let childEnv = Environment(enclosing: parentEnv)
        childEnv.define(name: "x", value: 20)
        
        let resultParent = try parentEnv.get(name: Token(type: .identifier, lexeme: "x", line: 1))
        XCTAssertEqual(resultParent as? Int, 10)
    }
    
    func testNestedEnvironmentAssignment() throws {
        let parentEnv = Environment()
        parentEnv.define(name: "x", value: 10)
        
        let childEnv = Environment(enclosing: parentEnv)
        
        try childEnv.assign(name: Token(type: .identifier, lexeme: "x", line: 1), value: 20)
        
        let result = try parentEnv.get(name: Token(type: .identifier, lexeme: "x", line: 1))
        XCTAssertEqual(result as? Int, 20)
    }
    
    func testParentAssignmentPropagation() throws {
        let parentEnv = Environment()
        parentEnv.define(name: "x", value: 10)
        
        let childEnv = Environment(enclosing: parentEnv)
        
        try parentEnv.assign(name: Token(type: .identifier, lexeme: "x", line: 1), value: 30)
        
        let result = try childEnv.get(name: Token(type: .identifier, lexeme: "x", line: 1))
        XCTAssertEqual(result as? Int, 30)
    }
    
    func testUndefinedVariableInNestedEnvironment() throws {
        let parentEnv = Environment()
        
        let childEnv = Environment(enclosing: parentEnv)
        
        XCTAssertThrowsError(try childEnv.get(name: Token(type: .identifier, lexeme: "x", line: 1))) { error in
            XCTAssertTrue(error is RuntimeError)
            XCTAssertEqual(error as? RuntimeError, RuntimeError.undefinedVariable(name: "x"))
        }
    }
}
