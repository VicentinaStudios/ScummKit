//
//  GenerateScummTests.swift
//  
//
//  Created by Michael Borgmann on 15/01/2024.
//

import XCTest
@testable import ScummCompiler

final class GenerateScummTests: XCTestCase {
    
    var codeGenerator: GenerateSCUMM?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        codeGenerator = GenerateSCUMM(with: Chunk())
    }
    
    override func tearDownWithError() throws {
        codeGenerator = nil
        try super.tearDownWithError()
    }
    
    func testGenerateSCUMM_Addition() throws {
        
        let additionExpression = BinaryExpression(
            left: LiteralExpression(value: 10),
            operatorToken: Token(type: .plus, lexeme: "+", line: 1),
            right: LiteralExpression(value: 20)
        )
        let statement = ExpressionStmt(expression: additionExpression)
        
        let chunk = try codeGenerator?.generateByteCode(statements: [statement])
        
        XCTAssertEqual(chunk?.code, [ScummOpcode.expression.rawValue, 2, 64, 1, 10, 0, 1, 20, 0, 2, 255])
        XCTAssertEqual(chunk?.lines, Array(repeating: 1, count: 11))
    }
    
    func testGenerateSCUMM_Subtraction() throws {
        
        let subtractionExpression = BinaryExpression(
            left: LiteralExpression(value: 30),
            operatorToken: Token(type: .minus, lexeme: "-", line: 1),
            right: LiteralExpression(value: 10)
        )
        let statement = ExpressionStmt(expression: subtractionExpression)
        
        let chunk = try codeGenerator?.generateByteCode(statements: [statement])
        
        XCTAssertEqual(chunk?.code, [ScummOpcode.expression.rawValue, 2, 64, 1, 30, 0, 1, 10, 0, 3, 255])
        XCTAssertEqual(chunk?.lines, Array(repeating: 1, count: 11))
    }
    
    func testGenerateSCUMM_Multiplication() throws {
        
        let multiplicationExpression = BinaryExpression(
            left: LiteralExpression(value: 5),
            operatorToken: Token(type: .star, lexeme: "*", line: 1),
            right: LiteralExpression(value: 4)
        )
        let statement = ExpressionStmt(expression: multiplicationExpression)
        
        let chunk = try codeGenerator?.generateByteCode(statements: [statement])
        
        XCTAssertEqual(chunk?.code, [ScummOpcode.expression.rawValue, 2, 64, 1, 5, 0, 1, 4, 0, 4, 255])
        XCTAssertEqual(chunk?.lines, Array(repeating: 1, count: 11))
    }
    
    func testGenerateSCUMM_Division() throws {
        
        let divisionExpression = BinaryExpression(
            left: LiteralExpression(value: 25),
            operatorToken: Token(type: .slash, lexeme: "/", line: 1),
            right: LiteralExpression(value: 5)
        )
        let statement = ExpressionStmt(expression: divisionExpression)
        
        let chunk = try codeGenerator?.generateByteCode(statements: [statement])
        
        XCTAssertEqual(chunk?.code, [ScummOpcode.expression.rawValue, 2, 64, 1, 25, 0, 1, 5, 0, 5, 255])
        XCTAssertEqual(chunk?.lines, Array(repeating: 1, count: 11))
    }
    
    func testGenerateSCUMM_UnaryNegation() throws {
        
        let negationExpression = BinaryExpression(
            left: UnaryExpression(
                operatorToken: Token(type: .minus, lexeme: "-", line: 1),
                right: LiteralExpression(value: 19)),
            operatorToken: Token(type: .plus, lexeme: "+", line: 1),
            right: LiteralExpression(value: 24)
        )
        let statement = ExpressionStmt(expression: negationExpression)
        
        let chunk = try codeGenerator?.generateByteCode(statements: [statement])
        
        XCTAssertEqual(chunk?.code, [ScummOpcode.expression.rawValue, 2, 64, 1, 0xed, 0xff, 1, 0x18, 0, 2, 255])
        XCTAssertEqual(chunk?.lines, Array(repeating: 1, count: 11))
    }
    
    func testGenerateComplexExpression() throws {
        
        let source = "(-1 + 2) * 3 - -4"
        let chunk = try createChunkFromSource(source)
        
        XCTAssertEqual(chunk.code, [ScummOpcode.expression.rawValue, 2, 64, 1, 255, 255, 1, 2, 0, 2, 1, 3, 0, 4, 1, 252, 255, 3, 255])
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
