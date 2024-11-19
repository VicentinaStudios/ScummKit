//
//  ASTPrinterTests.swift
//  
//
//  Created by Michael Borgmann on 07/01/2024.
//

import XCTest
@testable import ScummCompiler

class ASTPrinterTests: XCTestCase {

    func testPrintBinaryExpression() {
        let binaryExpression = BinaryExpression(left: LiteralExpression(value: 5), operatorToken: Token(type: .plus, lexeme: "+", line: 1), right: LiteralExpression(value: 3))
        let astPrinter = ASTPrinter()

        XCTAssertEqual(try astPrinter.print(expression: binaryExpression), "(+ 5 3)")
    }

    func testPrintGroupingExpression() {
        let groupingExpression = GroupingExpession(expression: LiteralExpression(value: "Hello"))
        let astPrinter = ASTPrinter()

        XCTAssertEqual(try astPrinter.print(expression: groupingExpression), "(group Hello)")
    }

    func testPrintLiteralExpression() {
        let literalExpression = LiteralExpression(value: 42)
        let astPrinter = ASTPrinter()

        XCTAssertEqual(try astPrinter.print(expression: literalExpression), "42")
    }

    func testPrintUnaryExpression() {
        let unaryExpression = UnaryExpression(operatorToken: Token(type: .minus, lexeme: "-", line: 1), right: LiteralExpression(value: 7))
        let astPrinter = ASTPrinter()

        XCTAssertEqual(try astPrinter.print(expression: unaryExpression), "(- 7)")
    }

    func testPrintNestedExpressions() {
        let nestedExpression = BinaryExpression(
            left: LiteralExpression(value: 5),
            operatorToken: Token(type: .minus, lexeme: "-", line: 1),
            right: GroupingExpession(expression: UnaryExpression(operatorToken: Token(type: .bang, lexeme: "!", line: 1), right: LiteralExpression(value: 3)))
        )
        let astPrinter = ASTPrinter()

        XCTAssertEqual(try astPrinter.print(expression: nestedExpression), "(- 5 (group (! 3)))")
    }
    
    func testPrintNilLiteralExpression() {
        let nilExpression = LiteralExpression(value: nil)
        let astPrinter = ASTPrinter()

        XCTAssertEqual(try astPrinter.print(expression: nilExpression), "nil")
    }
    
    func testPrintVariableExpression() {
        let variableExpression = VariableExpression(name: Token(type: .identifier, lexeme: "x", line: 1))
        let astPrinter = ASTPrinter()

        XCTAssertEqual(try astPrinter.print(expression: variableExpression), "x")
    }
    
    func testPrintAssignExpression() {
        let assignExpression = AssignExpression(
            name: Token(type: .identifier, lexeme: "myVar", line: 1),
            value: LiteralExpression(value: 10)
        )
        let astPrinter = ASTPrinter()

        XCTAssertEqual(try astPrinter.print(expression: assignExpression), "(= myVar 10)")
    }
    
    func testPrintVariableStatement() {
        let variableStatement = VariableStatement(
            name: Token(type: .identifier, lexeme: "x", line: 1),
            initializer: LiteralExpression(value: 42)
        )
        let astPrinter = ASTPrinter()

        XCTAssertEqual(try astPrinter.print(statement: variableStatement), "(var x = 42)")
    }

    func testPrintExpressionStatement() {
        let expressionStatement = ExpressionStmt(expression: LiteralExpression(value: "Hello"))
        let astPrinter = ASTPrinter()

        XCTAssertEqual(try astPrinter.print(statement: expressionStatement), "(; Hello)")
    }

    func testPrintPrintStatement() {
        let printStatement = Print(expression: LiteralExpression(value: "World"))
        let astPrinter = ASTPrinter()

        XCTAssertEqual(try astPrinter.print(statement: printStatement), "(print World)")
    }
}
