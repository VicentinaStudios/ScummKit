//
//  InterpreterTests.swift
//  
//
//  Created by Michael Borgmann on 08/01/2024.
//

import XCTest
@testable import ScummCompiler

class InterpreterTests: XCTestCase {
    
    var interpreter: Interpreter!

    override func setUpWithError() throws {
        try super.setUpWithError()
        interpreter = Interpreter()
    }

    override func tearDownWithError() throws {
        interpreter = nil
        try super.tearDownWithError()
    }
    
    func testLiteralExpression() throws {
        
        let literal = LiteralExpression(value: 42)
        
        let result = try interpreter.interpret(ast: literal)
        XCTAssertEqual(result as? Int, 42)
    }
    
    func testUnaryExpression() throws {
        
        let unary = UnaryExpression(operatorToken: Token(type: .minus, lexeme: "-", line: 1), right: LiteralExpression(value: 7))
        
        let result = try interpreter.interpret(ast: unary)
        XCTAssertEqual(result as? Int, -7)
    }
    
    func testBinaryExpression() throws {
        
        let binary = BinaryExpression(left: LiteralExpression(value: 10), operatorToken: Token(type: .plus, lexeme: "+", line: 1), right: LiteralExpression(value: 5))
        
        let result = try interpreter.interpret(ast: binary)
        XCTAssertEqual(result as? Int, 15)
    }
    
    func testGroupingExpression() throws {
        
        let grouping = GroupingExpession(expression: LiteralExpression(value: 3))
        
        let result = try interpreter.interpret(ast: grouping)
        XCTAssertEqual(result as? Int, 3)
    }
    
    func testDivisionByZero() throws {
        
        let divisionByZero = BinaryExpression(left: LiteralExpression(value: 10), operatorToken: Token(type: .slash, lexeme: "/", line: 1), right: LiteralExpression(value: 0))

        XCTAssertThrowsError(try interpreter.interpret(ast: divisionByZero)) { error in
            XCTAssertTrue(error is InterpreterError)
            XCTAssertEqual(error as? InterpreterError, InterpreterError.divisionByZero(line: 1))
        }
    }
    
    func testStringRepresentation() {
        
        let interpreter = Interpreter()

        XCTAssertEqual(interpreter.stringify(42), "42")
        XCTAssertEqual(interpreter.stringify("Hello"), "Hello")
    }
    
    func testUnsupportedOperator() throws {
        
        let unsupportedOperatorExpr = BinaryExpression(left: LiteralExpression(value: 10), operatorToken: Token(type: .caret, lexeme: "^", line: 1), right: LiteralExpression(value: 2))

        XCTAssertThrowsError(try interpreter.interpret(ast: unsupportedOperatorExpr)) { error in
            XCTAssertTrue(error is InterpreterError)
            XCTAssertEqual(error as? InterpreterError, InterpreterError.unsupportedOperator(type: "binary", line: 1))
        }
    }
    
    func testMissingOperand() throws {
        
        let missingOperandExpr = UnaryExpression(operatorToken: Token(type: .minus, lexeme: "-", line: 1), right: LiteralExpression(value: nil))

        XCTAssertThrowsError(try interpreter.interpret(ast: missingOperandExpr)) { error in
            XCTAssertTrue(error is InterpreterError)
            XCTAssertEqual(error as? InterpreterError, InterpreterError.missingOperand(type: "unary", line: 1))
        }
    }
    
    func testMixedTypes() throws {
        
        let mixedTypesExpr = BinaryExpression(left: LiteralExpression(value: 5), operatorToken: Token(type: .plus, lexeme: "+", line: 1), right: LiteralExpression(value: "2"))
        
        XCTAssertThrowsError(try interpreter.interpret(ast: mixedTypesExpr)) { error in
            XCTAssertTrue(error is InterpreterError)
            XCTAssertEqual(error as? InterpreterError, InterpreterError.missingOperand(type: "binary", line: 1))
        }
    }
    
    func testComplexExpression() throws {
        
        // (-1 + 2) * 3 - -4
        let complexExpression = BinaryExpression(
            left: BinaryExpression(
                left: UnaryExpression(
                    operatorToken: Token(type: .minus, lexeme: "-", line: 1),
                    right: LiteralExpression(value: 1)
                ),
                operatorToken: Token(type: .plus, lexeme: "+", line: 1),
                right: LiteralExpression(value: 2)
            ),
            operatorToken: Token(type: .star, lexeme: "*", line: 1),
            right: BinaryExpression(
                left: LiteralExpression(value: 3),
                operatorToken: Token(type: .minus, lexeme: "-", line: 1),
                right: UnaryExpression(
                    operatorToken: Token(type: .minus, lexeme: "-", line: 1),
                    right: LiteralExpression(value: 4)
                )
            )
        )
        
        let result = try interpreter.interpret(ast: complexExpression)
        
        XCTAssertEqual(result as? Int, 7)
    }
    
    func testInterpreterPipeline() throws {
        
        let source = "(-1 + 2) * 3 - -4"
        let scanner = Scanner(source: source)
        let tokens = try scanner.scanAllTokens()
        let parser = DecentParser(tokens: tokens)
        let expression: ScummCompiler.Expression = try parser.parse()
        
        let result = try interpreter.interpret(ast: expression)
        
        XCTAssertEqual(result as? Int, 7)
    }
}
