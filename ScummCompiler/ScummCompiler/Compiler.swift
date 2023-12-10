//
//  Compiler.swift
//  ScummCompiler
//
//  Created by Michael Borgmann on 27/11/2023.
//

import Foundation

struct Parser {
    
    var current: Token? = nil
    var previous: Token? = nil
    
    var hadError: Bool = false
    var panicMode: Bool = false
}

enum Precedence: Int, CaseIterable {
    case none
    case assignment
    case or
    case and
    case equality
    case comparison
    case term
    case factor
    case unary
    case call
    case primary
}

struct ParseRule {
    
    typealias ParseFn = () -> Void
    
    var prefix: ParseFn?
    var infix: ParseFn?
    var precedence: Precedence
}

class Compiler {
    
    var scanner: Scanner
    var parser = Parser()
    var compilingChunk: Chunk? = nil
    
    init(source: String) {
        
        scanner = Scanner(source: source)
    }
    
    func compile(source: String, chunk: Chunk) -> Bool {
        
        compilingChunk = chunk
        
        parser.hadError = false
        parser.panicMode = false
        
        advance()
        expression()
        consume(token: .EOF, message: "Expect end of expression.");
        
        endCompiler()
        
        return !parser.hadError
    }
    
    func advance() {
        
        parser.previous = parser.current
        
        while true {
            
            parser.current = scanner.scanToken()
            
            if parser.current?.type != TokenType.ERROR {
                break
            }
            
            errorAtCurrent(message: "\(parser.current!.start)")
        }
    }
    
    func error(message: String) {
        errorAt(token: parser.previous!, message: message)
    }
    
    func errorAtCurrent(message: String) {
        
        //print("[line \(token.line)]")
        parser.panicMode = true
        print(parser.current, message)
    }
    
    func errorAt(token: Token, message: String) {
        
        if parser.panicMode {
            return
        }
        
        parser.panicMode = true
        
        CLI.writeMessage("\(message)", at: token.line, to: .error)
        
        parser.hadError = true
    }
    
    func consume(token: TokenType, message: String) {
        
        if parser.current?.type == token {
            advance()
            return
        }
        
        errorAtCurrent(message: message)
    }
    
    func emitByte(byte: UInt8) {
        compilingChunk?.write(byte: byte, line: parser.previous!.line)
    }
    
    func endCompiler() {
        
        emitReturn()
        
        if DEBUG_PRINT_CODE {
            if !parser.hadError {
                disassembleChunk(chunk: compilingChunk!, name: "code")
            }
        }
    }
    
    func emitReturn() {
        emitByte(byte: Opcode.return.rawValue)
    }
    
    func emitBytes(byte1: UInt8, byte2: UInt8) {
        emitByte(byte: byte1)
        emitByte(byte: byte2)
    }
    
    func grouping() {
        expression()
        consume(token: .RIGHT_PAREN, message: "Expect ')' after expression.")
    }
    
    func number() {
        print("number")
        let startIndex = parser.previous!.start
        let length = parser.previous!.lenght
        let range = startIndex..<scanner.source.index(startIndex, offsetBy: length)
        
        let value = Double(scanner.source[range])
        
        emitConstant(value: value!)
    }
    
    func emitConstant(value: Value) {
        emitBytes(byte1: Opcode.constant.rawValue, byte2: makeConstant(value: value))
    }
    
    func makeConstant(value: Value) -> UInt8 {
        
        let constant = compilingChunk!.addConstant(value: value)
        
        if constant > UInt8.max {
            CLI.writeMessage("Too many constants in one chunk.", to: .error)
            return 0
        }
        
        return UInt8(constant)
    }
    
    func unary() {
        
        let operatorType: TokenType = parser.previous!.type
        
        parsePrecedence(.unary)
        
        switch operatorType {
        case .MINUS:
            emitByte(byte: Opcode.negate.rawValue)
        default:
            return
        }
    }
    
    lazy var rules: [String: ParseRule] = {
        
        var rules: [String: ParseRule] = [:]
        
        rules[TokenType.LEFT_PAREN.rawValue] = ParseRule(prefix: grouping, precedence: .none)
        rules[TokenType.RIGHT_PAREN.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.LEFT_BRACE.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.RIGHT_BRACE.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.COMMA.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.DOT.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.MINUS.rawValue] = ParseRule(prefix: unary, infix: binary, precedence: .term)
        rules[TokenType.PLUS.rawValue] = ParseRule(infix: binary, precedence: .term)
        rules[TokenType.SEMICOLON.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.SLASH.rawValue] = ParseRule(infix: binary, precedence: .factor)
        rules[TokenType.STAR.rawValue] = ParseRule(infix: binary, precedence: .factor)
        rules[TokenType.BANG.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.BANG_EQUAL.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.EQUAL.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.EQUAL_EQUAL.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.GREATER.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.GREATER_EQUAL.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.LESS.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.LESS_EQUAL.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.IDENTIFIER.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.STRING.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.NUMBER.rawValue] = ParseRule(prefix: number, precedence: .none)
        rules[TokenType.AND.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.CLASS.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.ELSE.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.FALSE.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.FOR.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.FUNC.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.IF.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.NIL.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.OR.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.PRINT.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.RETURN.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.SUPER.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.THIS.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.TRUE.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.VAR.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.WHILE.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.ERROR.rawValue] = ParseRule(precedence: .none)
        rules[TokenType.EOF.rawValue] = ParseRule(precedence: .none)

        return rules
    }()
    
    func binary() {
        
        let operatorType: TokenType = parser.previous!.type
        let rule = getRule(type: operatorType)
        
        let nextPrecedence = Precedence(rawValue: rule!.precedence.rawValue + 1)
        parsePrecedence(nextPrecedence!)
        
        switch operatorType {
        case .PLUS:
            emitByte(byte: Opcode.add.rawValue)
        case .MINUS:
            emitByte(byte: Opcode.subtract.rawValue)
        case .STAR:
            emitByte(byte: Opcode.multiply.rawValue)
        case .SLASH:
            emitByte(byte: Opcode.divide.rawValue)
        default:
            return
        }
    }
    
    func expression() {
        parsePrecedence(.assignment)
    }
    
    func parsePrecedence(_ precedence: Precedence) {
        
        advance()
        
        let prefixRule = getRule(type: parser.previous!.type)!.prefix
        
        if prefixRule == nil {
            error(message: "Expect expression")
            return
        }
        
        prefixRule?()
        
        while precedence.rawValue <= getRule(type: parser.current!.type)!.precedence.rawValue {
            
            advance()
            
            let infixRule = getRule(type: parser.previous!.type)!.infix
            
            infixRule?()
        }
    }
    
    func getRule(type: TokenType) -> ParseRule? {
        rules[type.rawValue]
    }
}

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
