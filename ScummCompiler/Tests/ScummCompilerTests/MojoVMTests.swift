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
    var mojoVM: BaseVM!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mojoVM = MojoVM()
        chunk = Chunk()
    }
    
    override func tearDownWithError() throws {
        mojoVM = nil
        chunk = nil
        try super.tearDownWithError()
    }
    
    func testBreakHereInstruction() throws {
        
        try chunk.write(byte: Opcode.breakHere.rawValue, line: 1)
        
        XCTAssertNoThrow(try mojoVM.interpret(chunk: chunk))
    }
    
    func testAddInstruction() throws {
        
        try chunk.write(byte: Opcode.constant.rawValue, line: 1)
        var constant = chunk.addConstant(value: 2)
        try chunk.write(byte: UInt8(constant), line: 1)
        try chunk.write(byte: Opcode.constant.rawValue, line: 1)
        constant = chunk.addConstant(value: 3)
        try chunk.write(byte: UInt8(constant), line: 1)
        try chunk.write(byte: Opcode.add.rawValue, line: 1)
        
        XCTAssertNoThrow(try mojoVM.interpret(chunk: chunk))
        XCTAssertEqual(mojoVM.stackTop, 1)
        XCTAssertEqual(try mojoVM.pop(), 5)
    }
    
    func testSubtractInstruction() throws {
        
        try chunk.write(byte: Opcode.constant.rawValue, line: 1)
        var constant = chunk.addConstant(value: 5)
        try chunk.write(byte: UInt8(constant), line: 1)
        try chunk.write(byte: Opcode.constant.rawValue, line: 1)
        constant = chunk.addConstant(value: 2)
        try chunk.write(byte: UInt8(constant), line: 1)
        try chunk.write(byte: Opcode.subtract.rawValue, line: 1)
        
        XCTAssertNoThrow(try mojoVM.interpret(chunk: chunk))
        XCTAssertEqual(mojoVM.stackTop, 1)
        XCTAssertEqual(try mojoVM.pop(), 3)
    }
    
    func testMultiplyInstruction() throws {
        
        try chunk.write(byte: Opcode.constant.rawValue, line: 1)
        var constant = chunk.addConstant(value: 3)
        try chunk.write(byte: UInt8(constant), line: 1)
        try chunk.write(byte: Opcode.constant.rawValue, line: 1)
        constant = chunk.addConstant(value: 4)
        try chunk.write(byte: UInt8(constant), line: 1)
        try chunk.write(byte: Opcode.multiply.rawValue, line: 1)
        
        XCTAssertNoThrow(try mojoVM.interpret(chunk: chunk))
        XCTAssertEqual(mojoVM.stackTop, 1)
        XCTAssertEqual(try mojoVM.pop(), 12)
    }
    
    func testDivideInstruction() throws {
        
        try chunk.write(byte: Opcode.constant.rawValue, line: 1)
        var constant = chunk.addConstant(value: 10)
        try chunk.write(byte: UInt8(constant), line: 1)
        try chunk.write(byte: Opcode.constant.rawValue, line: 1)
        constant = chunk.addConstant(value: 2)
        try chunk.write(byte: UInt8(constant), line: 1)
        try chunk.write(byte: Opcode.divide.rawValue, line: 1)
        
        XCTAssertNoThrow(try mojoVM.interpret(chunk: chunk))
        XCTAssertEqual(mojoVM.stackTop, 1)
        XCTAssertEqual(try mojoVM.pop(), 5)
    }
    
    func testNegateInstruction() throws {
        
        try chunk.write(byte: Opcode.constant.rawValue, line: 1)
        let constant = chunk.addConstant(value: 8)
        try chunk.write(byte: UInt8(constant), line: 1)
        try chunk.write(byte: Opcode.negate.rawValue, line: 1)
        
        XCTAssertNoThrow(try mojoVM.interpret(chunk: chunk))
        XCTAssertEqual(mojoVM.stackTop, 1)
        XCTAssertEqual(try mojoVM.pop(), -8)
    }
    
    func testConstantInstruction() throws {
        
        try chunk.write(byte: Opcode.constant.rawValue, line: 1)
        let constant = chunk.addConstant(value: 42)
        try chunk.write(byte: UInt8(constant), line: 1)
        
        XCTAssertNoThrow(try mojoVM.interpret(chunk: chunk))
        XCTAssertEqual(mojoVM.stackTop, 1)
        XCTAssertEqual(try mojoVM.pop(), 42)
    }
}
