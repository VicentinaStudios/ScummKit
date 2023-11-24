//
//  ErrorHandler.swift
//  scumm
//
//  Created by Michael Borgmann on 18/07/2023.
//

import Foundation

struct ErrorHandler {
    
    static func handle(_ error: Error) {
        switch error {
        
        case CompilerError.unexpectedCharacter(let line, let character):
            CLI.writeMessage("Unexpected character `\(character)`", at: line, to: .compilerError)

        case CompilerError.unterminatedString(let line):
            CLI.writeMessage("Unterminated string", at: line, to: .compilerError)
            
        case ParserError.missingClosingParenthesis(let line):
            CLI.writeMessage("Missing `)`", at: line, to: .compilerError)
            
        case ParserError.expressionExpected(let line):
            CLI.writeMessage("Expression expeted", at: line, to: .compilerError)
            
        case ParserError.invalidAssignment(let line):
            CLI.writeMessage("Invalid assignment target", at: line, to: .compilerError)
            
        case ParserError.expectVariableName(let line):
            CLI.writeMessage("Expect variable name", at: line, to: .compilerError)
        
        case ParserError.missingSemicolon(let line):
            CLI.writeMessage("Expect `;` after variable delcaration", at: line, to: .compilerError)
            
        case ParserError.missingOpeningParenthesisForWhile(let line):
            CLI.writeMessage("Expect '(' after 'while'", at: line, to: .compilerError)
            
        case ParserError.missingClosingParenthesisForCondition(let line):
            CLI.writeMessage("Expect ')' after condition", at: line, to: .compilerError)
        
        case ParserError.missingOpeningParenthesisForForLoop(let line):
            CLI.writeMessage("Expect '(' after 'for'", at: line, to: .compilerError)
            
        case ParserError.missingSemicolonAfterLoopCondition(let line):
            CLI.writeMessage("Expect ';' after loop condition", at: line, to: .compilerError)
            
        case ParserError.missingClosingParenthesisAfterFor(let line):
            CLI.writeMessage("Expect ')' after for clauses", at: line, to: .compilerError)
        
        case RuntimeError.typeMisatch(let line):
            CLI.writeMessage("Type mismatch", at: line, to: .compilerError)
        
        case RuntimeError.undefinedVariable(let line, let variable):
            CLI.writeMessage("Undefined variable `\(variable)`", at: line, to: .compilerError)
            
        case RuntimeError.unexpectedError:
            CLI.writeMessage("Unexpected runtime error: \(error.localizedDescription)", to: .compilerError)
            
        default:
            CLI.writeMessage(error.localizedDescription)
        }
    }
}
