//
//  DecentParser.swift
//
//
//  Created by Michael Borgmann on 03/01/2024.
//

import Foundation

/// The `DecentParser` class is responsible for parsing a sequence of tokens into an abstract syntax tree (AST) representation.
///
/// It takes a stream of tokens generated by the `Scanner` and organizes them into a hierarchical structure
/// that represents the syntactic structure of the source code. The resulting abstract syntax tree can then be
/// used for further compilation and interpretation of the programming language.
///
/// # Usage
/// To use the `DecentParser`, create an instance with the tokens obtained from the `Scanner` and call
/// `parse()` to obtain the root of the abstract syntax tree.
///
/// ```swift
/// let sourceCode = "if x > 0 { print('Positive') } else { print('Non-positive') }"
/// let scanner = Scanner(source: sourceCode)
///
/// do {
///     let tokens = try scanner.scanAllTokens()
///     let parser = DecentParser(tokens: tokens)
///     let abstractSyntaxTree = try parser.parse()
///     // Use the abstract syntax tree for further compilation or interpretation
/// } catch let error as ParserError {
///     // Handle parsing errors
///     print("Parsing error: \(error.localizedDescription)")
/// }
/// ```
/// - SeeAlso:
///   - `Scanner` for tokenizing the source code into tokens before parsing.
///   - `ParserError` for potential errors during parsing.
///   - `Expression` representing the nodes of the abstract syntax tree.
///   - `Token` representing the individual tokens generated by the scanner.
///   - `TokenType` enumerates the possible types of tokens.
class DecentParser {
    
    // MARK: Properties
    
    /// The array of tokens to be parsed.
    private let tokens: [Token]
    
    /// The current index position in the `tokens` array.
    private var current: Array.Index
    
    // MARK: Computed Properties
    
    /// The current token being pointed to by the parser.
    private var peek: Token {
        tokens[current]
    }
    
    /// The previous token relative to the current position.
    private var previous: Token {
        tokens[tokens.index(before: current)]
    }
    
    /// Checks if the parser has reached the end of the token sequence.
    private var isEndOfFile: Bool {
        peek.type == .eof
    }
    
    // MARK: Lifecycle
    
    /// Initializes a new instance of the `DecentParser` with a given array of tokens.
    ///
    /// - Parameter tokens: The array of tokens to be parsed.
    init(tokens: [Token]) {
        self.tokens = tokens
        self.current = tokens.startIndex
    }
    
    // MARK: Actions
    
    /// Parses the sequence of tokens into an abstract syntax tree (AST) representation.
    ///
    /// - Returns: The root node of the AST.
    /// - Throws: A `ParserError` if parsing encounters an issue.
    func parse() throws -> Expression {
        try expression()
    }
}

// MARK: - Parser

extension DecentParser {
    
    /// Advances the parser to the next token.
    ///
    /// - Returns: The token that was previously pointed to.
    private func advance() -> Token {
        
        if !isEndOfFile {
            current = tokens.index(after: current)
        }
        
        return previous
    }
    
    /// Parses an expression.
    ///
    /// - Returns: The parsed expression.
    /// - Throws: A `ParserError` if parsing encounters an issue.
    private func expression() throws -> Expression {
        try equality()
    }
    
    /// Consumes the current token if it matches the expected type; otherwise, throws a `ParserError`.
    ///
    /// - Parameters:
    ///   - type: The expected token type.
    ///   - errorMessage: The error message to be used if the token type doesn't match.
    /// - Throws: A `ParserError` if the token type doesn't match the expected type.
    private func consume(type: TokenType, errorMessage: String) throws {
        
        guard tokens[current].type == type else {
            throw ParserError.unexpectedToken(message: errorMessage)
        }
        
        _ = advance()
    }
}

// MARK: - Parse Expressions

extension DecentParser {
    
    /// Parses binary operations with given operators and next precedence.
    ///
    /// - Parameters:
    ///   - operators: The array of token types representing operators.
    ///   - nextPrecedence: A closure representing the next precedence level.
    /// - Returns: The parsed expression.
    /// - Throws: A `ParserError` if parsing encounters an issue.
    private func binaryOperation(_ operators: [TokenType], _ nextPrecedence: () throws -> Expression) throws -> Expression {
        
        var expression = try nextPrecedence()

        while match(types: operators) {
            
            let operatorToken = previous
            let right = try nextPrecedence()
            
            expression = Binary(
                left: expression,
                operatorToken: operatorToken,
                right: right
            )
        }

        return expression
    }
    
    /// Parses the equality expression, handling `!=` and `==` operations.
    ///
    /// - Returns: The parsed expression.
    /// - Throws: A `ParserError` if parsing encounters an issue.
    private func equality() throws -> Expression {
        try binaryOperation([.bangEqual, .equalEqual], comparison)
    }
  
    /// Parses the comparison expression, handling `>`, `>=`, `<`, and `<=` operations.
    ///
    /// - Returns: The parsed expression.
    /// - Throws: A `ParserError` if parsing encounters an issue.
    private func comparison() throws -> Expression {
        try binaryOperation([.greater, .greaterEqual, .less, .lessEqual], term)
    }
    
    /// Parses the term expression, handling addition and subtraction operations.
    ///
    /// - Returns: The parsed expression.
    /// - Throws: A `ParserError` if parsing encounters an issue.
    private func term() throws -> Expression {
        try binaryOperation([.minus, .plus], factor)
    }
    
    /// Parses the factor expression, handling multiplication and division operations.
    ///
    /// - Returns: The parsed expression.
    /// - Throws: A `ParserError` if parsing encounters an issue.
    private func factor() throws -> Expression {
        try binaryOperation([.slash, .star], unary)
    }
    
    /// Parses the unary expression, handling negation and unary minus.
    ///
    /// - Returns: The parsed expression.
    /// - Throws: A `ParserError` if parsing encounters an issue.
    private func unary() throws -> Expression {
        
        if match(types: [.bang, .minus]) {
            
            let operatorToken = previous
            let right = try unary()
            
            return Unary(
                operatorToken: operatorToken,
                right: right
            )
        }
        
        return try primary()
    }
    
    /// Parses the primary expression, handling literals and grouped expressions.
    ///
    /// - Returns: The parsed expression.
    /// - Throws: A `ParserError` if parsing encounters an issue.
    private func primary() throws -> Expression {
        
        if match(types: [.false]) {
            return Literal(value: false, token: previous)
        }
        
        if match(types: [.true]) {
            return Literal(value: true, token: previous)
        }
        
        if match(types: [.number]) {
            return Literal(value: previous.literal, token: previous)
        }
        
        if match(types: [.leftParen]) {
            
            let expression = try expression()
            try consume(type: .rightParen, errorMessage: "Expect ')' after expression at line \(peek.line).")
            
            return Grouping(expression: expression)
        }
        
        throw ParserError.expressionExpected(line: peek.line)
    }
}

// MARK: - Helper

extension DecentParser {
    
    /// Attempts to match the current token's type with a set of expected types.
    ///
    /// - Parameter types: The expected token types.
    /// - Returns: `true` if a match is found; otherwise, `false`.
    private func match(types: [TokenType]) -> Bool {
        for type in types {
            if check(type: type) {
                current = tokens.index(after: current)
                return true
            }
        }
        
        return false
    }
    
    /// Checks if the current token's type matches the expected type.
    ///
    /// - Parameter type: The expected token type.
    /// - Returns: `true` if the types match; otherwise, `false`.
    private func check(type: TokenType) -> Bool {
        isEndOfFile ? false : peek.type == type
    }
}
