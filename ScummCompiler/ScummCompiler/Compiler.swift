//
//  Compiler.swift
//  ScummCompiler
//
//  Created by Michael Borgmann on 27/11/2023.
//

import Foundation

func compile(source: String) {
    
    var line = -1
    
    var scanner = Scanner(source: source)
    
    while true {
        
        let token = scanner.scanToken()
        
        if token.line != line {
            print(String(format: "%4d", token.line), terminator: " ")
            line = token.line
        } else {
            print("   |", terminator: " ")
        }
        
        
        let end = source.index(token.start, offsetBy: token.lenght)
        let range = token.start..<end
        
        print(token.type.rawValue, "'\(source[range])'")
        
        if token.type == .EOF {
            return
        }
    }
}
