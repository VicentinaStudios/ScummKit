//
//  Token.swift
//
//
//  Created by Michael Borgmann on 21/12/2023.
//

import Foundation

struct Token {
    
    let type: TokenType
    let lexeme: String
    let literal: Any?
    let line: Int
    
    init(type: TokenType, lexeme: String, literal: Any? = nil, line: Int) {
        self.type = type
        self.lexeme = lexeme
        self.literal = literal
        self.line = line
    }
}
