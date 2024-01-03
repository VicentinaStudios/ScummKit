//
//  Compiler.swift
//
//
//  Created by Michael Borgmann on 21/12/2023.
//

import Foundation

class Compiler {
    
    func compile(source: String, chunk: Chunk) throws -> Bool {
        
        let scanner = Scanner(source: source)
        let tokens = try scanner.scanAllTokens()
        let parser = DecentParser(tokens: tokens)
        let expression = try parser.parse()
        
        let ast = AbstractSyntaxTree()
        let string = ast.print(expression: expression)
        print(string)
        
        return true
    }
}
