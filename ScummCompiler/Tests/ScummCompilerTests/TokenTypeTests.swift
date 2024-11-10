//
//  TokenTypeTests.swift
//
//
//  Created by Michael Borgmann on 16/12/2023.
//

import XCTest
@testable import ScummCompiler

final class TokenTypeTests: XCTestCase {
    
    func testExistingTokenTypes() throws {
        XCTAssertTrue(TokenType.allCases.count == 42)
    }
    
    func testLeftParenthesesTokenTypeExist() throws {
        
        XCTAssertTrue(TokenType.allCases.contains(.leftParen))
        XCTAssertTrue(TokenType.allCases.contains(.rightParen))
    }
    
    func testBraceTokenTypesExist() throws {
        
        XCTAssertTrue(TokenType.allCases.contains(.leftBrace))
        XCTAssertTrue(TokenType.allCases.contains(.rightBrace))
    }
    
    func testBracketTokenTypesExist() throws {
        
        XCTAssertTrue(TokenType.allCases.contains(.leftBracket))
        XCTAssertTrue(TokenType.allCases.contains(.rightBracket))
    }
    
    func testPunctuationTokenTypesExist() throws {
        
        XCTAssertTrue(TokenType.allCases.contains(.comma))
        XCTAssertTrue(TokenType.allCases.contains(.colon))
        XCTAssertTrue(TokenType.allCases.contains(.semicolon))
        XCTAssertTrue(TokenType.allCases.contains(.bang))
    }
    
    func testOperatorTokenTypesExist() throws {
        
        XCTAssertTrue(TokenType.allCases.contains(.plus))
        XCTAssertTrue(TokenType.allCases.contains(.minus))
        XCTAssertTrue(TokenType.allCases.contains(.slash))
        XCTAssertTrue(TokenType.allCases.contains(.star))
        XCTAssertTrue(TokenType.allCases.contains(.equal))
        XCTAssertTrue(TokenType.allCases.contains(.equalEqual))
        XCTAssertTrue(TokenType.allCases.contains(.bangEqual))
        XCTAssertTrue(TokenType.allCases.contains(.less))
        XCTAssertTrue(TokenType.allCases.contains(.lessEqual))
        XCTAssertTrue(TokenType.allCases.contains(.greater))
        XCTAssertTrue(TokenType.allCases.contains(.greaterEqual))
        XCTAssertTrue(TokenType.allCases.contains(.plusEqual))
        XCTAssertTrue(TokenType.allCases.contains(.minusEqual))
        XCTAssertTrue(TokenType.allCases.contains(.plusPlus))
        XCTAssertTrue(TokenType.allCases.contains(.minusMinus))
    }
    
    func testSpecialCharTokenTypesExist() throws {
        
        XCTAssertTrue(TokenType.allCases.contains(.hash))
        XCTAssertTrue(TokenType.allCases.contains(.backslash))
        XCTAssertTrue(TokenType.allCases.contains(.caret))
        XCTAssertTrue(TokenType.allCases.contains(.apostrophe))
        XCTAssertTrue(TokenType.allCases.contains(.backtick))
        XCTAssertTrue(TokenType.allCases.contains(.at))
    }
    
    func testLiteralTokenTypesExist() throws {
        
        XCTAssertTrue(TokenType.allCases.contains(.identifier))
        XCTAssertTrue(TokenType.allCases.contains(.string))
        XCTAssertTrue(TokenType.allCases.contains(.number))
    }
    
    func testKeywordTokenTypesExist() throws {
        
        XCTAssertTrue(TokenType.allCases.contains(.include))
        XCTAssertTrue(TokenType.allCases.contains(.if))
        XCTAssertTrue(TokenType.allCases.contains(.else))
        XCTAssertTrue(TokenType.allCases.contains(.is))
        XCTAssertTrue(TokenType.allCases.contains(.false))
        XCTAssertTrue(TokenType.allCases.contains(.true))
    }
    
    func testSpecialTokenTypesExist() throws {
        
        XCTAssertTrue(TokenType.allCases.contains(.label))
        XCTAssertTrue(TokenType.allCases.contains(.eof))
    }
}
