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
        
        let additionExpression = Binary(
            left: Literal(value: 10),
            operatorToken: Token(type: .plus, lexeme: "+", line: 1),
            right: Literal(value: 20)
        )
        
        let chunk = try codeGenerator?.generateByteCode(expression: additionExpression)
        
        XCTAssertEqual(chunk?.code, [172, 2, 64, 1, 10, 0, 1, 20, 0, 2, 255])
        XCTAssertEqual(chunk?.lines, Array(repeating: 1, count: 11))
    }
    
    func testGenerateSCUMM_Subtraction() throws {
        
        let subtractionExpression = Binary(
            left: Literal(value: 30),
            operatorToken: Token(type: .minus, lexeme: "-", line: 1),
            right: Literal(value: 10)
        )
        
        let chunk = try codeGenerator?.generateByteCode(expression: subtractionExpression)
        
        XCTAssertEqual(chunk?.code, [172, 2, 64, 1, 30, 0, 1, 10, 0, 3, 255])
        XCTAssertEqual(chunk?.lines, Array(repeating: 1, count: 11))
    }
    
    func testGenerateSCUMM_Multiplication() throws {
        
        let multiplicationExpression = Binary(
            left: Literal(value: 5),
            operatorToken: Token(type: .star, lexeme: "*", line: 1),
            right: Literal(value: 4)
        )
        
        let chunk = try codeGenerator?.generateByteCode(expression: multiplicationExpression)
        
        XCTAssertEqual(chunk?.code, [172, 2, 64, 1, 5, 0, 1, 4, 0, 4, 255])
        XCTAssertEqual(chunk?.lines, Array(repeating: 1, count: 11))
    }
    
    func testGenerateSCUMM_Division() throws {
        
        let divisionExpression = Binary(
            left: Literal(value: 25),
            operatorToken: Token(type: .slash, lexeme: "/", line: 1),
            right: Literal(value: 5)
        )
        
        let chunk = try codeGenerator?.generateByteCode(expression: divisionExpression)
        
        XCTAssertEqual(chunk?.code, [172, 2, 64, 1, 25, 0, 1, 5, 0, 5, 255])
        XCTAssertEqual(chunk?.lines, Array(repeating: 1, count: 11))
    }
    
    func testGenerateSCUMM_UnaryNegation() throws {
        
        let negationExpression = Binary(
            left: Unary(
                operatorToken: Token(type: .minus, lexeme: "-", line: 1),
                right: Literal(value: 19)),
            operatorToken: Token(type: .plus, lexeme: "+", line: 1),
            right: Literal(value: 24)
        )
        
        let chunk = try codeGenerator?.generateByteCode(expression: negationExpression)
        
        XCTAssertEqual(chunk?.code, [172, 2, 64, 1, 0xed, 0xff, 1, 0x18, 0, 2, 255])
        XCTAssertEqual(chunk?.lines, Array(repeating: 1, count: 11))
    }
}
