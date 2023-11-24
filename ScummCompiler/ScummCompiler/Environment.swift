//
//  Environment.swift
//  scumm
//
//  Created by Michael Borgmann on 18/08/2023.
//

import Foundation

class Environment {
    
    private let enclosing: Environment?
    private var values: Dictionary<String, Any?> = [:]
    
    /// Initialize environment featuring nesting / scopes
    /// - Parameters;
    ///     - enclosing: Scope of environment, or global scope if `nil`.
    init(enclosing: Environment? = nil) {
        self.enclosing = enclosing
    }
    
    /// Variable definition by binding a new name to a value
    /// - Parameters:
    ///   - name: Defined variable name
    ///   - value: Assigned value
    func define(name: String, value: Any?) {
        values[name] = value
    }
    
    /// Look up value of a variable
    /// - Parameters;
    ///     - name:  Variable name to look up the value from
    func get(name: Token) throws -> Any? {
        
        guard let value = values[name.lexeme] else {
            
            if let enclosing = enclosing {
                return try enclosing.get(name: name)
            }
            
            throw RuntimeError.undefinedVariable(atLine: name.line, variable: name.lexeme)
        }
        
        return value
    }
    
    /// Assign value to variables
    /// - Parameters:
    ///   - name: Defined variable name
    ///   - value: Assigned value
    func assign(name: Token, value: Any?) throws {
        
        guard let _ = values[name.lexeme] else {
            
            if let enclosing = enclosing {
                try enclosing.assign(name: name, value: value)
                return
            }
            
            throw RuntimeError.undefinedVariable(atLine: name.line, variable: name.lexeme)
        }
        
        values[name.lexeme] = value
    }
}
