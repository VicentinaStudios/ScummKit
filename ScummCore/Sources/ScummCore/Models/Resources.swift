//
//  Resources.swift
//
//
//  Created by Michael Borgmann on 21/09/2023.
//

import Foundation

/// Represents various resources available in a SCUMM game.
///
/// The `Resources` structure encapsulates different types of resources used within a SCUMM game.
/// These resources include rooms, scripts, sounds, costumes, characters, and objects,
/// each represented as an array of `DirectoryEntry` instances.
public struct Resources {
        
    /// An array of `DirectoryEntry` instances representing rooms in the SCUMM game.
    public let rooms: [DirectoryEntry]
    
    /// An array of `DirectoryEntry` instances representing scripts in the SCUMM game.
    public let scripts: [DirectoryEntry]
    
    /// An array of `DirectoryEntry` instances representing sounds in the SCUMM game.
    public let sounds: [DirectoryEntry]
    
    /// An array of `DirectoryEntry` instances representing costumes in the SCUMM game.
    public let costumes: [DirectoryEntry]
    
    /// An array of `DirectoryEntry` instances representing characters in the SCUMM game.
    public let characters: [DirectoryEntry]
    
    /// An array of `DirectoryEntry` instances representing objects in the SCUMM game.
    public let objects: [DirectoryEntry]
}

/// Represents a directory entry for a resource in a SCUMM game.
extension Resources {
    
    /// A structure that holds information about a directory entry for a resource.
    public struct DirectoryEntry {
        
        /// The unique identifier or room number associated with the directory entry.
        public let roomNumber: Int
        
        /// The offset or position of the resource within the game's data.
        public let offset: Int
        
        /// Converts room numbers and offsets into an array of directory entries.
        ///
        /// - Parameters:
        ///   - roomNumbers: An array of room numbers.
        ///   - offsets: An array of offsets.
        /// - Returns: An array of directory entries.
        static func convert(roomNumbers: [Int], offsets: [Int]) -> [DirectoryEntry] {
            
            zip(roomNumbers, offsets).map {
                DirectoryEntry(roomNumber: $0, offset: $1)
            }
        }
    }
}
