//
//  Environment.swift
//  ScummCompiler
//
//  Created by Michael Borgmann on 18/11/2024.
//

import Foundation

/// A class representing the execution environment for variable storage and scoping.
///
/// The `Environment` class provides mechanisms for storing variable bindings and their values
/// within a specific scope. It supports nested environments, enabling the resolution of variables
/// across local and global scopes. When a variable is not found in the current scope, the lookup
/// continues in the enclosing scope, if available.
///
/// - Note: This class is essential for managing the state and scope of variables during the
/// interpretation or execution of code.
///
/// - SeeAlso: `Interpreter`, `Token`, `RuntimeError`
class Environment {
    
    /// The enclosing environment, representing the parent scope.
    private let enclosing: Environment?
    
    /// A dictionary storing variable names and their associated values in the current scope.
    private var values: Dictionary<String, Any?> = [:]
    
    /// Creates a new `Environment` instance, optionally nested within an enclosing environment.
    ///
    /// - Parameters:
    ///   - enclosing: The parent environment for nested scoping, or `nil` for a global scope.
    init(enclosing: Environment? = nil) {
        self.enclosing = enclosing
    }
    
    /// Defines a new variable by binding a name to a value in the current scope.
    ///
    /// - Parameters:
    ///   - name: The name of the variable to define.
    ///   - value: The value to associate with the variable.
    func define(name: String, value: Any?) {
        values[name] = value
    }
    
    /// Retrieves the value of a variable by its name, searching nested scopes if necessary.
    ///
    /// - Parameters:
    ///   - name: A `Token` representing the name of the variable to look up.
    /// - Returns: The value associated with the variable, or `nil` if it has no value.
    /// - Throws: `RuntimeError.undefinedVariable` if the variable is not defined in any scope.
    func get(name: Token) throws -> Any? {
        
        guard let value = values[name.lexeme] else {
            
            if let enclosing = enclosing {
                return try enclosing.get(name: name)
            }
            
            throw RuntimeError.undefinedVariable(name: name.lexeme)
        }
        
        return value
    }
    
    /// Assigns a new value to an existing variable in the current or enclosing scope.
    ///
    /// - Parameters:
    ///   - name: A `Token` representing the name of the variable to assign.
    ///   - value: The new value to associate with the variable.
    /// - Throws: `RuntimeError.undefinedVariable` if the variable is not defined in any scope.
    func assign(name: Token, value: Any?) throws {
        
        guard let _ = values[name.lexeme] else {
            
            if let enclosing = enclosing {
                try enclosing.assign(name: name, value: value)
                return
            }
            
            throw RuntimeError.undefinedVariable(name: name.lexeme)
        }
        
        values[name.lexeme] = value
    }
}
