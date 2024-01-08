//
//  TokenTests.swift
//  
//
//  Created by Michael Borgmann on 07/01/2024.
//

import XCTest
@testable import ScummCompiler

class TokenTests: XCTestCase {
    
    func testInitialization() {
        
        let token = Token(type: .number, lexeme: "42", literal: 42, line: 10)

        XCTAssertEqual(token.type, .number)
        XCTAssertEqual(token.lexeme, "42")
        XCTAssertEqual(token.literal as? Int, 42)
        XCTAssertEqual(token.line, 10)
    }
    
    func testDifferentLiteralTypes() {
        
        let intToken = Token(type: .number, lexeme: "42", literal: 42, line: 10)
        let stringToken = Token(type: .string, lexeme: "\"hello\"", literal: "hello", line: 10)

        XCTAssertEqual(intToken.literal as? Int, 42)
        XCTAssertEqual(stringToken.literal as? String, "hello")
    }

    func testTypeSafety() {
        
        let invalidToken = Token(type: .number, lexeme: "42", literal: "invalid", line: 10)

        XCTAssertNotEqual(invalidToken.literal as? Int, 42)
    }
    
    func testAllTokenTypes() {
        
        for tokenType in TokenType.allCases {
            let token = Token(type: tokenType, lexeme: "", literal: nil, line: 1)
            XCTAssertEqual(token.type, tokenType)
        }
    }
    
    func testLexemeHandling() {
        
        let emptyLexemeToken = Token(type: .identifier, lexeme: "", literal: nil, line: 1)
        XCTAssertEqual(emptyLexemeToken.lexeme, "")

        let specialCharToken = Token(type: .at, lexeme: "@", literal: nil, line: 1)
        XCTAssertEqual(specialCharToken.lexeme, "@")
    }
    
    func testLineNumberHandling() {
        
        let token1 = Token(type: .number, lexeme: "42", literal: 42, line: 10)

        XCTAssertEqual(token1.line, 10)
    }
}
