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
        
        var chunk: Chunk?
        
        switch Configuration.PARSER {
            
        case .pratt:
            
            print("Pratt Parser")
            let parser = PrattParser(tokens: tokens)
            chunk = try parser.parse()
            
        case .decent:
            
            print("Decent Parser")
            let parser = DecentParser(tokens: tokens)
            let expression = try parser.parse()
            
            switch Configuration.BACKEND {
                
//            case .ast:
//                let ast = ASTPrinter()
//                if let string = ast.print(expression: expression) {
//                    print("AST:", string)
//                }
//                
//            case .interpreter:
//                print("Interpreter:", terminator: " ")
//                let interpreter = Interpreter()
//                let value = try interpreter.interpret(ast: expression)
//                print(interpreter.stringify(value))
                
            case .scumm:
                print("Gernerate SCUMM")
                let codeGen = GenerateSCUMM(with: Chunk())
                chunk = try codeGen.generateByteCode(expression: expression)
                
                
            case .mojo:
                print("Gernerate Mojos")
                let codeGen = GenerateMojo(with: Chunk())
                chunk = try codeGen.generateByteCode(expression: expression)
            }
        }
        
        return chunk
    }
}
