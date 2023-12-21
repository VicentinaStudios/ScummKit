//
//  ScannerTests.swift
//  
//
//  Created by Michael Borgmann on 21/12/2023.
//

import XCTest
@testable import ScummCompiler

final class ScannerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSingleCharacterLexemes() throws {
        
        let source = "( ) { } [ ] , : ; + - / * # \\ ^ ' ` @"
        let scanner = Scanner(source: source)
        
        let expectedTokens: [TokenType] = [
            .lparen, .rparen, .lbrace, .rbrace, .lbracket, .rbracket,
            .comma, .colon, .semicolon, .plus, .minus, .slash, .star,
            .hash, .backslash, .caret, .apostrophe, .backtick, .at, .eof
        ]
        
        for expectedToken in expectedTokens {
            let token = try scanner.scanToken()
            XCTAssertEqual(token.type, expectedToken)
        }
    }
    
    func testDoubleCharacterLexemes() throws {
        
        let source = "= == < <= > >="
        let scanner = Scanner(source: source)
        
        let expectedTokens: [TokenType] = [
            .equal, .equalEqual, .less, .lessEqual, .greater, .greaterEqual, .eof
        ]
        
        for expectedToken in expectedTokens {
            let token = try scanner.scanToken()
            XCTAssertEqual(token.type, expectedToken)
        }
    }
    
    func testStringLiteral() throws {
        
        let source = "\"Hello, World!\""
        let scanner = Scanner(source: source)
        
        let token = try scanner.scanToken()
        XCTAssertEqual(token.type, .string)
        XCTAssertEqual(token.literal as? String, "\"Hello, World!\"")
    }
    
    func testNumberLiteral() throws {
        
        let source = "123"
        let scanner = Scanner(source: source)
        
        let token = try scanner.scanToken()
        XCTAssertEqual(token.type, .number)
        XCTAssertEqual(token.literal as? Int, 123)
    }
    
    func testIdentifier() throws {
        let source = "variable_123"
        let scanner = Scanner(source: source)
        
        let token = try scanner.scanToken()
        XCTAssertEqual(token.type, .identifier)
    }
}

