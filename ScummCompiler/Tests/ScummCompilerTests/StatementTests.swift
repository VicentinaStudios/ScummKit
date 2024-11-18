//
//  StatementTests.swift
//  ScummCompiler
//
//  Created by Michael Borgmann on 17/11/2024.
//

import XCTest
@testable import ScummCompiler

import XCTest

class StatementVisitorTests: XCTestCase {
    
    func testPrintStatementVisiting() {
        let printStatement = Print(expression: LiteralExpression(value: 42))
        let mockVisitor = MockStatementVisitor()

        XCTAssertNoThrow(try printStatement.accept(visitor: mockVisitor))
        XCTAssertEqual(mockVisitor.visitedPrintStmtCount, 1)
    }

    func testExpressionStatementVisiting() {
        let expressionStatement = ExpressionStmt(expression: LiteralExpression(value: 42))
        let mockVisitor = MockStatementVisitor()

        XCTAssertNoThrow(try expressionStatement.accept(visitor: mockVisitor))
        XCTAssertEqual(mockVisitor.visitedExpressionStmtCount, 1)
    }

    func testVariableStatementVisiting() {
        let variableStatement = VariableStatement(name: Token(type: .identifier, lexeme: "x", line: 1), initializer: LiteralExpression(value: 42))
        let mockVisitor = MockStatementVisitor()

        XCTAssertNoThrow(try variableStatement.accept(visitor: mockVisitor))
        XCTAssertEqual(mockVisitor.visitedVarStmtCount, 1)
    }
}

class StatementTests: XCTestCase {
    
    func testPrintStatementAccept() {
        let printStatement = Print(expression: LiteralExpression(value: 42))
        let mockVisitor = MockStatementVisitor()

        XCTAssertNoThrow(try printStatement.accept(visitor: mockVisitor))
        XCTAssertEqual(mockVisitor.visitedPrintStmtCount, 1)
    }

    func testExpressionStatementAccept() {
        let expressionStatement = ExpressionStmt(expression: LiteralExpression(value: 42))
        let mockVisitor = MockStatementVisitor()

        XCTAssertNoThrow(try expressionStatement.accept(visitor: mockVisitor))
        XCTAssertEqual(mockVisitor.visitedExpressionStmtCount, 1)
    }

    func testVariableStatementAccept() {
        let variableStatement = VariableStatement(name: Token(type: .identifier, lexeme: "x", line: 1), initializer: LiteralExpression(value: 42))
        let mockVisitor = MockStatementVisitor()

        XCTAssertNoThrow(try variableStatement.accept(visitor: mockVisitor))
        XCTAssertEqual(mockVisitor.visitedVarStmtCount, 1)
    }
}

class MockStatementVisitor: StatementVisitor {
    
    var visitedPrintStmtCount = 0
    var visitedExpressionStmtCount = 0
    var visitedVarStmtCount = 0

    func visitPrintStmt(_ stmt: Print) throws -> Int {
        visitedPrintStmtCount += 1
        return 0
    }

    func visitExpressionStmt(_ stmt: ExpressionStmt) throws -> Int {
        visitedExpressionStmtCount += 1
        return 0
    }

    func visitVarStmt(_ stmt: VariableStatement) throws -> Int {
        visitedVarStmtCount += 1
        return 0
    }
}
