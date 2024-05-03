//
//  DecompilerTests.swift
//
//
//  Created by Michael Borgmann on 14/12/2023.
//

import XCTest
@testable import ScummCompiler

final class DecompilerTests: XCTestCase {
    
    var decompiler: Decompiler?
    var chunk: Chunk!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        chunk = Chunk()
    }

    override func tearDownWithError() throws {
        decompiler = nil
        chunk = nil
        try super.tearDownWithError()
    }
    
    func testDecompileWithEmptyChunk() throws {
        
        decompiler = ScummDecompiler()
        
        let result = try decompiler?.decompile(chunk)
        
        XCTAssertNil(result, "Decompilation should be nil for an empty chunk")
    }
    
    func testDecompileWithSingleInstruction() throws {
        
        decompiler = ScummDecompiler()
        
        try chunk.write(byte: ScummOpcode.breakHere.rawValue, line: 1)

        let result = try decompiler?.decompile(chunk)
        XCTAssertEqual(result?.count, 1, "Expected one decompiled instruction")
        XCTAssertEqual(result?.first?.opcode as? ScummOpcode, .breakHere, "Unexpected opcode")
        XCTAssertEqual(result?.first?.offset, 0, "Unexpected offset")
    }
    
    func testDecompileWithUnknownOpcode() throws {

        decompiler = ScummDecompiler()
        
        let invalidOpcode: UInt8 = 255
        try chunk.write(byte: invalidOpcode, line: 1)

        do {
            _ = try decompiler?.decompile(chunk)
            XCTFail("Expected an error for unknown opcode")
        } catch let error as CompilerError {
            XCTAssertEqual(error, CompilerError.unknownOpcode(invalidOpcode), "Unexpected error type or value")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testDecompileWithMultipleInstructions() throws {
        
        decompiler = MojoDecompiler()
        
        try chunk.write(byte: MojoOpcode.add.rawValue, line: 1)
        let constant = chunk.addConstant(value: .int(123))
        try chunk.write(byte: MojoOpcode.constant.rawValue, line: 1)
        try chunk.write(byte: UInt8(constant), line: 1)
        
        let result = try decompiler?.decompile(chunk)
        
        XCTAssertEqual(result?.count, 2, "Expected two decompiled instructions")
        XCTAssertEqual(result?[0].opcode as? MojoOpcode, .add, "Unexpected opcode for instruction 1")
        XCTAssertEqual(result?[1].opcode as? MojoOpcode, .constant, "Unexpected opcode for instruction 2")
        
        if case let .int(constantValue) = result?[1].constant?.values.first
        {
            XCTAssertEqual(constantValue, 123, "Unexpected constant value for instruction 2")
        } else {
            XCTFail("Unable to obtain value.")
            return
        }
    }
    
    func testTraceWithValidOffset() throws {
        
        decompiler = MojoDecompiler()
        
        try chunk.write(byte: MojoOpcode.multiply.rawValue, line: 1)
        
        if let result = try decompiler?.trace(chunk, offset: 0) {
            
            XCTAssertTrue(result.contains("0000"), "Expected output to contain offset information")
            XCTAssertTrue(result.contains("OP_multiply"), "Expected output to contain opcode information")
            
        } else {
            XCTFail()
        }
    }
}
