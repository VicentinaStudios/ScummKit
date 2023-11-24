//
//  ResourceHeader.swift
//
//
//  Created by Michael Borgmann on 23/11/2023.
//

import Foundation

/// Represents the header information for a resource block in the game's data.
public struct ResourceHeader {
    
    /// The type of the resource.
    let resourceType: ResourceType
    
    /// The size of the resource in bytes.
    let resourceSize: Int
    
    /// Initializes a `ResourceHeader` by reading information from the given `ScummFile`.
    ///
    /// - Parameters:
    ///   - dataFile: The `ScummFile` to read the resource header from.
    ///   - offset: The offset in the file where the resource header is located.
    /// - Throws: A `ScummCoreError` if there is an issue reading the header.
    init(from dataFile: ScummFile, offset: Int) throws {
        
        try dataFile.move(to: offset)
        
        guard
            let resourceType = try? dataFile.consumeUInt32.bigEndian,
            let resourceSize = try? dataFile.consumeUInt32.bigEndian
        else {
            throw ScummCoreError.missingResource("Block Header", "data file")
        }
        
        self.resourceType = ResourceType(rawValue: resourceType.string)
        self.resourceSize = Int(resourceSize)
    }
}
