//
//  BaseVMTests.swift
//
//
//  Created by Michael Borgmann on 17/12/2023.
//

import XCTest
@testable import ScummCompiler

final class BaseVMTests: XCTestCase {
    
    var virtualMachine: BaseVM<MojoOpcode>!
    
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
        
        try virtualMachine.push(value: .int(42))
        
        if case let .int(poppedValue) = try virtualMachine.pop() {
            XCTAssertEqual(poppedValue, 42)
        } else {
            XCTFail("Failed to pop an integer value.")
            return
        }
    }
    
    func testBinaryOperation() throws {
        
        virtualMachine.stack = [.int(1), .int(2), .int(3)]
        virtualMachine.stackTop = 3
        
        try virtualMachine.binaryOperation(valueType: Value.int, op: +)
        
        XCTAssertEqual(virtualMachine.stackTop, 2)
        
        if
            case let .int(poppedValue1) = virtualMachine.stack[0],
            case let .int(poppedValue2) = virtualMachine.stack[1]
        {
            XCTAssertEqual(poppedValue1, 1)
            XCTAssertEqual(poppedValue2, 5)
        }
        else {
            XCTFail("Failed to pop an integer value.")
            return
        }
        
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
        
        virtualMachine.stack = [.int(1), .int(2), .int(3)]
        virtualMachine.stackTop = 3

        virtualMachine.resetStack()

        XCTAssertEqual(virtualMachine.stackTop, 0)
        XCTAssert(virtualMachine.stack.allSatisfy { $0 == nil })
    }
    
    func testPushPopEdgeCases() {

        XCTAssertThrowsError(try virtualMachine.pop()) { error in
            XCTAssertEqual(error as? VirtualMachineError, .emptyStack)
        }

        let fullStack = Array(repeating: Value.int(42), count: virtualMachine.stackMax)
        virtualMachine.stack = fullStack
        virtualMachine.stackTop = virtualMachine.stackMax

        XCTAssertThrowsError(try virtualMachine.push(value: .int(99))) { error in
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
        
        let fullStack = Array(repeating: Value.int(42), count: virtualMachine.stackMax)
        virtualMachine.stack = fullStack
        virtualMachine.stackTop = virtualMachine.stackMax

        XCTAssertThrowsError(try virtualMachine.push(value: .int(99))) { error in
            XCTAssertEqual(error as? VirtualMachineError, .fullStack)
        }

        XCTAssertEqual(virtualMachine.stackTop, virtualMachine.stackMax)
        XCTAssertEqual(virtualMachine.stack, fullStack)
    }

    func testBinaryOperationErrorOnDivisionByZero() throws {
        
        let chunk = Chunk()
        let dividend = chunk.addConstant(value: .int(2))
        let divisor = chunk.addConstant(value: .int(0))
        try chunk.write(byte: MojoOpcode.constant.rawValue, line: 1)
        try chunk.write(byte: UInt8(dividend), line: 1)
        try chunk.write(byte: MojoOpcode.constant.rawValue, line: 1)
        try chunk.write(byte: UInt8(divisor), line: 1)
        try chunk.write(byte: MojoOpcode.divide.rawValue, line: 1)
        virtualMachine.chunk = chunk
        virtualMachine.stack = [.int(2), .int(0)]
        virtualMachine.stackTop = 2

        XCTAssertThrowsError(try virtualMachine.binaryOperation(valueType: Value.int, op: /)) { error in
            XCTAssertEqual(error as? VirtualMachineError, VirtualMachineError.divisionByZero(line: nil))
        }
    }

    func testBinaryOperationAddition() throws {
        
        virtualMachine.stack = [.int(2), .int(3)]
        virtualMachine.stackTop = 2

        try virtualMachine.binaryOperation(valueType: Value.int, op: +)

        XCTAssertEqual(virtualMachine.stackTop, 1)
        
        if case let .int(stackValue) = virtualMachine.stack[0] {
            XCTAssertEqual(stackValue, 5)
        } else {
            XCTFail("Can't pop integer value from stack.")
            return
        }
        
        XCTAssertNil(virtualMachine.stack[1])
    }

    func testBinaryOperationSubtraction() throws {
        
        virtualMachine.stack = [.int(5), .int(3)]
        virtualMachine.stackTop = 2

        try virtualMachine.binaryOperation(valueType: Value.int, op: -)

        XCTAssertEqual(virtualMachine.stackTop, 1)
        
        if case let .int(stackValue) = virtualMachine.stack[0] {
            XCTAssertEqual(stackValue, 2)
        } else {
            XCTFail("Can't pop integer value from stack.")
            return
        }
        
        XCTAssertNil(virtualMachine.stack[1])
    }

    func testBinaryOperationMultiplication() throws {
        
        virtualMachine.stack = [.int(2), .int(3)]
        virtualMachine.stackTop = 2

        try virtualMachine.binaryOperation(valueType: Value.int, op: *)

        XCTAssertEqual(virtualMachine.stackTop, 1)
        
        if case let .int(stackValue) = virtualMachine.stack[0] {
            XCTAssertEqual(stackValue, 6)
        } else {
            XCTFail("Can't pop integer value from stack.")
            return
        }
        
        XCTAssertNil(virtualMachine.stack[1])
    }

    func testBinaryOperationDivision() throws {
        
        virtualMachine.stack = [.int(10), .int(2)]
        virtualMachine.stackTop = 2

        try virtualMachine.binaryOperation(valueType: Value.int, op: /)

        XCTAssertEqual(virtualMachine.stackTop, 1)
        
        if case let .int(stackValue) = virtualMachine.stack[0] {
            XCTAssertEqual(stackValue, 5)
        } else {
            XCTFail("Can't pop integer value from stack.")
            return
        }
        
        XCTAssertNil(virtualMachine.stack[1])
    }

    func testBinaryOperationModulo() throws {
        
        virtualMachine.stack = [.int(10), .int(3)]
        virtualMachine.stackTop = 2

        try virtualMachine.binaryOperation(valueType: Value.int, op: %)

        XCTAssertEqual(virtualMachine.stackTop, 1)
        
        if case let .int(stackValue) = virtualMachine.stack[0] {
            XCTAssertEqual(stackValue, 1)
        } else {
            XCTFail("Can't pop integer value from stack.")
            return
        }
        
        XCTAssertNil(virtualMachine.stack[1])
    }
}
