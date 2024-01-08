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
        let binaryExpression = Binary(left: Literal(value: 5), operatorToken: Token(type: .plus, lexeme: "+", line: 1), right: Literal(value: 3))
        let astPrinter = ASTPrinter()

        XCTAssertEqual(astPrinter.print(expression: binaryExpression), "(+ 5 3)")
    }

    func testPrintGroupingExpression() {
        let groupingExpression = Grouping(expression: Literal(value: "Hello"))
        let astPrinter = ASTPrinter()

        XCTAssertEqual(astPrinter.print(expression: groupingExpression), "(group Hello)")
    }

    func testPrintLiteralExpression() {
        let literalExpression = Literal(value: 42)
        let astPrinter = ASTPrinter()

        XCTAssertEqual(astPrinter.print(expression: literalExpression), "42")
    }

    func testPrintUnaryExpression() {
        let unaryExpression = Unary(operatorToken: Token(type: .minus, lexeme: "-", line: 1), right: Literal(value: 7))
        let astPrinter = ASTPrinter()

        XCTAssertEqual(astPrinter.print(expression: unaryExpression), "(- 7)")
    }

    func testPrintNestedExpressions() {
        let nestedExpression = Binary(
            left: Literal(value: 5),
            operatorToken: Token(type: .minus, lexeme: "-", line: 1),
            right: Grouping(expression: Unary(operatorToken: Token(type: .bang, lexeme: "!", line: 1), right: Literal(value: 3)))
        )
        let astPrinter = ASTPrinter()

        XCTAssertEqual(astPrinter.print(expression: nestedExpression), "(- 5 (group (! 3)))")
    }
}

