//
//  Object.swift
//  ScummCompiler
//
//  Created by Michael Borgmann on 11/11/2024.
//

import Foundation

/// Represents a heap-allocated object used to store different object types, such as strings.
public class Object {
    
    /// The type of object, used to distinguish object variants like strings.
    let type: ObjectType
    
    #if CUSTOM_GARBAGE_COLLECTION
    /// The reference to the next object in memory, used for garbage collection.
    var next: Object?
    
    /// Initializes a new `Object` instance with a specified type and optional next object.
    ///
    /// - Parameters:
    ///   - type: The `ObjectType` of the object.
    ///   - next: The next object in memory, used for garbage collection.
    init(type: ObjectType, next: Object? = nil) {
        self.type = type
        self.next = next
    }
    #else
    /// Initializes a new `Object` instance with a specified type.
    ///
    /// - Parameter type: The `ObjectType` of the object.
    init(type: ObjectType) {
        self.type = type
    }
    #endif
    
    /// Indicates whether this `Object` instance is a string.
    ///
    /// - Returns: `true` if the object is a string; otherwise, `false`.
    var isString: Bool {
        if case .string = type { return true }
        return false
    }
}

/// Represents various types of objects, such as strings, that can be stored in the `Object` class.
public enum ObjectType: Equatable {
    
    /// Represents a string object.
    case string(String)
}
