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
    
    /// Represents a string value.
    case string(String)
    
    /// Represents a nil value.
    case `nil`
}
