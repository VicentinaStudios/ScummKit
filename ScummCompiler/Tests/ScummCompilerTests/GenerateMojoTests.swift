//
//  GenerateMojoTests.swift
//  
//
//  Created by Michael Borgmann on 15/01/2024.
//

import XCTest
@testable import ScummCompiler

final class GenerateMojoTests: XCTestCase {
    
    var codeGenerator: GenerateMojo?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        codeGenerator = GenerateMojo(with: Chunk())
    }
    
    override func tearDownWithError() throws {
        codeGenerator = nil
        try super.tearDownWithError()
    }
    
    func testGenerateMojo_Addition() throws {
        
        let additionExpression = Binary(
            left: Literal(value: 10),
            operatorToken: Token(type: .plus, lexeme: "+", line: 1),
            right: Literal(value: 20)
        )
        
        let chunk = try codeGenerator?.generateByteCode(expression: additionExpression)
        
        XCTAssertEqual(chunk?.code, [0xf5, 0, 0xf5, 1, 0xf0])
        XCTAssertEqual(chunk?.lines, Array(repeating: 1, count: 5))
    }
    
    func testGenerateMojo_Subtraction() throws {
        
        let subtractionExpression = Binary(
            left: Literal(value: 30),
            operatorToken: Token(type: .minus, lexeme: "-", line: 1),
            right: Literal(value: 10)
        )
        
        let chunk = try codeGenerator?.generateByteCode(expression: subtractionExpression)
        
        XCTAssertEqual(chunk?.code, [0xf5, 0, 0xf5, 1, 0xf1])
        XCTAssertEqual(chunk?.lines, Array(repeating: 1, count: 5))
    }
    
    func testGenerateMojo_Multiplication() throws {
        
        let multiplicationExpression = Binary(
            left: Literal(value: 5),
            operatorToken: Token(type: .star, lexeme: "*", line: 1),
            right: Literal(value: 4)
        )
        
        let chunk = try codeGenerator?.generateByteCode(expression: multiplicationExpression)
        
        XCTAssertEqual(chunk?.code, [0xf5, 0, 0xf5, 1, 0xf2])
        XCTAssertEqual(chunk?.lines, Array(repeating: 1, count: 5))
    }
    
    func testGenerateMojo_Division() throws {
        
        let divisionExpression = Binary(
            left: Literal(value: 25),
            operatorToken: Token(type: .slash, lexeme: "/", line: 1),
            right: Literal(value: 5)
        )
        
        let chunk = try codeGenerator?.generateByteCode(expression: divisionExpression)
        
        XCTAssertEqual(chunk?.code, [0xf5, 0, 0xf5, 1, 0xf3])
        XCTAssertEqual(chunk?.lines, Array(repeating: 1, count: 5))
    }
    
    func testGenerateMojo_UnaryNegation() throws {
        
        let negationExpression = Unary(
            operatorToken: Token(type: .minus, lexeme: "-", line: 1),
            right: Literal(value: 8)
        )
        
        let chunk = try codeGenerator?.generateByteCode(expression: negationExpression)
        
        XCTAssertEqual(chunk?.code, [0xf5, 0, 0xf6])
        XCTAssertEqual(chunk?.lines, Array(repeating: 1, count: 3))
    }
    
    func testGenerateMojo_TrueLiteral() throws {
        
        let expression = Literal(value: true, token: Token(type: .true, lexeme: "true", line: 4))
        
        codeGenerator = GenerateMojo(with: Chunk())
        let chunk = try codeGenerator?.generateByteCode(expression: expression)
        
        XCTAssertEqual(chunk?.code, [0xf9])
        XCTAssertEqual(chunk?.lines, [4])
    }
    
    func testGenerateMojo_FalseLiteral() throws {
        
        let expression = Literal(value: false, token: Token(type: .false, lexeme: "false", line: 2))
        
        codeGenerator = GenerateMojo(with: Chunk())
        let chunk = try codeGenerator?.generateByteCode(expression: expression)
        
        XCTAssertEqual(chunk?.code, [0xfa])
        XCTAssertEqual(chunk?.lines, [2])
    }
    
    func testGenerateMojo_NilLiteral() throws {
        
        let token = Token(type: .nil, lexeme: "nil", line: 2)
        let expression = Literal(value: nil, token: token)
        
        codeGenerator = GenerateMojo(with: Chunk())
        let chunk = try codeGenerator?.generateByteCode(expression: expression)
        
        XCTAssertEqual(chunk?.code, [0xf8])
        XCTAssertEqual(chunk?.lines, [2])
    }
    
    func testGenerateMojo_NotTrue() throws {
        
        let notTrue = Unary(
            operatorToken: Token(type: .bang, lexeme: "!", line: 1),
            right: Literal(value: true)
        )
        
        let chunk = try codeGenerator?.generateByteCode(expression: notTrue)
        
        XCTAssertEqual(chunk?.code, [0xf9, 0xf7])
        XCTAssertEqual(chunk?.lines, [1, 1])
    }
    
    func testGenerateMojo_Equality() throws {
        
        let equalityExpression = Binary(
            left: Literal(value: 10),
            operatorToken: Token(type: .equalEqual, lexeme: "==", line: 1),
            right: Literal(value: 10)
        )

        let chunk = try codeGenerator?.generateByteCode(expression: equalityExpression)

        XCTAssertEqual(chunk?.code, [0xf5, 0, 0xf5, 1, 0xfb])
        XCTAssertEqual(chunk?.lines, Array(repeating: 1, count: 5))
    }
    
    func testGenerateMojo_GreaterThan() throws {
        
        let greaterThanExpression = Binary(
            left: Literal(value: 10),
            operatorToken: Token(type: .greater, lexeme: ">", line: 1),
            right: Literal(value: 5)
        )

        let chunk = try codeGenerator?.generateByteCode(expression: greaterThanExpression)

        XCTAssertEqual(chunk?.code, [0xf5, 0, 0xf5, 1, 0xfc])
        XCTAssertEqual(chunk?.lines, Array(repeating: 1, count: 5))
    }
    
    func testGenerateMojo_LessThan() throws {
        let lessThanExpression = Binary(
            left: Literal(value: 5),
            operatorToken: Token(type: .less, lexeme: "<", line: 1),
            right: Literal(value: 10)
        )

        let chunk = try codeGenerator?.generateByteCode(expression: lessThanExpression)

        XCTAssertEqual(chunk?.code, [0xf5, 0, 0xf5, 1, 0xfd])
        XCTAssertEqual(chunk?.lines, Array(repeating: 1, count: 5))
    }
    
    func testGenerateMojo_Equality_Int() throws {
        let equalityExpression = Binary(
            left: Literal(value: 10),
            operatorToken: Token(type: .equalEqual, lexeme: "==", line: 1),
            right: Literal(value: 10)
        )

        let chunk = try codeGenerator?.generateByteCode(expression: equalityExpression)

        XCTAssertEqual(chunk?.code, [0xf5, 0, 0xf5, 1, 0xfb])
        XCTAssertEqual(chunk?.lines, Array(repeating: 1, count: 5))
    }

    func testGenerateMojo_Equality_Boolean() throws {
        
        let equalityExpression = Binary(
            left: Literal(value: true),
            operatorToken: Token(type: .equalEqual, lexeme: "==", line: 1),
            right: Literal(value: true)
        )

        let chunk = try codeGenerator?.generateByteCode(expression: equalityExpression)

        XCTAssertEqual(chunk?.code, [0xf9, 0xf9, 0xfb])
        XCTAssertEqual(chunk?.lines, Array(repeating: 1, count: 3))
    }

    func testGenerateMojo_Equality_BooleanFalse() throws {
        let equalityExpression = Binary(
            left: Literal(value: false),
            operatorToken: Token(type: .equalEqual, lexeme: "==", line: 1),
            right: Literal(value: false)
        )

        let chunk = try codeGenerator?.generateByteCode(expression: equalityExpression)

        XCTAssertEqual(chunk?.code, [0xfa, 0xfa, 0xfb])
        XCTAssertEqual(chunk?.lines, Array(repeating: 1, count: 3))
    }

    func testGenerateMojo_Equality_Nil() throws {
        
        let equalityExpression = Binary(
            left: Literal(value: nil),
            operatorToken: Token(type: .equalEqual, lexeme: "==", line: 1),
            right: Literal(value: nil)
        )

        let chunk = try codeGenerator?.generateByteCode(expression: equalityExpression)

        XCTAssertEqual(chunk?.code, [0xf8, 0xf8, 0xfb])
        XCTAssertEqual(chunk?.lines, Array(repeating: 1, count: 3))
    }

    func testGenerateMojo_Equality_IntAndNil() throws {
        
        let equalityExpression = Binary(
            left: Literal(value: 10),
            operatorToken: Token(type: .equalEqual, lexeme: "==", line: 1),
            right: Literal(value: nil)
        )

        let chunk = try codeGenerator?.generateByteCode(expression: equalityExpression)

        XCTAssertEqual(chunk?.code, [0xf5, 0, 0xf8, 0xfb])
        XCTAssertEqual(chunk?.lines, Array(repeating: 1, count: 4))
    }
}
