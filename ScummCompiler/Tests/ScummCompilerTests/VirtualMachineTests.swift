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
        
        let virtualMachine = VirtualMachine()
        let emptyChunk = Chunk()
        
        XCTAssertNoThrow(try virtualMachine.interpret(chunk: emptyChunk))
    }
    
    func testInterpretWithBreakHereOpcode() {
        
        let virtualMachine = VirtualMachine()
        let chunk = Chunk()
        
        chunk.write(byte: Opcode.breakHere.rawValue)

        XCTAssertNoThrow(try virtualMachine.interpret(chunk: chunk))
    }
    
    func testInterpretWithUnknownOpcode() {
        
        let virtualMachine = VirtualMachine()
        let chunk = Chunk()
        
        chunk.write(byte: 0xFF) // An arbitrary value that is not a valid opcode.

        XCTAssertThrowsError(try virtualMachine.interpret(chunk: chunk)) { error in
            XCTAssertEqual(error as? CompilerError, CompilerError.unknownOpcode(0xFF))
        }
    }
}
