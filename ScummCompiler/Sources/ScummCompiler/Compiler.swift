//
//  Compiler.swift
//
//
//  Created by Michael Borgmann on 21/12/2023.
//

import Foundation

public class Compiler {
    
    public init() { }
    
    public func compile(source: String) throws -> Chunk? {
        
        let scanner = Scanner(source: source)
        let tokens = try scanner.scanAllTokens()
        
//        let parser = PrattParser(tokens: tokens)
//        return parser.parse()
        
        
        let parser = DecentParser(tokens: tokens)
        let expression = try parser.parse()
        
        let ast = AbstractSyntaxTree()
        if let string = ast.print(expression: expression) {
            print(string)
        }
        
        let interpreter = Interpreter()
        try interpreter.interpret(ast: expression)
        
        let codeGen = CodeGenerator(with: Chunk())
        let chunk = try codeGen.generateByteCode(expression: expression)
        
        return chunk
    }
}
