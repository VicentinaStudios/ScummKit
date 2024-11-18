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
        
        let binaryExpression = BinaryExpression(
            left: LiteralExpression(value: 5),
            operatorToken: Token(type: .plus, lexeme: "+", line: 1),
            right: LiteralExpression(value: 3))
        let mockVisitor = MockExpressionVisitor()

        XCTAssertNoThrow(try binaryExpression.accept(visitor: mockVisitor))
        XCTAssertEqual(mockVisitor.visitedBinaryExprCount, 1)
    }

    func testGroupingExpressionVisiting() {
        
        let groupingExpression = GroupingExpession(expression: LiteralExpression(value: Token(type: .string, lexeme: "Hello", literal: "Hello", line: 1)))
        let mockVisitor = MockExpressionVisitor()

        XCTAssertNoThrow(try groupingExpression.accept(visitor: mockVisitor))
        XCTAssertEqual(mockVisitor.visitedGroupingExprCount, 1)
    }

    func testLiteralExpressionVisiting() {
        
        let literalExpression = LiteralExpression(value: 42)
        let mockVisitor = MockExpressionVisitor()

        XCTAssertNoThrow(try literalExpression.accept(visitor: mockVisitor))
        XCTAssertEqual(mockVisitor.visitedLiteralExprCount, 1)
    }

    func testUnaryExpressionVisiting() {
        
        let unaryExpression = UnaryExpression(
            operatorToken: Token(type: .minus, lexeme: "-", line: 1),
            right: LiteralExpression(value: 7))
        let mockVisitor = MockExpressionVisitor()

        XCTAssertNoThrow(try unaryExpression.accept(visitor: mockVisitor))
        XCTAssertEqual(mockVisitor.visitedUnaryExprCount, 1)
    }
}

class ExpressionTests: XCTestCase {

    func testBinaryExpressionAccept() {
        
        let binaryExpression = BinaryExpression(
            left: LiteralExpression(value: 5),
            operatorToken: Token(type: .plus, lexeme: "+", line: 1),
            right: LiteralExpression(value: 3))
        let mockVisitor = MockExpressionVisitor()

        XCTAssertNoThrow(try binaryExpression.accept(visitor: mockVisitor))
        XCTAssertEqual(mockVisitor.visitedBinaryExprCount, 1)
    }

    func testGroupingExpressionAccept() {
        
        let groupingExpression = GroupingExpession(expression: LiteralExpression(value: Token(type: .string, lexeme: "Hello", literal: "Hello", line: 1)))
        let mockVisitor = MockExpressionVisitor()

        XCTAssertNoThrow(try groupingExpression.accept(visitor: mockVisitor))
        XCTAssertEqual(mockVisitor.visitedGroupingExprCount, 1)
    }

    func testLiteralExpressionAccept() {
        
        let literalExpression = LiteralExpression(value: 42)
        let mockVisitor = MockExpressionVisitor()

        XCTAssertNoThrow(try literalExpression.accept(visitor: mockVisitor))
        XCTAssertEqual(mockVisitor.visitedLiteralExprCount, 1)
    }

    func testUnaryExpressionAccept() {
        
        let unaryExpression = UnaryExpression(
            operatorToken: Token(type: .minus, lexeme: "-", line: 1),
            right: LiteralExpression(value: 7))
        let mockVisitor = MockExpressionVisitor()

        XCTAssertNoThrow(try unaryExpression.accept(visitor: mockVisitor))
        XCTAssertEqual(mockVisitor.visitedUnaryExprCount, 1)
    }
    
    func testLiteralExpressionWithTokenVisiting() {
        
        // Test a literal with an associated token that carries line number and lexeme
        let token = Token(type: .string, lexeme: "\"Hello, World!\"", literal: "\"Hello, World!\"", line: 1)
        let literalExpression = LiteralExpression(value: "\"Hello, World!\"", token: token)
        let mockVisitor = MockExpressionVisitor()

        XCTAssertNoThrow(try literalExpression.accept(visitor: mockVisitor))
        XCTAssertEqual(mockVisitor.visitedLiteralExprCount, 1)
        
        if let token = literalExpression.token {
            XCTAssertEqual(token.lexeme, "\"Hello, World!\"")
            XCTAssertEqual(token.line, 1)
            XCTAssertEqual(literalExpression.value as? String, "\"Hello, World!\"")
        } else {
            XCTFail("Token should be present")
        }
    }
    
    func testVariableExpressionAccept() {
        
        let variableExpression = VariableExpression(
            name: Token(type: .identifier, lexeme: "x", line: 1))
        let mockVisitor = MockExpressionVisitor()

        XCTAssertNoThrow(try variableExpression.accept(visitor: mockVisitor))
        XCTAssertEqual(mockVisitor.visitedVariableExprCount, 1)
    }
    
    func testAssignExpressionAccept() {
        
        let assignExpression = AssignExpression(
            name: Token(type: .identifier, lexeme: "x", line: 1),
            value: LiteralExpression(value: 42))
        let mockVisitor = MockExpressionVisitor()

        XCTAssertNoThrow(try assignExpression.accept(visitor: mockVisitor))
        XCTAssertEqual(mockVisitor.visitedAssignExprCount, 1)
    }
}

class MockExpressionVisitor: ExpressionVisitor {
    
    var visitedBinaryExprCount = 0
    var visitedGroupingExprCount = 0
    var visitedLiteralExprCount = 0
    var visitedUnaryExprCount = 0
    var visitedVariableExprCount = 0
    var visitedAssignExprCount = 0

    func visitBinaryExpr(_ expression: BinaryExpression) throws -> Int {
        visitedBinaryExprCount += 1
        return 0
    }

    func visitGroupingExpr(_ expression: GroupingExpession) throws -> Int {
        visitedGroupingExprCount += 1
        return 0
    }

    func visitLiteralExpr(_ expression: LiteralExpression) throws -> Int {
        visitedLiteralExprCount += 1
        return 0
    }

    func visitUnaryExpr(_ expression: UnaryExpression) throws -> Int {
        visitedUnaryExprCount += 1
        return 0
    }
    
    func visitVariableExpr(_ expression: ScummCompiler.VariableExpression) throws -> Int {
        visitedVariableExprCount += 1
        return 0
    }
    
    func visitAssignExpr(_ expression: ScummCompiler.AssignExpression) throws -> Int {
        visitedAssignExprCount += 1
        return 0
    }
}
