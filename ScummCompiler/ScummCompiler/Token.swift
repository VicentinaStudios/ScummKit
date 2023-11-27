//
//  Token.swift
//  ScummCompiler
//
//  Created by Michael Borgmann on 27/11/2023.
//

import Foundation

struct Token {
    
    let type: TokenType
    let start: String.Index
    let lenght: Int
    let line: Int
}
