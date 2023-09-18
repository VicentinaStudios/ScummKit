//
//  ScumeCoreError.swift
//  
//
//  Created by Michael Borgmann on 28/08/2023.
//

import Foundation

enum ScummCoreError: LocalizedError, Equatable {
    
    case noIndexFileFound(String)
    case insufficientData
    case invalidPointer
    case emptyDirectory(String)
    case unsupportedPlatform(String)
    case unsupportedVersion(Int)
    case unsupportedGame(String)
    
    var errorDescription: String? {
        
        switch self {
            
        case .noIndexFileFound:
            return "No Index File Found"
        
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
        }
    }
    
    var failureReason: String? {
        
        switch self {
            
        case .noIndexFileFound(let path):
            return "No SCUMM game index file is found at `\(path)`."
            
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
        }
    }
    
    var recoverySuggestion: String? {
        
        switch self {
            
        case .noIndexFileFound(_):
            return "The index file should be:\n* V3/4: 00.lfl / 000.lfl\n* V5/6: .000\n* V7/8: .LA0"
            
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
        }
    }
}
