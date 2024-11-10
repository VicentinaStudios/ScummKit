//
//  DecentParserTests.swift
//  
//
//  Created by Michael Borgmann on 07/01/2024.
//

import XCTest
@testable import ScummCompiler

class DecentParserTests: XCTestCase {

    class MockVisitor: ExpressionVisitor {

        var visitedExpressions: [ScummCompiler.Expression] = []

        func visitBinaryExpr(_ expression: Binary) throws {
            visitedExpressions.append(expression)
        }

        func visitGroupingExpr(_ expression: Grouping) throws {
            visitedExpressions.append(expression)
        }

        func visitLiteralExpr(_ expression: Literal) throws {
            visitedExpressions.append(expression)
        }

        func visitUnaryExpr(_ expression: Unary) throws {
            visitedExpressions.append(expression)
        }
    }
    
    func testParseExpression() throws {

        let source = "1 + 2 * 3"

        let scanner = Scanner(source: source)
        let tokens = try scanner.scanAllTokens()
        let parser = DecentParser(tokens: tokens)
        let abstractSyntaxTree = try parser.parse()

        let mockVisitor = MockVisitor()
        try abstractSyntaxTree.accept(visitor: mockVisitor)

        XCTAssertEqual(mockVisitor.visitedExpressions.count, 1)
        
        if
            let addition = abstractSyntaxTree as? Binary,
            let augend = addition.left as? Literal,
            let multiplication = addition.right as? Binary,
            let multiplicand = multiplication.left as? Literal,
            let multiplier = multiplication.right as? Literal
        {
            XCTAssertEqual(augend.value as? Int, 1)
            XCTAssertEqual(addition.operatorToken.type, .plus)
            XCTAssertEqual(multiplication.operatorToken.type, .star)
            XCTAssertEqual(multiplicand.value as? Int, 2)
            XCTAssertEqual(multiplier.value as? Int, 3)
            
        } else {
            XCTFail("Cannot unwrap expression")
        }
    }
    
    func testParseComplexExpression() throws {

        let source = "(-1 + 2) * 3 - -4"

        let scanner = Scanner(source: source)
        let tokens = try scanner.scanAllTokens()
        let parser = DecentParser(tokens: tokens)
        let abstractSyntaxTree = try parser.parse()

        let mockVisitor = MockVisitor()
        try abstractSyntaxTree.accept(visitor: mockVisitor)

        XCTAssertEqual(mockVisitor.visitedExpressions.count, 1)

        if
            let subtraction = abstractSyntaxTree as? Binary,
            let multiplication = subtraction.left as? Binary,
            let grouping = multiplication.left as? Grouping,
            let addition = grouping.expression as? Binary,
            let negation1 = addition.left as? Unary,
            let literal1 = negation1.right as? Literal,
            let literal2 = addition.right as? Literal,
            let multiplier = multiplication.right as? Literal,
            let negation2 = subtraction.right as? Unary,
            let literal3 = negation2.right as? Literal
        {
            XCTAssertEqual(literal1.value as? Int, 1)
            XCTAssertEqual(negation1.operatorToken.type, .minus)
            XCTAssertEqual(literal2.value as? Int, 2)
            XCTAssertEqual(addition.operatorToken.type, .plus)
            XCTAssertEqual(literal3.value as? Int, 4)
            XCTAssertEqual(negation2.operatorToken.type, .minus)
            XCTAssertEqual(multiplier.value as? Int, 3)
            XCTAssertNotNil(grouping.expression)
            XCTAssertEqual(multiplication.operatorToken.type, .star)
            XCTAssertEqual(subtraction.operatorToken.type, .minus)

        } else {
            XCTFail("Cannot unwrap expression")
        }
    }
    
    func testParseEqualEquality() throws {
        
        let source = "true"
        
        let scanner = Scanner(source: source)
        let tokens = try scanner.scanAllTokens()
        let parser = DecentParser(tokens: tokens)
        let abstractSyntaxTree = try parser.parse()
        
        let mockVisitor = MockVisitor()
        try abstractSyntaxTree.accept(visitor: mockVisitor)

        XCTAssertEqual(mockVisitor.visitedExpressions.count, 1)
        
        if let boolean = abstractSyntaxTree as? Literal {
            XCTAssertEqual(boolean.value as? Bool, true)
        } else {
            XCTFail("Not true")
        }
    }
    
    func testParseFalse() throws {
        
        let source = "false"
        
        let scanner = Scanner(source: source)
        let tokens = try scanner.scanAllTokens()
        let parser = DecentParser(tokens: tokens)
        let abstractSyntaxTree = try parser.parse()
        
        let mockVisitor = MockVisitor()
        try abstractSyntaxTree.accept(visitor: mockVisitor)

        XCTAssertEqual(mockVisitor.visitedExpressions.count, 1)
        
        if let boolean = abstractSyntaxTree as? Literal {
            XCTAssertEqual(boolean.value as? Bool, false)
        } else {
            XCTFail("Boolean not false")
        }
    }
    
    func testParseTrue() throws {
        
        let source = "true"
        
        let scanner = Scanner(source: source)
        let tokens = try scanner.scanAllTokens()
        let parser = DecentParser(tokens: tokens)
        let abstractSyntaxTree = try parser.parse()
        
        let mockVisitor = MockVisitor()
        try abstractSyntaxTree.accept(visitor: mockVisitor)

        XCTAssertEqual(mockVisitor.visitedExpressions.count, 1)
        
        if let boolean = abstractSyntaxTree as? Literal {
            XCTAssertEqual(boolean.value as? Bool, true)
        } else {
            XCTFail("Boolean not true")
        }
    }
    
    func testParseNil() throws {
        
        let source = "nil"
        
        let scanner = Scanner(source: source)
        let tokens = try scanner.scanAllTokens()
        let parser = DecentParser(tokens: tokens)
        let abstractSyntaxTree = try parser.parse()
        
        let mockVisitor = MockVisitor()
        try abstractSyntaxTree.accept(visitor: mockVisitor)

        XCTAssertEqual(mockVisitor.visitedExpressions.count, 1)
        
        if let literal = abstractSyntaxTree as? Literal {
            XCTAssertNil(literal.value)
            
        } else {
            XCTFail("Not nil")
        }
    }
    
    func testParseNotTrue() throws {
        
        let source = "!true"
        
        let scanner = Scanner(source: source)
        let tokens = try scanner.scanAllTokens()
        let parser = DecentParser(tokens: tokens)
        let abstractSyntaxTree = try parser.parse()
        
        let mockVisitor = MockVisitor()
        try abstractSyntaxTree.accept(visitor: mockVisitor)

        XCTAssertEqual(mockVisitor.visitedExpressions.count, 1)
        
        if
            let notOperator = abstractSyntaxTree as? Unary,
            let boolLiteral = notOperator.right as? Literal
        {
            XCTAssertEqual(notOperator.operatorToken.type, .bang)
            XCTAssertEqual(boolLiteral.value as? Bool, true)
        } else {
            XCTFail("Boolean not true")
        }
    }
}
