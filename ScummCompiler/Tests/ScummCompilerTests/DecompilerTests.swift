//
//  DebugTests.swift
//
//
//  Created by Michael Borgmann on 14/12/2023.
//

import XCTest
@testable import ScummCompiler

final class DecompilerTests: XCTestCase {
    
    var decompiler: Decompiler!
    var chunk: Chunk!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        chunk = Chunk()
        decompiler = Decompiler()
    }

    override func tearDownWithError() throws {
        decompiler = nil
        chunk = nil
        try super.tearDownWithError()
    }
    
    func testDecompileWithEmptyChunk() throws {
        
        let result = try decompiler.decompile(chunk)
        XCTAssertNil(result, "Decompilation should be nil for an empty chunk")
    }
    
    func testDecompileWithSingleInstruction() throws {
        
        try chunk.write(byte: Opcode.breakHere.rawValue, line: 1)

        let result = try decompiler.decompile(chunk)
        XCTAssertEqual(result?.count, 1, "Expected one decompiled instruction")
        XCTAssertEqual(result?.first?.opcode, .breakHere, "Unexpected opcode")
        XCTAssertEqual(result?.first?.offset, 0, "Unexpected offset")
    }
    
    func testDecompileWithUnknownOpcode() throws {

        let invalidOpcode: UInt8 = 255
        try chunk.write(byte: invalidOpcode, line: 1)

        do {
            _ = try decompiler.decompile(chunk)
            XCTFail("Expected an error for unknown opcode")
        } catch let error as CompilerError {
            XCTAssertEqual(error, CompilerError.unknownOpcode(invalidOpcode), "Unexpected error type or value")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testDecompileWithMultipleInstructions() throws {
        
        try chunk.write(byte: Opcode.add.rawValue, line: 1)
        let constant = chunk.addConstant(value: 123)
        try chunk.write(byte: Opcode.constant.rawValue, line: 1)
        try chunk.write(byte: UInt8(constant), line: 1)
        
        let result = try decompiler.decompile(chunk)
        
        XCTAssertEqual(result?.count, 2, "Expected two decompiled instructions")
        XCTAssertEqual(result?[0].opcode, .add, "Unexpected opcode for instruction 1")
        XCTAssertEqual(result?[1].opcode, .constant, "Unexpected opcode for instruction 2")
        XCTAssertEqual(result?[1].constant?.values.first, 123, "Unexpected constant value for instruction 2")
    }
    
    func testTraceWithValidOffset() throws {
        
        try chunk.write(byte: Opcode.multiply.rawValue, line: 1)
        
        let result = try decompiler.trace(chunk, offset: 0)
        
        XCTAssertTrue(result.contains("0000"), "Expected output to contain offset information")
        XCTAssertTrue(result.contains("OP_multiply"), "Expected output to contain opcode information")
    }
}
