//
//  ExpressionTests.swift
//  
//
//  Created by Michael Borgmann on 07/01/2024.
//

import XCTest
@testable import ScummCompiler

import XCTest

class ExpressionVisitorTests: XCTestCase {

    func testBinaryExpressionVisiting() {
        
        let binaryExpression = Binary(left: Literal(value: 5), operatorToken: Token(type: .plus, lexeme: "+", line: 1), right: Literal(value: 3))
        let mockVisitor = MockExpressionVisitor()

        XCTAssertNoThrow(try binaryExpression.accept(visitor: mockVisitor))
        XCTAssertEqual(mockVisitor.visitedBinaryExprCount, 1)
    }

    func testGroupingExpressionVisiting() {
        
        let groupingExpression = Grouping(expression: Literal(value: "Hello"))
        let mockVisitor = MockExpressionVisitor()

        XCTAssertNoThrow(try groupingExpression.accept(visitor: mockVisitor))
        XCTAssertEqual(mockVisitor.visitedGroupingExprCount, 1)
    }

    func testLiteralExpressionVisiting() {
        
        let literalExpression = Literal(value: 42)
        let mockVisitor = MockExpressionVisitor()

        XCTAssertNoThrow(try literalExpression.accept(visitor: mockVisitor))
        XCTAssertEqual(mockVisitor.visitedLiteralExprCount, 1)
    }

    func testUnaryExpressionVisiting() {
        
        let unaryExpression = Unary(operatorToken: Token(type: .minus, lexeme: "-", line: 1), right: Literal(value: 7))
        let mockVisitor = MockExpressionVisitor()

        XCTAssertNoThrow(try unaryExpression.accept(visitor: mockVisitor))
        XCTAssertEqual(mockVisitor.visitedUnaryExprCount, 1)
    }
}

class ExpressionTests: XCTestCase {

    func testBinaryExpressionAccept() {
        
        let binaryExpression = Binary(left: Literal(value: 5), operatorToken: Token(type: .plus, lexeme: "+", line: 1), right: Literal(value: 3))
        let mockVisitor = MockExpressionVisitor()

        XCTAssertNoThrow(try binaryExpression.accept(visitor: mockVisitor))
        XCTAssertEqual(mockVisitor.visitedBinaryExprCount, 1)
    }

    func testGroupingExpressionAccept() {
        
        let groupingExpression = Grouping(expression: Literal(value: "Hello"))
        let mockVisitor = MockExpressionVisitor()

        XCTAssertNoThrow(try groupingExpression.accept(visitor: mockVisitor))
        XCTAssertEqual(mockVisitor.visitedGroupingExprCount, 1)
    }

    func testLiteralExpressionAccept() {
        
        let literalExpression = Literal(value: 42)
        let mockVisitor = MockExpressionVisitor()

        XCTAssertNoThrow(try literalExpression.accept(visitor: mockVisitor))
        XCTAssertEqual(mockVisitor.visitedLiteralExprCount, 1)
    }

    func testUnaryExpressionAccept() {
        
        let unaryExpression = Unary(operatorToken: Token(type: .minus, lexeme: "-", line: 1), right: Literal(value: 7))
        let mockVisitor = MockExpressionVisitor()

        XCTAssertNoThrow(try unaryExpression.accept(visitor: mockVisitor))
        XCTAssertEqual(mockVisitor.visitedUnaryExprCount, 1)
    }
}

class MockExpressionVisitor: ExpressionVisitor {
    
    var visitedBinaryExprCount = 0
    var visitedGroupingExprCount = 0
    var visitedLiteralExprCount = 0
    var visitedUnaryExprCount = 0

    func visitBinaryExpr(_ expression: Binary) throws -> Int {
        visitedBinaryExprCount += 1
        return 0
    }

    func visitGroupingExpr(_ expression: Grouping) throws -> Int {
        visitedGroupingExprCount += 1
        return 0
    }

    func visitLiteralExpr(_ expression: Literal) throws -> Int {
        visitedLiteralExprCount += 1
        return 0
    }

    func visitUnaryExpr(_ expression: Unary) throws -> Int {
        visitedUnaryExprCount += 1
        return 0
    }
}
