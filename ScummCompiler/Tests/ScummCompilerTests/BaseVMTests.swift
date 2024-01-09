//
//  BaseVMTests.swift
//
//
//  Created by Michael Borgmann on 17/12/2023.
//

import XCTest
@testable import ScummCompiler

final class BaseVMTests: XCTestCase {
    
    var virtualMachine: BaseVM!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        virtualMachine = BaseVM()
    }
    
    override func tearDownWithError() throws {
        virtualMachine = nil
        try super.tearDownWithError()
    }
    
    func testInterpretWithEmptyChunk() throws {
        
        let emptyChunk = Chunk()
        
        XCTAssertNoThrow(try virtualMachine.interpret(chunk: emptyChunk))
        XCTAssertEqual(virtualMachine.stackTop, 0)
        XCTAssert(virtualMachine.stack.allSatisfy { $0 == nil })
    }
    
    func testPushPopStack() throws {
        
        try virtualMachine.push(value: 42)
        
        XCTAssertEqual(try virtualMachine.pop(), 42)
    }
    
    func testBinaryOperation() throws {
        
        virtualMachine.stack = [1, 2, 3]
        virtualMachine.stackTop = 3
        
        try virtualMachine.binaryOperation(op: +)
        
        XCTAssertEqual(virtualMachine.stackTop, 2)
        XCTAssertEqual(virtualMachine.stack[0], 1)
        XCTAssertEqual(virtualMachine.stack[1], 5)
        XCTAssertNil(virtualMachine.stack[2])
    }
    
    func testReadNextByte() throws {
        
        let chunk = Chunk()
        try chunk.write(byte: 0xff, line: 1)
        try chunk.write(byte: 0x42, line: 1)
        try chunk.write(byte: 0x13, line: 1)
        
        virtualMachine.chunk = chunk
        virtualMachine.instructionPointer = chunk.codeStart

        XCTAssertEqual(try virtualMachine.readNextByte(), 0xFF)
        XCTAssertEqual(try virtualMachine.readNextByte(), 0x42)
        XCTAssertEqual(try virtualMachine.readNextByte(), 0x13)
    }
    
    func testResetStack() {
        
        virtualMachine.stack = [1, 2, 3]
        virtualMachine.stackTop = 3

        virtualMachine.resetStack()

        XCTAssertEqual(virtualMachine.stackTop, 0)
        XCTAssert(virtualMachine.stack.allSatisfy { $0 == nil })
    }
    
    func testPushPopEdgeCases() {

        XCTAssertThrowsError(try virtualMachine.pop()) { error in
            XCTAssertEqual(error as? VirtualMachineError, .emptyStack)
        }

        let fullStack = Array(repeating: 42, count: virtualMachine.stackMax)
        virtualMachine.stack = fullStack
        virtualMachine.stackTop = virtualMachine.stackMax

        XCTAssertThrowsError(try virtualMachine.push(value: 99)) { error in
            XCTAssertEqual(error as? VirtualMachineError, .fullStack)
        }
    }
    
    func testErrorCases() {
        
        let chunk = Chunk()
        virtualMachine.chunk = chunk
        let invalidPosition = 1
        virtualMachine.instructionPointer = invalidPosition

        XCTAssertThrowsError(try virtualMachine.readNextByte()) { error in
            XCTAssertEqual(error as? VirtualMachineError, .undefinedInstructionPointer)
        }
    }
    
    func testMaxCapacityStack() {
        let fullStack = Array(repeating: 42, count: virtualMachine.stackMax)
        virtualMachine.stack = fullStack
        virtualMachine.stackTop = virtualMachine.stackMax

        XCTAssertThrowsError(try virtualMachine.push(value: 99)) { error in
            XCTAssertEqual(error as? VirtualMachineError, .fullStack)
        }

        XCTAssertEqual(virtualMachine.stackTop, virtualMachine.stackMax)
        XCTAssertEqual(virtualMachine.stack, fullStack)
    }

    func testBinaryOperationErrorOnDivisionByZero() throws {
        
        let chunk = Chunk()
        let dividend = chunk.addConstant(value: 2)
        let divisor = chunk.addConstant(value: 0)
        try chunk.write(byte: Opcode.constant.rawValue, line: 1)
        try chunk.write(byte: UInt8(dividend), line: 1)
        try chunk.write(byte: Opcode.constant.rawValue, line: 1)
        try chunk.write(byte: UInt8(divisor), line: 1)
        try chunk.write(byte: Opcode.divide.rawValue, line: 1)
        virtualMachine.chunk = chunk
        virtualMachine.stack = [2, 0]
        virtualMachine.stackTop = 2

        XCTAssertThrowsError(try virtualMachine.binaryOperation(op: /)) { error in
            XCTAssertEqual(error as? VirtualMachineError, VirtualMachineError.divisionByZero(line: nil))
        }
    }

    func testBinaryOperationAddition() throws {
        
        virtualMachine.stack = [2, 3]
        virtualMachine.stackTop = 2

        try virtualMachine.binaryOperation(op: +)

        XCTAssertEqual(virtualMachine.stackTop, 1)
        XCTAssertEqual(virtualMachine.stack[0], 5)
        XCTAssertNil(virtualMachine.stack[1])
    }

    func testBinaryOperationSubtraction() throws {
        
        virtualMachine.stack = [5, 3]
        virtualMachine.stackTop = 2

        try virtualMachine.binaryOperation(op: -)

        XCTAssertEqual(virtualMachine.stackTop, 1)
        XCTAssertEqual(virtualMachine.stack[0], 2)
        XCTAssertNil(virtualMachine.stack[1])
    }

    func testBinaryOperationMultiplication() throws {
        
        virtualMachine.stack = [2, 3]
        virtualMachine.stackTop = 2

        try virtualMachine.binaryOperation(op: *)

        XCTAssertEqual(virtualMachine.stackTop, 1)
        XCTAssertEqual(virtualMachine.stack[0], 6)
        XCTAssertNil(virtualMachine.stack[1])
    }

    func testBinaryOperationDivision() throws {
        
        virtualMachine.stack = [10, 2]
        virtualMachine.stackTop = 2

        try virtualMachine.binaryOperation(op: /)

        XCTAssertEqual(virtualMachine.stackTop, 1)
        XCTAssertEqual(virtualMachine.stack[0], 5)
        XCTAssertNil(virtualMachine.stack[1])
    }

    func testBinaryOperationModulo() throws {
        
        virtualMachine.stack = [10, 3]
        virtualMachine.stackTop = 2

        try virtualMachine.binaryOperation(op: %)

        XCTAssertEqual(virtualMachine.stackTop, 1)
        XCTAssertEqual(virtualMachine.stack[0], 1)
        XCTAssertNil(virtualMachine.stack[1])
    }
}
