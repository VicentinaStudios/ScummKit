//
//  File.swift
//  
//
//  Created by Michael Borgmann on 14/12/2023.
//

import Foundation

enum TokenType: String, CaseIterable {
    
    case lparen, rparen, lbrace, rbrace,lbracket, rbracket
    case comma, colon, semicolon, bang
    case plus, minus, slash, star
    case hash, backslash, caret, apostrophe, backtick, at
    
    case equal, equalEqual, bangEqual
    case less, lessEqual, greater, greaterEqual
    case plusEqual, minusEqual
    case plusPlus, minusMinus
    
    case identifier, string, number
    case label
    
    case include
    case `if`, `else`, `is`
    
    case eof
}
