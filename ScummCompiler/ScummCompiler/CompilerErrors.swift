//
//  CompilerErrors.swift
//  scumm
//
//  Created by Michael Borgmann on 18/07/2023.
//

import Foundation

enum CompilerError: Error {
    case unexpectedCharacter(atLine: Int, character: String)
    case unterminatedString(atLine: Int)
}

enum ParserError: Error {
    case missingClosingParenthesis(atLine: Int)
    case expressionExpected(atLine: Int)
    case invalidAssignment(atLine: Int)
    case missingClosingBraces(atLine: Int)
    case expectVariableName(atLine: Int)
    case missingSemicolon(atLine: Int)
    case missingOpeningParenthesisForIf(atLine: Int)
    case missingOpeningParenthesisForWhile(atLine: Int)
    case missingClosingParenthesisForCondition(atLine: Int)
    case missingOpeningParenthesisForForLoop(atLine: Int)
    case missingSemicolonAfterLoopCondition(atLine: Int)
    case missingClosingParenthesisAfterFor(atLine: Int)
}

enum RuntimeError: Error {
    case typeMisatch(atLine: Int)
    case undefinedVariable(atLine: Int, variable: String)
    case unexpectedError
}
