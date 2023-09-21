//
//  File.swift
//  
//
//  Created by Michael Borgmann on 15/09/2023.
//

import Foundation

extension BinaryInteger {
    
    /// Decrypts the receiver using XOR encryption with the specified key.
    ///
    /// - Parameters:
    ///   - key: The XOR encryption key.
    /// - Returns: The decrypted result.
    public func xorDecrypt<T: BinaryInteger>(key: T) -> Self {
        self ^ generateKey(from: key)
    }
    
    /// Generates an XOR encryption key from the provided integer key.
    ///
    /// This method takes an integer key and generates an XOR encryption key of the same type
    /// by repeating the bytes of the original key to match the size of the target integer type.
    /// It ensures that the resulting key is suitable for XOR encryption with an integer of the
    /// same type.
    ///
    /// - Parameter key: The original integer key.
    /// - Returns: An XOR encryption key of the same integer type as the original key.
    private func generateKey<T: BinaryInteger>(from key: T) -> Self {
        
        let size = MemoryLayout<Self>.size
        
        return (0..<size).reduce(Self(0)) { result, _ in
            (result << 8) | Self(key)
        }
    }
    
    /// Converts the integer into an array of Unicode scalars, where each scalar represents a byte.
    private var unicode: [UnicodeScalar] {
        let bytes = withUnsafeBytes(of: self) { Array($0.reversed()) }
        return bytes.map { UnicodeScalar($0) }
    }
    
    /// Converts each Unicode scalar in the byte array to a string representation.
    public var char: [String] {
        unicode.map { String($0) }
    }
    
    /// Converts the integer into a string with byte-wise representation.
    ///
    /// This method creates a string where each byte of the integer corresponds to a character.
    /// For example, if the integer is 0x41424344, the resulting string will be "ABCD".
    ///
    /// - Returns: A string representation of the integer with byte-wise encoding.
    public var string: String {
        char.joined()
    }
}
