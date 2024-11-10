//
//  MojoVMTests.swift
//  
//
//  Created by Michael Borgmann on 10/01/2024.
//

import XCTest
@testable import ScummCompiler

final class MojoVMTests: XCTestCase {
    
    var chunk: Chunk!
    var virtualMachine: BaseVM<MojoOpcode>!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        virtualMachine = MojoVM()
        chunk = Chunk()
    }
    
    override func tearDownWithError() throws {
        virtualMachine = nil
        chunk = nil
        try super.tearDownWithError()
    }
    
    func testAddInstruction() throws {
        
        try chunk.write(byte: MojoOpcode.constant.rawValue, line: 1)
        var constant = chunk.addConstant(value: .int(2))
        try chunk.write(byte: UInt8(constant), line: 1)
        try chunk.write(byte: MojoOpcode.constant.rawValue, line: 1)
        constant = chunk.addConstant(value: .int(3))
        try chunk.write(byte: UInt8(constant), line: 1)
        try chunk.write(byte: MojoOpcode.add.rawValue, line: 1)
        
        XCTAssertNoThrow(try virtualMachine.interpret(chunk: chunk))
        XCTAssertEqual(virtualMachine.stackTop, 1)
        
        if case let .int(poppedValue) = try virtualMachine.pop() {
            XCTAssertEqual(poppedValue, 5)
        } else {
            XCTFail("Can't pop integer value from stack.")
            return
        }
        
        
    }
    
    func testSubtractInstruction() throws {
        
        try chunk.write(byte: MojoOpcode.constant.rawValue, line: 1)
        var constant = chunk.addConstant(value: .int(5))
        try chunk.write(byte: UInt8(constant), line: 1)
        try chunk.write(byte: MojoOpcode.constant.rawValue, line: 1)
        constant = chunk.addConstant(value: .int(2))
        try chunk.write(byte: UInt8(constant), line: 1)
        try chunk.write(byte: MojoOpcode.subtract.rawValue, line: 1)
        
        XCTAssertNoThrow(try virtualMachine.interpret(chunk: chunk))
        XCTAssertEqual(virtualMachine.stackTop, 1)
        
        if case let .int(poppedValue) = try virtualMachine.pop() {
            XCTAssertEqual(poppedValue, 3)
        } else {
            XCTFail("Can't pop integer value from stack.")
            return
        }
    }
    
    func testMultiplyInstruction() throws {
        
        try chunk.write(byte: MojoOpcode.constant.rawValue, line: 1)
        var constant = chunk.addConstant(value: .int(3))
        try chunk.write(byte: UInt8(constant), line: 1)
        try chunk.write(byte: MojoOpcode.constant.rawValue, line: 1)
        constant = chunk.addConstant(value: .int(4))
        try chunk.write(byte: UInt8(constant), line: 1)
        try chunk.write(byte: MojoOpcode.multiply.rawValue, line: 1)
        
        XCTAssertNoThrow(try virtualMachine.interpret(chunk: chunk))
        XCTAssertEqual(virtualMachine.stackTop, 1)
        
        if case let .int(poppedValue) = try virtualMachine.pop() {
            XCTAssertEqual(poppedValue, 12)
        } else {
            XCTFail("Can't pop integer value from stack.")
            return
        }
    }
    
    func testDivideInstruction() throws {
        
        try chunk.write(byte: MojoOpcode.constant.rawValue, line: 1)
        var constant = chunk.addConstant(value: .int(10))
        try chunk.write(byte: UInt8(constant), line: 1)
        try chunk.write(byte: MojoOpcode.constant.rawValue, line: 1)
        constant = chunk.addConstant(value: .int(2))
        try chunk.write(byte: UInt8(constant), line: 1)
        try chunk.write(byte: MojoOpcode.divide.rawValue, line: 1)
        
        XCTAssertNoThrow(try virtualMachine.interpret(chunk: chunk))
        XCTAssertEqual(virtualMachine.stackTop, 1)
        
        if case let .int(poppedValue) = try virtualMachine.pop() {
            XCTAssertEqual(poppedValue, 5)
        } else {
            XCTFail("Can't pop integer value from stack.")
            return
        }
    }
    
    func testNegateInstruction() throws {
        
        try chunk.write(byte: MojoOpcode.constant.rawValue, line: 1)
        let constant = chunk.addConstant(value: .int(8))
        try chunk.write(byte: UInt8(constant), line: 1)
        try chunk.write(byte: MojoOpcode.negate.rawValue, line: 1)
        
        XCTAssertNoThrow(try virtualMachine.interpret(chunk: chunk))
        XCTAssertEqual(virtualMachine.stackTop, 1)
        
        if case let .int(poppedValue) = try virtualMachine.pop() {
            XCTAssertEqual(poppedValue, -8)
        } else {
            XCTFail("Can't pop integer value from stack.")
            return
        }
    }
    
    func testConstantInstruction() throws {
        
        try chunk.write(byte: MojoOpcode.constant.rawValue, line: 1)
        let constant = chunk.addConstant(value: .int(42))
        try chunk.write(byte: UInt8(constant), line: 1)
        
        XCTAssertNoThrow(try virtualMachine.interpret(chunk: chunk))
        XCTAssertEqual(virtualMachine.stackTop, 1)
        
        if case let .int(poppedValue) = try virtualMachine.pop() {
            XCTAssertEqual(poppedValue, 42)
        } else {
            XCTFail("Can't pop integer value from stack.")
            return
        }
    }
    
    func testNotBoolInstrunction() throws {
        
        try chunk.write(byte: MojoOpcode.true.rawValue, line: 1)
        try chunk.write(byte: MojoOpcode.not.rawValue, line: 1)
        
        XCTAssertNoThrow(try virtualMachine.interpret(chunk: chunk))
        XCTAssertEqual(virtualMachine.stackTop, 1)
        
        if case let .bool(poppedVaue) = try virtualMachine.pop() {
            XCTAssertFalse(poppedVaue)
        } else {
            XCTFail("Can't pop boo value from stack.")
            return
        }
    }
}
