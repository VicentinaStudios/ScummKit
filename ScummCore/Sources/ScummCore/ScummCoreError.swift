//
//  ScumeCoreError.swift
//  
//
//  Created by Michael Borgmann on 28/08/2023.
//

import Foundation

public enum ScummCoreError: LocalizedError, Equatable {
    
    case noIndexFileFound(String)
    case noDataFileFound(String)
    case insufficientData
    case invalidPointer
    case emptyDirectory(String)
    case unsupportedPlatform(String)
    case unsupportedVersion(Int)
    case unsupportedGame(String)
    case unknownBlock(String)
    case decodeFailure(String, String)
    case missingResource(String, String)
    case cantLoadResource(String, String)
    case outOfBounds
    
    public var errorDescription: String? {
        
        switch self {
            
        case .noIndexFileFound:
            return "No Index File Found"
            
        case .noDataFileFound:
            return "No Data File Found"
        
        case .insufficientData:
            return "Insufficient Data"
            
        case .invalidPointer:
            return "Invalid Pointer"
            
        case .emptyDirectory:
            return "Empty Directory"
            
        case .unsupportedPlatform:
            return "Unsupported Platform"
        
        case .unsupportedVersion:
            return "Unsupported Version"
            
        case .unsupportedGame:
            return "Unsupported Game"
            
        case .unknownBlock:
            return "Unknown Block"
            
        case .decodeFailure:
            return "Decode Failure"
            
        case .missingResource:
            return "Missing Resources"
            
        case .cantLoadResource:
            return "Can't Load Resource"
            
        case .outOfBounds:
            return "Out of Bounds"
        }
    }
    
    public var failureReason: String? {
        
        switch self {
            
        case .noIndexFileFound(let path):
            return "No SCUMM game index file is found at `\(path)`."
            
        case .noDataFileFound(let path):
            return "No SCUMM game resource data file is found at `\(path)`."
            
        case .insufficientData:
            return "Not enough data left to be read."
        
        case .invalidPointer:
            return "Failed to obtain a valid pointer from the memory location."
            
        case .emptyDirectory(let path):
            return "No file found in directory `\(path)`."
            
        case .unsupportedPlatform(let platform):
            return "Platform `\(platform)` is not supported."
            
        case .unsupportedVersion(let version):
            return "Unknown or unsupported SCUMM version `\(version)`."
            
        case .unsupportedGame(let game):
            return "Unknown or unsupported SCUMM game `\(game)`."
            
        case .unknownBlock(let blockType):
            return "Block type `\(blockType)` is unknown, not supported, or the file is corrupted."
            
        case .decodeFailure(let entity, let value):
            return "Failed to decode `\(entity)` for `\(value)`."
            
        case .missingResource(let blockType, let file):
            return "No resources found for `\(blockType)` in \(file)."
            
        case .cantLoadResource(let resourceType, let file):
            return "Can't load resource `\(resourceType)` from file `\(file)`."
            
        case .outOfBounds:
            return "Some iteration seems to get out of bounds."
        }
    }
    
    public var recoverySuggestion: String? {
        
        switch self {
            
        case .noIndexFileFound(_):
            return "The index file should be:\n* V3/4: 00.lfl / 000.lfl\n* V5/6: .000\n* V7/8: .LA0"
            
        case .noDataFileFound(_):
            return "The data file should be:\n* V3: [1-99].lfl\n V4: *.lec / 001.lfl\n* V5/6: .001\n* V7/8: .LA1"
            
        case .insufficientData:
            return "The file or data can be corrupt. Please try another."
        
        case .invalidPointer:
            return "Please try again."
            
        case .emptyDirectory:
            return "Make sure you selected the game directory."
        
        case .unsupportedPlatform:
            return "SCUMM has been released on these platforms: 3DO, Amiga, Apple II, Atari ST, CDTV, Commodore 64, Fujitsu FM Towns & Marty, Apple Macintosh, Nintendo Entertainment System, DOS, Microsoft Windows, Sega CD (Mega-CD), and TurboGrafx-16/PC Engine."
            
        case .unsupportedVersion:
            return "Select a proper SCUMM version (v0 to v8)"
            
        case .unsupportedGame:
            return "Select a SCUMM game (mania, zak, indy3, loom, monkey, monkey2, indy4, tentacle, samnmax, ft, dig, cmi)."
            
        case .unknownBlock:
            return "Try with different configurations, or another game."
            
        case .decodeFailure:
            return "If the data is corrupt, try another file."
            
        case .missingResource(_, let file):
            return "The \(file) seems to be incomplete."
            
        case .cantLoadResource(let resourceType, let file):
            return "The file `\(file)` seems to be corrupt and is missing data for `\(resourceType)`."
            
        case .outOfBounds:
            return "Corrupt data or a bug."
        }
    }
}
