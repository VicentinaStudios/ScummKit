//
//  ScummVMTests.swift
//  
//
//  Created by Michael Borgmann on 15/01/2024.
//

import XCTest
@testable import ScummCompiler

final class ScummVMTests: XCTestCase {
    
    var chunk: Chunk!
    var virtualMachine: BaseVM<ScummOpcode>!

    override func setUpWithError() throws {
        try super.setUpWithError()
        virtualMachine = ScummVM()
        chunk = Chunk()
    }

    override func tearDownWithError() throws {
        virtualMachine = nil
        chunk = nil
        try super.tearDownWithError()
    }
    
    func testExpressionInstruction_Addition() throws {
            
        let source = "10 + 20"
        let chunk = try createChunkFromSource(source)
        
        XCTAssertNoThrow(try virtualMachine.interpret(chunk: chunk))
        XCTAssertEqual(virtualMachine.stackTop, 1)
        
        if case let .int(poppedValue) = try virtualMachine.pop() {
            XCTAssertEqual(poppedValue, 30)
        } else {
            XCTFail("Can't pop integer value from stack.")
            return
        }
    }
    
    func testExpressionInstruction_Subtraction() throws {
        
        let source = "5 - 2"
        let chunk = try createChunkFromSource(source)
        
        XCTAssertNoThrow(try virtualMachine.interpret(chunk: chunk))
        XCTAssertEqual(virtualMachine.stackTop, 1)
        
        if case let .int(poppedValue) = try virtualMachine.pop() {
            XCTAssertEqual(poppedValue, 3)
        } else {
            XCTFail("Can't pop integer value from stack.")
            return
        }
    }
    
    func testExpressionInstruction_Multiplication() throws {
        
        let source = "3 * 4"
        let chunk = try createChunkFromSource(source)
        
        XCTAssertNoThrow(try virtualMachine.interpret(chunk: chunk))
        XCTAssertEqual(virtualMachine.stackTop, 1)
        
        if case let .int(poppedValue) = try virtualMachine.pop() {
            XCTAssertEqual(poppedValue, 12)
        } else {
            XCTFail("Can't pop integer value from stack.")
            return
        }
    }
    
    func testExpressionInstruction_Division() throws {
        
        let source = "10 / 2"
        let chunk = try createChunkFromSource(source)
        
        XCTAssertNoThrow(try virtualMachine.interpret(chunk: chunk))
        XCTAssertEqual(virtualMachine.stackTop, 1)
        
        if case let .int(poppedValue) = try virtualMachine.pop() {
            XCTAssertEqual(poppedValue, 5)
        } else {
            XCTFail("Can't pop integer value from stack.")
            return
        }
    }
    
    func testExpressionInstruction_Negation() throws {
        
        let source = "3 + -8"
        let chunk = try createChunkFromSource(source)
        
        XCTAssertNoThrow(try virtualMachine.interpret(chunk: chunk))
        XCTAssertEqual(virtualMachine.stackTop, 1)
        
        if case let .int(poppedValue) = try virtualMachine.pop() {
            XCTAssertEqual(poppedValue, -5)
        } else {
            XCTFail("Can't pop integer value from stack.")
            return
        }
    }
    
    func testComplexExpression() throws {
        
        let source = "(-1 + 2) * 3 - -4"
        let chunk = try createChunkFromSource(source)
        
        XCTAssertNoThrow(try virtualMachine.interpret(chunk: chunk))
        XCTAssertEqual(virtualMachine.stackTop, 1)
        
        if case let .int(poppedValue) = try virtualMachine.pop() {
            XCTAssertEqual(poppedValue, 7)
        } else {
            XCTFail("Can't pop integer value from stack.")
            return
        }
    }
    
    func createChunkFromSource(_ source: String) throws -> Chunk {
        
        let scanner = Scanner(source: source)
        let tokens = try scanner.scanAllTokens()
        let parser = DecentParser(tokens: tokens)
        let expression: ScummCompiler.Expression = try parser.parse()
        let statement = ExpressionStmt(expression: expression)
        let codeGenerator = GenerateSCUMM(with: Chunk())
        
        return try codeGenerator.generateByteCode(statements: [statement])
    }
}
