//
//  CommandLineArguments.swift
//  SCUMM
//
//  Created by Michael Borgmann on 05/01/2024.
//

import Foundation

/// Extension for working with command line arguments.
///
/// This extension provides utility functions to check for options, extract values, and extract multiple values for a specified option.
///
/// Example usage:
/// ```swift
/// if CommandLine.hasOption("--verbose") {
///     print("Verbose mode is enabled!")
/// }
///
/// if let value = CommandLine.extractValue(for: "--output") {
///     print("Output file: \(value)")
/// }
///
/// if let values = CommandLine.extractValuesForOption(with: "--files") {
///     print("Files: \(values.joined(separator: ", "))")
/// }
/// ```
extension CommandLine {
    
    /// Check if a specific option is present in the command line arguments.
    ///
    /// - Parameter option: The option to check for.
    /// - Returns: `true` if the option is found, `false` otherwise.
    static func hasOption(_ option: String) -> Bool {
        arguments.contains { $0.hasPrefix(option) }
    }
    
    /// Extract the value associated with a specified option from the command line arguments.
    ///
    /// - Parameters:
    ///   - option: The option to extract the value for.
    ///   - prefix: An optional prefix for the option.
    /// - Returns: The extracted value, or `nil` if the option is not found.
    static func extractValue(for option: String, prefix: String? = nil) -> String? {
        
        let option = option + (prefix ?? "")
        
        guard
            let index = arguments.firstIndex(where: { $0.hasPrefix(option) })
        else {
            return nil
        }
        
        let value = arguments[index].replacingOccurrences(of: option, with: "")
        return value.isEmpty ? nil : value
    }
    
    /// Extract multiple values for a specified option from the command line arguments.
    ///
    /// - Parameter option: The option to extract values for.
    /// - Returns: An array of extracted values, or `nil` if the option is not found.
    static func extractValuesForOption(with option: String? = nil, subsequentOption: String? = nil) -> [String]? {
        
        guard arguments.count != 1 else { return nil }
        
        var values: [String]?
        var skipNextArgument = false
        var previous = arguments[1]
        
        for arg in arguments.dropFirst() {
            
            if skipNextArgument, arg.hasPrefix("-") {
                return nil
                
            } else if arg.hasPrefix("-"), let values = values {
                return values
                
            } else if skipNextArgument {
                skipNextArgument = false
                values = (values ?? []) + [arg]
                
            } else if let option = option, arg.hasPrefix(option) {
                skipNextArgument = true
                continue
                
            } else if option == nil, !arg.hasPrefix("-"), !previous.hasPrefix(subsequentOption ?? "") {
                values = (values ?? []) + [arg]
                continue
                
            } else if let _ = values {
                values?.append(arg)
            }
            
            previous = arg
        }
        
        return values
    }
}
