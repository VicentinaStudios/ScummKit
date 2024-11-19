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
        
        let mixedTypesExpr = BinaryExpression(
            left: LiteralExpression(value: 5),
            operatorToken: Token(type: .plus, lexeme: "+", line: 1),
            right: LiteralExpression(value: "\"2\""))
        
        XCTAssertThrowsError(try interpreter.interpret(ast: mixedTypesExpr)) { error in
            XCTAssertTrue(error is InterpreterError)
            XCTAssertEqual(error as? InterpreterError, InterpreterError.unsupportedOperator(type: "binary", line: 1))
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
    
    func testVariableAssignment() throws {
        
        let varStmt = VariableStatement(name: Token(type: .identifier, lexeme: "x", line: 1),
                                        initializer: LiteralExpression(value: 10))
        
        try interpreter.execute(varStmt)
        try interpreter.interpret(statements: [varStmt])
        
        let varExpr = VariableExpression(name: Token(type: .identifier, lexeme: "x", line: 1))
        let result = try interpreter.evaluate(varExpr)
        
        XCTAssertEqual(result as? Int, 10)
    }
    
    func testVariableReassignment() throws {
        let varStmt1 = VariableStatement(name: Token(type: .identifier, lexeme: "x", line: 1),
                                         initializer: LiteralExpression(value: 10))
        let varStmt2 = VariableStatement(name: Token(type: .identifier, lexeme: "x", line: 1),
                                         initializer: LiteralExpression(value: 20))
        
        try interpreter.execute(varStmt1)
        try interpreter.execute(varStmt2)
        
        let varExpr = VariableExpression(name: Token(type: .identifier, lexeme: "x", line: 1))
        let result = try interpreter.evaluate(varExpr)
        
        XCTAssertEqual(result as? Int, 20)
    }
    
    func testNilAssignment() throws {
        let varStmt = VariableStatement(name: Token(type: .identifier, lexeme: "x", line: 1),
                                         initializer: LiteralExpression(value: nil))
        
        try interpreter.execute(varStmt)
        
        let varExpr = VariableExpression(name: Token(type: .identifier, lexeme: "x", line: 1))
        let result = try interpreter.evaluate(varExpr)
        
        XCTAssertNil(result)
    }
    
    func testParenthesesPrecedence() throws {
        // (3 + 2) * 4
        let expr = BinaryExpression(
            left: GroupingExpession(expression: BinaryExpression(
                left: LiteralExpression(value: 3),
                operatorToken: Token(type: .plus, lexeme: "+", line: 1),
                right: LiteralExpression(value: 2)
            )),
            operatorToken: Token(type: .star, lexeme: "*", line: 1),
            right: LiteralExpression(value: 4)
        )
        
        let result = try interpreter.interpret(ast: expr)
        XCTAssertEqual(result as? Int, 20)  // (3 + 2) * 4 = 20
    }
    
    func testNegativeNumber() throws {
        let expr = UnaryExpression(operatorToken: Token(type: .minus, lexeme: "-", line: 1),
                                   right: LiteralExpression(value: 10))
        
        let result = try interpreter.interpret(ast: expr)
        XCTAssertEqual(result as? Int, -10)
    }
    
    func testStringConcatenation() throws {
        let expr = BinaryExpression(
            left: LiteralExpression(value: "\"Hello, \""),
            operatorToken: Token(type: .plus, lexeme: "+", line: 1),
            right: LiteralExpression(value: "\"World!\"")
        )
        
        let result = try interpreter.interpret(ast: expr)
        XCTAssertEqual(result as? String, "Hello, World!")
    }
    
    func testAssignmentOfComplexExpression() throws {
        let varStmt = VariableStatement(name: Token(type: .identifier, lexeme: "x", line: 1),
                                         initializer: BinaryExpression(
                                             left: LiteralExpression(value: 10),
                                             operatorToken: Token(type: .plus, lexeme: "+", line: 1),
                                             right: LiteralExpression(value: 5)
                                         ))
        
        try interpreter.execute(varStmt)
        
        let varExpr = VariableExpression(name: Token(type: .identifier, lexeme: "x", line: 1))
        let result = try interpreter.evaluate(varExpr)
        
        XCTAssertEqual(result as? Int, 15)
    }
    
    func testGlobalScopeVariable() throws {
        let varStmt = VariableStatement(name: Token(type: .identifier, lexeme: "x", line: 1),
                                         initializer: LiteralExpression(value: 10))
        
        try interpreter.execute(varStmt)
        
        let varExpr = VariableExpression(name: Token(type: .identifier, lexeme: "x", line: 1))
        let result = try interpreter.evaluate(varExpr)
        
        XCTAssertEqual(result as? Int, 10)
    }
    
    func testAddition() throws {
        let expr = BinaryExpression(
            left: LiteralExpression(value: 5),
            operatorToken: Token(type: .plus, lexeme: "+", line: 1),
            right: LiteralExpression(value: 3)
        )
        
        let result = try interpreter.interpret(ast: expr)
        XCTAssertEqual(result as? Int, 8)
    }
    
    func testSubtraction() throws {
        let expr = BinaryExpression(
            left: LiteralExpression(value: 10),
            operatorToken: Token(type: .minus, lexeme: "-", line: 1),
            right: LiteralExpression(value: 5)
        )
        
        let result = try interpreter.interpret(ast: expr)
        XCTAssertEqual(result as? Int, 5)
    }
    
    func testMultiplication() throws {
        let expr = BinaryExpression(
            left: LiteralExpression(value: 4),
            operatorToken: Token(type: .star, lexeme: "*", line: 1),
            right: LiteralExpression(value: 5)
        )
        
        let result = try interpreter.interpret(ast: expr)
        XCTAssertEqual(result as? Int, 20)
    }
    
    func testDivision() throws {
        let expr = BinaryExpression(
            left: LiteralExpression(value: 10),
            operatorToken: Token(type: .slash, lexeme: "/", line: 1),
            right: LiteralExpression(value: 2)
        )
        
        let result = try interpreter.interpret(ast: expr)
        XCTAssertEqual(result as? Int, 5)
    }

    func testUnaryNegation() throws {
        let expr = UnaryExpression(
            operatorToken: Token(type: .minus, lexeme: "-", line: 1),
            right: LiteralExpression(value: 5)
        )
        
        let result = try interpreter.interpret(ast: expr)
        XCTAssertEqual(result as? Int, -5)
    }
    
    func testTrueLiteral() throws {
        let expr = LiteralExpression(value: true)
        let result = try interpreter.interpret(ast: expr)
        XCTAssertEqual(result as? Bool, true)
    }
    
    func testFalseLiteral() throws {
        let expr = LiteralExpression(value: false)
        let result = try interpreter.interpret(ast: expr)
        XCTAssertEqual(result as? Bool, false)
    }
    
    func testNilLiteral() throws {
        let expr = LiteralExpression(value: nil)
        let result = try interpreter.interpret(ast: expr)
        XCTAssertNil(result)
    }
    
    func testNotTrue() throws {
        let expr = UnaryExpression(
            operatorToken: Token(type: .bang, lexeme: "!", line: 1),
            right: LiteralExpression(value: true)
        )
        
        let result = try interpreter.interpret(ast: expr)
        XCTAssertEqual(result as? Bool, false)
    }
    
    func testEqualityTrue() throws {
        let expr = BinaryExpression(
            left: LiteralExpression(value: true),
            operatorToken: Token(type: .equalEqual, lexeme: "==", line: 1),
            right: LiteralExpression(value: true)
        )
        
        let result = try interpreter.interpret(ast: expr)
        XCTAssertEqual(result as? Bool, true)
    }
    
    func testEqualityFalse() throws {
        let expr = BinaryExpression(
            left: LiteralExpression(value: false),
            operatorToken: Token(type: .equalEqual, lexeme: "==", line: 1),
            right: LiteralExpression(value: false)
        )
        
        let result = try interpreter.interpret(ast: expr)
        XCTAssertEqual(result as? Bool, true)
    }
    
    func testGreaterThan() throws {
        let expr = BinaryExpression(
            left: LiteralExpression(value: 10),
            operatorToken: Token(type: .greater, lexeme: ">", line: 1),
            right: LiteralExpression(value: 5)
        )
        
        let result = try interpreter.interpret(ast: expr)
        XCTAssertEqual(result as? Bool, true)
    }
    
    func testLessThan() throws {
        let expr = BinaryExpression(
            left: LiteralExpression(value: 3),
            operatorToken: Token(type: .less, lexeme: "<", line: 1),
            right: LiteralExpression(value: 5)
        )
        
        let result = try interpreter.interpret(ast: expr)
        XCTAssertEqual(result as? Bool, true)
    }
    
    func testEqualityInt() throws {
        let expr = BinaryExpression(
            left: LiteralExpression(value: 10),
            operatorToken: Token(type: .equalEqual, lexeme: "==", line: 1),
            right: LiteralExpression(value: 10)
        )
        
        let result = try interpreter.interpret(ast: expr)
        XCTAssertEqual(result as? Bool, true)
    }
    
    func testEqualityBoolean() throws {
        let expr = BinaryExpression(
            left: LiteralExpression(value: true),
            operatorToken: Token(type: .equalEqual, lexeme: "==", line: 1),
            right: LiteralExpression(value: true)
        )
        
        let result = try interpreter.interpret(ast: expr)
        XCTAssertEqual(result as? Bool, true)
    }
    
    func testEqualityFalseNil() throws {
        let expr = BinaryExpression(
            left: LiteralExpression(value: false),
            operatorToken: Token(type: .equalEqual, lexeme: "==", line: 1),
            right: LiteralExpression(value: nil)
        )
        
        let result = try interpreter.interpret(ast: expr)
        XCTAssertEqual(result as? Bool, false)
    }
    
    func testEqualityIntNil() throws {
        let expr = BinaryExpression(
            left: LiteralExpression(value: 5),
            operatorToken: Token(type: .equalEqual, lexeme: "==", line: 1),
            right: LiteralExpression(value: nil)
        )
        
        let result = try interpreter.interpret(ast: expr)
        XCTAssertEqual(result as? Bool, false)
    }
    
    func testEqualityString() throws {
        let expr = BinaryExpression(
            left: LiteralExpression(value: "hello"),
            operatorToken: Token(type: .equalEqual, lexeme: "==", line: 1),
            right: LiteralExpression(value: "hello")
        )
        
        let result = try interpreter.interpret(ast: expr)
        XCTAssertEqual(result as? Bool, true)
    }
    
    func testVisitVariableExpression() throws {
        let varStmt = VariableStatement(name: Token(type: .identifier, lexeme: "x", line: 1),
                                         initializer: LiteralExpression(value: 10))
        try interpreter.execute(varStmt)
        
        let varExpr = VariableExpression(name: Token(type: .identifier, lexeme: "x", line: 1))
        let result = try interpreter.evaluate(varExpr)
        
        XCTAssertEqual(result as? Int, 10)
    }
    
    func testVisitAssignmentExpression() throws {
        let varStmt = VariableStatement(name: Token(type: .identifier, lexeme: "x", line: 1),
                                         initializer: LiteralExpression(value: 10))
        try interpreter.execute(varStmt)
        
        let assignExpr = AssignExpression(
            name: Token(type: .identifier, lexeme: "x", line: 1),
            value: LiteralExpression(value: 20)
        )
        
        _ = try interpreter.evaluate(assignExpr)
        
        let varExpr = VariableExpression(name: Token(type: .identifier, lexeme: "x", line: 1))
        let result = try interpreter.evaluate(varExpr)
        
        XCTAssertEqual(result as? Int, 20)
    }
    
    func testVisitPrintStatement() throws {
        let printStmt = Print(expression: LiteralExpression(value: "\"Hello, world!\""))
        
        let output = try interpreter.visitPrintStmt(printStmt)
        
        XCTAssertEqual(output as! String, "Hello, world!")
    }
    
    func testVisitVariableStatement() throws {
        let token = Token(type: .identifier, lexeme: "x", line: 1)
        let varStmt = VariableStatement(name: token,
                                         initializer: LiteralExpression(value: 10))
        try interpreter.execute(varStmt)
        
        let printStmt = Print(expression: VariableExpression(name: token))
        let output = try interpreter.visitPrintStmt(printStmt)
        
        XCTAssertEqual(output as! String, "10")
    }
    
    func testSetVariable() throws {
        let varStmt = VariableStatement(name: Token(type: .identifier, lexeme: "x", line: 1),
                                         initializer: LiteralExpression(value: 10))
        try interpreter.execute(varStmt)
        
        let varExpr = AssignExpression(name: Token(type: .identifier, lexeme: "x", line: 1), value: LiteralExpression(value: 20))
        
        let result = try interpreter.evaluate(varExpr)
        
        XCTAssertEqual(result as? Int, 20)
    }
    
    func testGetVariable() throws {
        let varStmt = VariableStatement(name: Token(type: .identifier, lexeme: "x", line: 1),
                                         initializer: LiteralExpression(value: 10))
        try interpreter.execute(varStmt)
        
        let varExpr = VariableExpression(name: Token(type: .identifier, lexeme: "x", line: 1))
        let result = try interpreter.evaluate(varExpr)
        
        XCTAssertEqual(result as? Int, 10)
    }
}
