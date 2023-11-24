//
//  ScriptBlock.swift
//
//
//  Created by Michael Borgmann on 23/11/2023.
//

import Foundation

/// Represents a script resource containing byte code instructions.
public struct Script {
    
    /// The byte code instructions of the script resource.
    public let byteCode: [UInt8]
}

/// Conformance to the `ResourceProtocol` for the `Script` struct.
extension Script: ResourceProtocol {
    
    /// Loads a script resource from a `ScummFile` at the specified offset.
    ///
    /// - Parameters:
    ///   - file: The `ScummFile` from which to load the script resource.
    ///   - offset: The offset within the file where the script resource is located.
    /// - Returns: A `ScriptResource` instance containing the loaded byte code.
    /// - Throws: An error if there's an issue reading the script resource from the file.
    public static func load(from file: ScummFile, at offset: Int) throws -> ResourceProtocol {

        let header = try ResourceHeader(from: file, offset: offset)
        
        let resourceSize = header.resourceSize - 8
        
        guard resourceSize > 0 else {
            throw ScummCoreError.missingResource("script", "data file")
        }
        
        let byteCode = try file.read(bytes: resourceSize)
        return Script(byteCode: byteCode)
    }
}
