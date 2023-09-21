//
//  ScummVersion.swift
//
//
//  Created by Michael Borgmann on 27/08/2023.
//

import Foundation

/// Enum representing all SCUMM versions by Lucas (v0 - v8)
public enum ScummVersion: Int {
    
    case v0, v1, v2, v3, v4, v5, v6, v7, v8
    
    /// Compares two `ScummVersion` instances to determine their relative order.
    ///
    /// This method implements the less-than comparison (`<`) operator for `ScummVersion` instances,
    /// allowing you to compare their underlying `rawValue` properties.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side `ScummVersion` operand for comparison.
    ///   - rhs: The right-hand side `ScummVersion` operand for comparison.
    ///
    /// - Returns: `true` if the `rawValue` of `lhs` is less than the `rawValue` of `rhs`, `false` otherwise.
    public static func < (lhs: ScummVersion, rhs: ScummVersion) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    
    /// Compares two `ScummVersion` instances to determine if the left-hand side version is less than or equal to the right-hand side version.
    ///
    /// This method implements the less-than or equal to comparison (`<=`) operator for `ScummVersion` instances.
    /// It compares the `rawValue` property of both operands to ascertain their relative order.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side `ScummVersion` operand for comparison.
    ///   - rhs: The right-hand side `ScummVersion` operand for comparison.
    ///
    /// - Returns: `true` if the `rawValue` of `lhs` is less than or equal to the `rawValue` of `rhs`, `false` otherwise.
    public static func <= (lhs: ScummVersion, rhs: ScummVersion) -> Bool {
        return lhs.rawValue <= rhs.rawValue
    }
    
    /// Compares two `ScummVersion` instances to determine if the left-hand side version is greater than the right-hand side version.
    ///
    /// This method implements the greater-than comparison (`>`) operator for `ScummVersion` instances.
    /// It compares the `rawValue` property of both operands to establish their relative order.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side `ScummVersion` operand for comparison.
    ///   - rhs: The right-hand side `ScummVersion` operand for comparison.
    ///
    /// - Returns: `true` if the `rawValue` of `lhs` is greater than the `rawValue` of `rhs`, `false` otherwise.
    public static func > (lhs: ScummVersion, rhs: ScummVersion) -> Bool {
        return lhs.rawValue > rhs.rawValue
    }
    
    /// Compares two `ScummVersion` instances to determine if the left-hand side version is greater than or equal to the right-hand side version.
    ///
    /// This method implements the greater-than or equal to comparison (`>=`) operator for `ScummVersion` instances.
    /// It compares the `rawValue` property of both operands to establish their relative order.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side `ScummVersion` operand for comparison.
    ///   - rhs: The right-hand side `ScummVersion` operand for comparison.
    ///
    /// - Returns: `true` if the `rawValue` of `lhs` is greater than or equal to the `rawValue` of `rhs`, `false` otherwise.
    public static func >= (lhs: ScummVersion, rhs: ScummVersion) -> Bool {
        return lhs.rawValue >= rhs.rawValue
    }
}
