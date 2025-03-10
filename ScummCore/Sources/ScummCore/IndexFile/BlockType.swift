//
//  BlockType.swift
//  
//
//  Created by Michael Borgmann on 17/09/2023.
//

import Foundation

/// Represents different block types used in the Scumm game index files.
enum BlockType {
    
    /// Block type for names of rooms.
    case roomNames
    
    /// Block type for maximum values used by the engine.
    case maximumValues
    
    /// Block type for directory of rooms.
    case directoryOfRooms
    
    /// Block type for directory of scripts.
    case directoryOfScripts
    
    /// Block type for directory of sounds.
    case directoryOfSounds
    
    /// Block type for directory of costumes.
    case directoryOfCostumes
    
    /// Block type for directory of character sets.
    case directoryOfCharacterSets
    
    /// Block type for directory of objects.
    case directoryOfObjects
    
    /// Block type is unknown or not recognized.
    case unknown
    
    /// Initializes a `BlockType` instance from its raw value.
    ///
    /// - Parameter rawValue: The raw value representing the block type.
    init(rawValue: String) {
                
        switch rawValue {
            
        case "RN", "RNAM":
            self = .roomNames
            
        case "MAXS":
            self = .maximumValues
            
        case "0R", "DROO":
            self = .directoryOfRooms
            
        case "0S", "DSCR":
            self = .directoryOfScripts
            
        case "0N", "DSOU":
            self = .directoryOfSounds
            
        case "0C", "DCOS":
            self = .directoryOfCostumes
            
        case "DCHR":
            self = .directoryOfCharacterSets
            
        case "0O", "DOBJ":
            self = .directoryOfObjects
        
        default:
            self = .unknown
        }
    }
    
    var rawValueV5: String {
        switch self {
            
        case .roomNames:
            return "RNAM"
        case .maximumValues:
            return "MAXS"
        case .directoryOfRooms:
            return "DROO"
        case .directoryOfScripts:
            return "DSCR"
        case .directoryOfSounds:
            return "DSOU"
        case .directoryOfCostumes:
            return "DCOS"
        case .directoryOfCharacterSets:
            return "DCHR"
        case .directoryOfObjects:
            return "DOBJ"
        default:
            return "unknown block"
        }
    }
}
