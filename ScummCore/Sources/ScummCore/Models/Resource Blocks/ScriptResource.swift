//
//  ScriptBlock.swift
//
//
//  Created by Michael Borgmann on 23/11/2023.
//

import Foundation

public protocol ResourceProtocol {
    
    static func load(from file: ScummFile, at offset: Int) throws -> ResourceProtocol
}

/// Represents a script resource containing byte code instructions.
public struct ScriptResource: ResourceProtocol {
    
    /// The byte code instructions of the script resource.
    let byteCode: [UInt8]
    
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
        return ScriptResource(byteCode: byteCode)
    }
}
