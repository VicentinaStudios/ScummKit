//
//  BlockType.swift
//  
//
//  Created by Michael Borgmann on 17/09/2023.
//

import Foundation

/// Represents different block types used in the Scumm game index files.
enum BlockType {
    
    /// Block type for directory of rooms.
    case directoryOfRooms
    
    /// Block type for directory of scripts.
    case directoryOfScripts
    
    /// Block type for directory of sounds.
    case directoryOfSounds
    
    /// Block type for directory of costumes.
    case directoryOfCostumes
    
    /// Block type for directory of objects.
    case directoryOfObjects
    
    /// Block type is unknown or not recognized.
    case unknown
    
    /// Initializes a `BlockType` instance from its raw value.
    ///
    /// - Parameter rawValue: The raw value representing the block type.
    init(rawValue: String) {
        
        switch rawValue {
            
        case "0R", "DROO":
            self = .directoryOfRooms
            
        case "0S", "DSCR":
            self = .directoryOfScripts
            
        case "0N", "DSOU":
            self = .directoryOfSounds
            
        case "0C", "DCOS":
            self = .directoryOfCostumes
            
        case "0O", "DOBJ":
            self = .directoryOfObjects
            
        default:
            self = .unknown
        }
    }
}
