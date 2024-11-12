//
//  ValueType.swift
//
//
//  Created by Michael Borgmann on 03/05/2024.
//

import Foundation

/// Represents various types of values.
public enum Value: Equatable {
    
    /// Represents an integer value.
    case int(Int)
    
    /// Represents a boolean value.
    case bool(Bool)
    
    /// Represents a double value.
    case double(Double)
    
    /// Represents a heap object.
    case object(Object)
    
    /// Represents a nil value.
    case `nil`
}

/// Provides additional computed properties and utility functions for the `Value` type.
extension Value {
    
    /// Indicates whether the value is a string.
    ///
    /// - Returns: `true` if the value is a string; otherwise, `false`.
    var isString: Bool {
        if case .object(let type) = self, type.isString { return true }
        return false
    }
    
    /// Retrieves the value as a string if it is a string type.
    ///
    /// - Returns: The string value if the value is a string, or `nil` if it is not a string.
    var asString: String? {
        if case .object(let object) = self, case .string(let value) = object.type {
            return value
        }
        return nil
    }
    
    /// Indicates whether the value is numeric.
    ///
    /// A value is considered numeric if it is of type `.int` or `.double`.
    ///
    /// - Returns: `true` if the value is numeric; otherwise, `false`.
    var isNumeric: Bool {
        switch self {
        case .int, .double:
            return true
        default:
            return false
        }
    }
    
    /// Determines whether a given value is considered "falsey".
    ///
    /// In this context, a value is considered "falsey" if it is either:
    /// - `.nil`, representing the absence of a value.
    /// - `.bool(false)`, representing a boolean false.
    ///
    /// - Returns: `true` if `value` is `.nil` or `.bool(false)`; otherwise, `false`.
    ///
    /// - Note: This method is typically used in logical conditions where
    ///   a `nil` or `false` value should be treated as "falsey".
    public var isFalsey: Bool {
        return self == .nil || self == .bool(false)
    }
    
    /// Compares two `Value` instances for equality.
    ///
    /// - Parameters:
    ///   - left: The first `Value` to compare.
    ///   - right: The second `Value` to compare.
    /// - Returns: `true` if both `Value` instances are equal, `false` otherwise.
    ///
    /// This method checks for equality between two `Value` instances of the following types:
    /// - `.bool`: Compares the boolean values.
    /// - `.int`: Compares the integer values.
    /// - `.nil`: Always returns `true` if both are `.nil`.
    /// If the types are different or values are not equal, it returns `false`.
    public static func ==(left: Value, right: Value) -> Bool {
        
        switch (left, right) {
            
        case (.bool(let leftBool), .bool(let rightBool)):
            return leftBool == rightBool
            
        case (.int(let leftInt), .int(let rightInt)):
            return leftInt == rightInt
            
        case (.double(let left), .double(let right)):
            return left.isEqual(to: right)
            
        case (.object(let leftObject), .object(let rightObject)):
            if case .string(let left) = leftObject.type, case .string(let right) = rightObject.type {
                return left == right
            }
            return false
            
        case (.nil, .nil):
            return true
            
        default:
            return false
        }
    }
}
