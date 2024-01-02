//
//  Compiler.swift
//
//
//  Created by Michael Borgmann on 21/12/2023.
//

import Foundation

class Compiler {
    
    func compile(source: String, chunk: Chunk) -> Bool {
        
        let scanner = Scanner(source: source)
        
        if let tokens = try? scanner.scanAllTokens() {
            let parser = Parser(tokens: tokens)
            parser.parse()
        }
        
        
        //hardcodedCompiler(scanner)
        
        return true
    }
    
    func hardcodedCompiler(_ scanner: Scanner) {
        
        var line = -1
        
        while true {
            
            guard let token = try? scanner.scanToken() else {
                fatalError()
            }
            
            if token.line != line {
                print(token.line, terminator: " ")
                line = token.line
            } else {
                print("   | ")
            }
            
            print(token.type, token.lexeme, token.literal ?? "")
            
            if token.type == .eof {
                break
            }
        }
    }
}
