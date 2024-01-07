//
//  Compiler.swift
//
//
//  Created by Michael Borgmann on 21/12/2023.
//

import Foundation

public class Compiler {
    
    public init() { }
    
    public func compile(source: String) throws -> Chunk {
        
        let scanner = Scanner(source: source)
        let tokens = try scanner.scanAllTokens()
        
        var chunk: Chunk
        
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
                
            case .scumm:
                print("Gernerate SCUMM")
                let codeGen = GenerateSCUMM(with: Chunk())
                chunk = try codeGen.generateByteCode(expression: expression)
                
                
            case .mojo:
                print("Gernerate Mojo")
                let codeGen = GenerateMojo(with: Chunk())
                chunk = try codeGen.generateByteCode(expression: expression)
            }
        }
        
        return chunk
    }
    
    public func interpret(source: String) throws {
        
        let scanner = Scanner(source: source)
        let tokens = try scanner.scanAllTokens()
        
        switch Configuration.PARSER {
            
        case .pratt:
            throw CompilerError.compileError
            
        case .decent:
            
            let parser = DecentParser(tokens: tokens)
            let expression = try parser.parse()
                
            print("Evaluate:", terminator: " ")
            let interpreter = Interpreter()
            let value = try interpreter.interpret(ast: expression)
            print(interpreter.stringify(value))
        }
    }
    
    public func ast(source: String) throws {
        
        let scanner = Scanner(source: source)
        let tokens = try scanner.scanAllTokens()
        
        switch Configuration.PARSER {
            
        case .pratt:
            throw CompilerError.compileError
            
        case .decent:
            
            let parser = DecentParser(tokens: tokens)
            let expression = try parser.parse()
                
            let ast = ASTPrinter()
            if let string = ast.print(expression: expression) {
                print("AST:", string)
            }
        }
    }
}
