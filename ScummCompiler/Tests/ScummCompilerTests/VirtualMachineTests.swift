//
//  VirtualMachineTests.swift
//  
//
//  Created by Michael Borgmann on 17/12/2023.
//

import XCTest
@testable import ScummCompiler

final class VirtualMachineTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInterpretWithEmptyChunk() throws {
        
        let virtualMachine = MojoVM()
        let emptyChunk = Chunk()
        
        XCTAssertNoThrow(try virtualMachine.interpret(chunk: emptyChunk))
    }
    
    func testInterpretWithBreakHereOpcode() throws {
        
        let virtualMachine = MojoVM()
        let chunk = Chunk()
        
        try chunk.write(byte: Opcode.breakHere.rawValue, line: 1)

        XCTAssertNoThrow(try virtualMachine.interpret(chunk: chunk))
    }
    
    func testInterpretWithUnknownOpcode() throws {
        
        let virtualMachine = MojoVM()
        let chunk = Chunk()
        
        try chunk.write(byte: 0xFF, line: 1) // An arbitrary value that is not a valid opcode.

        XCTAssertThrowsError(try virtualMachine.interpret(chunk: chunk)) { error in
            XCTAssertEqual(error as? CompilerError, CompilerError.unknownOpcode(0xFF))
        }
    }
}
