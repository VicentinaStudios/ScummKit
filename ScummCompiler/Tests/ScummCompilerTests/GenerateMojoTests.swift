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
        
        let additionExpression = BinaryExpression(
            left: LiteralExpression(value: 10),
            operatorToken: Token(type: .plus, lexeme: "+", line: 1),
            right: LiteralExpression(value: 20)
        )
        let statement = ExpressionStmt(expression: additionExpression)
        
        let chunk = try codeGenerator?.generateByteCode(statements: [statement])
        
        XCTAssertEqual(chunk?.code, [0xf5, 0, 0xf5, 1, 0xf0, 0xff])
        XCTAssertEqual(chunk?.lines, Array(repeating: 1, count: 6))
    }
    
    func testGenerateMojo_Subtraction() throws {
        
        let subtractionExpression = BinaryExpression(
            left: LiteralExpression(value: 30),
            operatorToken: Token(type: .minus, lexeme: "-", line: 1),
            right: LiteralExpression(value: 10)
        )
        let statement = ExpressionStmt(expression: subtractionExpression)
        
        let chunk = try codeGenerator?.generateByteCode(statements: [statement])
        
        XCTAssertEqual(chunk?.code, [0xf5, 0, 0xf5, 1, 0xf1, 0xff])
        XCTAssertEqual(chunk?.lines, Array(repeating: 1, count: 6))
    }
    
    func testGenerateMojo_Multiplication() throws {
        
        let multiplicationExpression = BinaryExpression(
            left: LiteralExpression(value: 5),
            operatorToken: Token(type: .star, lexeme: "*", line: 1),
            right: LiteralExpression(value: 4)
        )
        let statement = ExpressionStmt(expression: multiplicationExpression)
        
        let chunk = try codeGenerator?.generateByteCode(statements: [statement])
        
        XCTAssertEqual(chunk?.code, [0xf5, 0, 0xf5, 1, 0xf2, 0xff])
        XCTAssertEqual(chunk?.lines, Array(repeating: 1, count: 6))
    }
    
    func testGenerateMojo_Division() throws {
        
        let divisionExpression = BinaryExpression(
            left: LiteralExpression(value: 25),
            operatorToken: Token(type: .slash, lexeme: "/", line: 1),
            right: LiteralExpression(value: 5)
        )
        let statement = ExpressionStmt(expression: divisionExpression)
        
        let chunk = try codeGenerator?.generateByteCode(statements: [statement])
        
        XCTAssertEqual(chunk?.code, [0xf5, 0, 0xf5, 1, 0xf3, 0xff])
        XCTAssertEqual(chunk?.lines, Array(repeating: 1, count: 6))
    }
    
    func testGenerateMojo_UnaryNegation() throws {
        
        let negationExpression = UnaryExpression(
            operatorToken: Token(type: .minus, lexeme: "-", line: 1),
            right: LiteralExpression(value: 8)
        )
        let statement = ExpressionStmt(expression: negationExpression)
        
        let chunk = try codeGenerator?.generateByteCode(statements: [statement])

        
        XCTAssertEqual(chunk?.code, [0xf5, 0, 0xf6, 0xff])
        XCTAssertEqual(chunk?.lines, Array(repeating: 1, count: 4))
    }
    
    func testGenerateMojo_TrueLiteral() throws {
        
        let expression = LiteralExpression(value: true, token: Token(type: .true, lexeme: "true", line: 4))
        let statement = ExpressionStmt(expression: expression)
        
        codeGenerator = GenerateMojo(with: Chunk())
        let chunk = try codeGenerator?.generateByteCode(statements: [statement])
        
        XCTAssertEqual(chunk?.code, [0xf9, 0xff])
        XCTAssertEqual(chunk?.lines, [4, 4])
    }
    
    func testGenerateMojo_FalseLiteral() throws {
        
        let expression = LiteralExpression(value: false, token: Token(type: .false, lexeme: "false", line: 2))
        let statement = ExpressionStmt(expression: expression)
        
        codeGenerator = GenerateMojo(with: Chunk())
        let chunk = try codeGenerator?.generateByteCode(statements: [statement])
        
        XCTAssertEqual(chunk?.code, [0xfa, 0xff])
        XCTAssertEqual(chunk?.lines, [2, 2])
    }
    
    func testGenerateMojo_NilLiteral() throws {
        
        let token = Token(type: .nil, lexeme: "nil", line: 2)
        let expression = LiteralExpression(value: nil, token: token)
        let statement = ExpressionStmt(expression: expression)
        
        codeGenerator = GenerateMojo(with: Chunk())
        let chunk = try codeGenerator?.generateByteCode(statements: [statement])
        
        XCTAssertEqual(chunk?.code, [0xf8, 0xff])
        XCTAssertEqual(chunk?.lines, [2, 2])
    }
    
    func testGenerateMojo_NotTrue() throws {
        
        let notTrue = UnaryExpression(
            operatorToken: Token(type: .bang, lexeme: "!", line: 1),
            right: LiteralExpression(value: true)
        )
        let statement = ExpressionStmt(expression: notTrue)
        
        let chunk = try codeGenerator?.generateByteCode(statements: [statement])
        
        XCTAssertEqual(chunk?.code, [0xf9, 0xf7, 0xff])
        XCTAssertEqual(chunk?.lines, [1, 1, 1])
    }
    
    func testGenerateMojo_Equality() throws {
        
        let equalityExpression = BinaryExpression(
            left: LiteralExpression(value: 10),
            operatorToken: Token(type: .equalEqual, lexeme: "==", line: 1),
            right: LiteralExpression(value: 10)
        )
        let statement = ExpressionStmt(expression: equalityExpression)

        let chunk = try codeGenerator?.generateByteCode(statements: [statement])

        XCTAssertEqual(chunk?.code, [0xf5, 0, 0xf5, 1, 0xfb, 0xff])
        XCTAssertEqual(chunk?.lines, Array(repeating: 1, count: 6))
    }
    
    func testGenerateMojo_GreaterThan() throws {
        
        let greaterThanExpression = BinaryExpression(
            left: LiteralExpression(value: 10),
            operatorToken: Token(type: .greater, lexeme: ">", line: 1),
            right: LiteralExpression(value: 5)
        )
        let statement = ExpressionStmt(expression: greaterThanExpression)

        let chunk = try codeGenerator?.generateByteCode(statements: [statement])

        XCTAssertEqual(chunk?.code, [0xf5, 0, 0xf5, 1, 0xfc, 0xff])
        XCTAssertEqual(chunk?.lines, Array(repeating: 1, count: 6))
    }
    
    func testGenerateMojo_LessThan() throws {
        
        let lessThanExpression = BinaryExpression(
            left: LiteralExpression(value: 5),
            operatorToken: Token(type: .less, lexeme: "<", line: 1),
            right: LiteralExpression(value: 10)
        )
        let statement = ExpressionStmt(expression: lessThanExpression)

        let chunk = try codeGenerator?.generateByteCode(statements: [statement])

        XCTAssertEqual(chunk?.code, [0xf5, 0, 0xf5, 1, 0xfd, 0xff])
        XCTAssertEqual(chunk?.lines, Array(repeating: 1, count: 6))
    }
    
    func testGenerateMojo_Equality_Int() throws {
        
        let equalityExpression = BinaryExpression(
            left: LiteralExpression(value: 10),
            operatorToken: Token(type: .equalEqual, lexeme: "==", line: 1),
            right: LiteralExpression(value: 10)
        )
        let statement = ExpressionStmt(expression: equalityExpression)

        let chunk = try codeGenerator?.generateByteCode(statements: [statement])

        XCTAssertEqual(chunk?.code, [0xf5, 0, 0xf5, 1, 0xfb, 0xff])
        XCTAssertEqual(chunk?.lines, Array(repeating: 1, count: 6))
    }

    func testGenerateMojo_Equality_Boolean() throws {
        
        let equalityExpression = BinaryExpression(
            left: LiteralExpression(value: true),
            operatorToken: Token(type: .equalEqual, lexeme: "==", line: 1),
            right: LiteralExpression(value: true)
        )
        let statement = ExpressionStmt(expression: equalityExpression)

        let chunk = try codeGenerator?.generateByteCode(statements: [statement])

        XCTAssertEqual(chunk?.code, [0xf9, 0xf9, 0xfb, 0xff])
        XCTAssertEqual(chunk?.lines, Array(repeating: 1, count: 4))
    }

    func testGenerateMojo_Equality_BooleanFalse() throws {
        
        let equalityExpression = BinaryExpression(
            left: LiteralExpression(value: false),
            operatorToken: Token(type: .equalEqual, lexeme: "==", line: 1),
            right: LiteralExpression(value: false)
        )
        let statement = ExpressionStmt(expression: equalityExpression)

        let chunk = try codeGenerator?.generateByteCode(statements: [statement])

        XCTAssertEqual(chunk?.code, [0xfa, 0xfa, 0xfb, 0xff])
        XCTAssertEqual(chunk?.lines, Array(repeating: 1, count: 4))
    }

    func testGenerateMojo_Equality_Nil() throws {
        
        let equalityExpression = BinaryExpression(
            left: LiteralExpression(value: nil),
            operatorToken: Token(type: .equalEqual, lexeme: "==", line: 1),
            right: LiteralExpression(value: nil)
        )
        let statement = ExpressionStmt(expression: equalityExpression)

        let chunk = try codeGenerator?.generateByteCode(statements: [statement])

        XCTAssertEqual(chunk?.code, [0xf8, 0xf8, 0xfb, 0xff])
        XCTAssertEqual(chunk?.lines, Array(repeating: 1, count: 4))
    }

    func testGenerateMojo_Equality_IntAndNil() throws {
        
        let equalityExpression = BinaryExpression(
            left: LiteralExpression(value: 10),
            operatorToken: Token(type: .equalEqual, lexeme: "==", line: 1),
            right: LiteralExpression(value: nil)
        )
        let statement = ExpressionStmt(expression: equalityExpression)

        let chunk = try codeGenerator?.generateByteCode(statements: [statement])

        XCTAssertEqual(chunk?.code, [0xf5, 0, 0xf8, 0xfb, 0xff])
        XCTAssertEqual(chunk?.lines, Array(repeating: 1, count: 5))
    }
    
    func testGenerateMojo_StringLiteral() throws {
        
        let stringExpression = LiteralExpression(value: "Hello, World!", token: Token(type: .string, lexeme: "\"Hello, World!\"", line: 1))
        let statement = ExpressionStmt(expression: stringExpression)
        
        codeGenerator = GenerateMojo(with: Chunk())
        let chunk = try codeGenerator?.generateByteCode(statements: [statement])
        
        XCTAssertEqual(chunk?.code, [0xf5, 0, 0xff])
        XCTAssertEqual(chunk?.lines, [1, 1, 1])
    }
    
    func testGenerateMojo_ConcatenateStringLiterals() throws {
        
        let concatenationExpression = BinaryExpression(
            left: LiteralExpression(value: "Hello", token: Token(type: .string, lexeme: "\"Hello\"", line: 5)),
            operatorToken: Token(type: .plus, lexeme: "+", line: 5),
            right: LiteralExpression(value: " World!", token: Token(type: .string, lexeme: "\" World!\"", line: 5))
        )
        let statement = ExpressionStmt(expression: concatenationExpression)
        
        codeGenerator = GenerateMojo(with: Chunk())
        let chunk = try codeGenerator?.generateByteCode(statements: [statement])
        
        XCTAssertEqual(chunk?.code, [0xf5, 0, 0xf5, 1, 0xf0, 0xff])
        XCTAssertEqual(chunk?.lines, [5, 5, 5, 5, 5, 5])
    }
    
    func testGenerateMojo_Equality_String() throws {
        
        let equalityExpression = BinaryExpression(
            left: LiteralExpression(value: "Hello", token: Token(type: .string, lexeme: "\"Hello\"", line: 2)),
            operatorToken: Token(type: .equalEqual, lexeme: "==", line: 1),
            right: LiteralExpression(value: " World!", token: Token(type: .string, lexeme: "\" World!\"", line: 2))
        )
        let statement = ExpressionStmt(expression: equalityExpression)

        let chunk = try codeGenerator?.generateByteCode(statements: [statement])

        XCTAssertEqual(chunk?.code, [0xf5, 0, 0xf5, 1, 0xfb, 0xff])
        XCTAssertEqual(chunk?.lines, Array(repeating: 2, count: 6))
    }
        
    func testGenerateMojo_VisitVariableExpr() throws {
        
        let token = Token(type: .identifier, lexeme: "myVar", line: 1)
        let variableExpression = VariableExpression(name: token)
        let statement = ExpressionStmt(expression: variableExpression)

        codeGenerator = GenerateMojo(with: Chunk())
        let chunk = try codeGenerator?.generateByteCode(statements: [statement])
        
        XCTAssertEqual(chunk?.code, [MojoOpcode.get.rawValue, 0, MojoOpcode.pop.rawValue])
        XCTAssertEqual(chunk?.lines, [1, 1, 1])
    }
    
    func testGenerateMojo_VisitAssignExpr() throws {
        
        let assignExpression = AssignExpression(
            name: Token(type: .identifier, lexeme: "myVar", line: 1),
            value: LiteralExpression(value: 10)
        )
        let statement = ExpressionStmt(expression: assignExpression)

        codeGenerator = GenerateMojo(with: Chunk())
        let chunk = try codeGenerator?.generateByteCode(statements: [statement])
        
        XCTAssertEqual(chunk?.code, [MojoOpcode.constant.rawValue, 0, MojoOpcode.set.rawValue, 1, MojoOpcode.pop.rawValue])
        XCTAssertEqual(chunk?.lines, [1, 1, 1, 1, 1])
    }
    
    func testGenerateMojo_VisitPrintStmt() throws {
        
        let token = Token(type: .string, lexeme: "Hello, World!", line: 1)
        let printExpression = LiteralExpression(value: "Hello, World!", token: token)
        let printStmt = Print(expression: printExpression)
        
        codeGenerator = GenerateMojo(with: Chunk())
        let chunk = try codeGenerator?.generateByteCode(statements: [printStmt])
        
        XCTAssertEqual(chunk?.code, [MojoOpcode.constant.rawValue, 0, MojoOpcode.print.rawValue])
        XCTAssertEqual(chunk?.lines, [1, 1, 1])
    }
    
    func testGenerateMojo_VisitVarStmt() throws {
        
        let token = Token(type: .identifier, lexeme: "myVar", line: 1)
        let initializer = LiteralExpression(value: 42)
        let varStmt = VariableStatement(name: token, initializer: initializer)
        
        codeGenerator = GenerateMojo(with: Chunk())
        let chunk = try codeGenerator?.generateByteCode(statements: [varStmt])
        
        XCTAssertEqual(chunk?.code, [
            MojoOpcode.constant.rawValue, 1, MojoOpcode.global.rawValue, 0
        ])
        XCTAssertEqual(chunk?.lines, [1, 1, 1, 1])
    }
    
    func testGenerateMojo_SetVariable() throws {
        
        let define = Token(type: .identifier, lexeme: "myVar", line: 1)
        let initializer = LiteralExpression(value: 42, token: define)
        let varStmt = VariableStatement(name: define, initializer: initializer)
        let assign = Token(type: .identifier, lexeme: "myVar", line: 2)
        let assignStmt = ExpressionStmt(expression: AssignExpression(name: assign, value: LiteralExpression(value: 23, token: assign)))
        
        codeGenerator = GenerateMojo(with: Chunk())
        let chunk = try codeGenerator?.generateByteCode(statements: [varStmt, assignStmt])
        
        XCTAssertEqual(chunk?.code, [
            MojoOpcode.constant.rawValue, 1, MojoOpcode.global.rawValue, 0,
            MojoOpcode.constant.rawValue, 2, MojoOpcode.set.rawValue, 3, MojoOpcode.pop.rawValue
        ])
        XCTAssertEqual(chunk?.lines, [1, 1, 1, 1, 2, 2, 2, 2, 2])
    }
    
    func testGenerateMojo_GetVariable() throws {
        
        let define = Token(type: .identifier, lexeme: "myVar", line: 1)
        let initializer = LiteralExpression(value: 42, token: define)
        let varStmt = VariableStatement(name: define, initializer: initializer)
        let variable = Token(type: .identifier, lexeme: "myVar", line: 2)
        let printStmt = Print(expression: VariableExpression(name: variable))
        
        codeGenerator = GenerateMojo(with: Chunk())
        let chunk = try codeGenerator?.generateByteCode(statements: [varStmt, printStmt])
        
        XCTAssertEqual(chunk?.code, [
            MojoOpcode.constant.rawValue, 1, MojoOpcode.global.rawValue, 0,
            MojoOpcode.get.rawValue, 2, MojoOpcode.print.rawValue
        ])
        XCTAssertEqual(chunk?.lines, [1, 1, 1, 1, 2, 2, 2])
    }

}
