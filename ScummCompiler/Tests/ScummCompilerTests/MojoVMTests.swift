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
        var constant = chunk.addConstant(value: 2)
        try chunk.write(byte: UInt8(constant), line: 1)
        try chunk.write(byte: MojoOpcode.constant.rawValue, line: 1)
        constant = chunk.addConstant(value: 3)
        try chunk.write(byte: UInt8(constant), line: 1)
        try chunk.write(byte: MojoOpcode.add.rawValue, line: 1)
        
        XCTAssertNoThrow(try virtualMachine.interpret(chunk: chunk))
        XCTAssertEqual(virtualMachine.stackTop, 1)
        XCTAssertEqual(try virtualMachine.pop(), 5)
    }
    
    func testSubtractInstruction() throws {
        
        try chunk.write(byte: MojoOpcode.constant.rawValue, line: 1)
        var constant = chunk.addConstant(value: 5)
        try chunk.write(byte: UInt8(constant), line: 1)
        try chunk.write(byte: MojoOpcode.constant.rawValue, line: 1)
        constant = chunk.addConstant(value: 2)
        try chunk.write(byte: UInt8(constant), line: 1)
        try chunk.write(byte: MojoOpcode.subtract.rawValue, line: 1)
        
        XCTAssertNoThrow(try virtualMachine.interpret(chunk: chunk))
        XCTAssertEqual(virtualMachine.stackTop, 1)
        XCTAssertEqual(try virtualMachine.pop(), 3)
    }
    
    func testMultiplyInstruction() throws {
        
        try chunk.write(byte: MojoOpcode.constant.rawValue, line: 1)
        var constant = chunk.addConstant(value: 3)
        try chunk.write(byte: UInt8(constant), line: 1)
        try chunk.write(byte: MojoOpcode.constant.rawValue, line: 1)
        constant = chunk.addConstant(value: 4)
        try chunk.write(byte: UInt8(constant), line: 1)
        try chunk.write(byte: MojoOpcode.multiply.rawValue, line: 1)
        
        XCTAssertNoThrow(try virtualMachine.interpret(chunk: chunk))
        XCTAssertEqual(virtualMachine.stackTop, 1)
        XCTAssertEqual(try virtualMachine.pop(), 12)
    }
    
    func testDivideInstruction() throws {
        
        try chunk.write(byte: MojoOpcode.constant.rawValue, line: 1)
        var constant = chunk.addConstant(value: 10)
        try chunk.write(byte: UInt8(constant), line: 1)
        try chunk.write(byte: MojoOpcode.constant.rawValue, line: 1)
        constant = chunk.addConstant(value: 2)
        try chunk.write(byte: UInt8(constant), line: 1)
        try chunk.write(byte: MojoOpcode.divide.rawValue, line: 1)
        
        XCTAssertNoThrow(try virtualMachine.interpret(chunk: chunk))
        XCTAssertEqual(virtualMachine.stackTop, 1)
        XCTAssertEqual(try virtualMachine.pop(), 5)
    }
    
    func testNegateInstruction() throws {
        
        try chunk.write(byte: MojoOpcode.constant.rawValue, line: 1)
        let constant = chunk.addConstant(value: 8)
        try chunk.write(byte: UInt8(constant), line: 1)
        try chunk.write(byte: MojoOpcode.negate.rawValue, line: 1)
        
        XCTAssertNoThrow(try virtualMachine.interpret(chunk: chunk))
        XCTAssertEqual(virtualMachine.stackTop, 1)
        XCTAssertEqual(try virtualMachine.pop(), -8)
    }
    
    func testConstantInstruction() throws {
        
        try chunk.write(byte: MojoOpcode.constant.rawValue, line: 1)
        let constant = chunk.addConstant(value: 42)
        try chunk.write(byte: UInt8(constant), line: 1)
        
        XCTAssertNoThrow(try virtualMachine.interpret(chunk: chunk))
        XCTAssertEqual(virtualMachine.stackTop, 1)
        XCTAssertEqual(try virtualMachine.pop(), 42)
    }
}
