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
        
        chunk.write(byte: Opcode.breakHere.rawValue)

        let result = try decompiler.decompile(chunk)
        XCTAssertEqual(result?.count, 1, "Expected one decompiled instruction")
        XCTAssertEqual(result?.first?.opcode, .breakHere, "Unexpected opcode")
        XCTAssertEqual(result?.first?.offset, 0, "Unexpected offset")
    }
    
    func testDecompileWithUnknownOpcode() throws {

        let invalidOpcode: UInt8 = 255
        chunk.write(byte: invalidOpcode)

        do {
            _ = try decompiler.decompile(chunk)
            XCTFail("Expected an error for unknown opcode")
        } catch let error as CompilerError {
            XCTAssertEqual(error, CompilerError.unknownOpcode(invalidOpcode), "Unexpected error type or value")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
