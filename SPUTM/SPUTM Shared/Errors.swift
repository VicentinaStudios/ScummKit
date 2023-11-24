//
//  Errors.swift
//  SPUTM
//
//  Created by Michael Borgmann on 27/08/2023.
//

import Foundation
import ScummCore

enum EngineError: LocalizedError {
    
    case scummVersionNotSupported(ScummVersion)
    case invalidDirectory(String)
    case missingGameDirectory
    case missingScummVersion
    case invalidOpcode(UInt8)
    
    var errorDescription: String? {
        
        switch self {
            
        case .scummVersionNotSupported(let version):
            return "SCUMM Version \(version) Not Supported"
            
        case .invalidDirectory(_):
            return "Invalid Directory"
            
        case .missingGameDirectory:
            return "Missing Game Directory"
            
        case .missingScummVersion:
            return "Missing SCUMM Version"
            
        case .invalidOpcode:
            return "Invalid Opcode"
        }
    }
    
    var failureReason: String? {
        
        switch self {
            
        case.scummVersionNotSupported(_):
            return "Only SCUMM version 4 & 5 are supported, targeting Monkey Island 1 & 2 and Indiana Jones 4."
            
        case .invalidDirectory(let path):
            return "Can't access directory: `\(path)`."
            
        case .missingGameDirectory:
            return "The directory of the SCUMM game hasn't been defined."
        
        case .missingScummVersion:
            return "Couldn't determing SCUMM version for game."
            
        case .invalidOpcode(let opcode):
            return "The opcode `0x\(opcode) doesn't exist."
        }
    }
    
    var recoverySuggestion: String? {
        
        switch self {
            
        case .scummVersionNotSupported(_):
            return "Make sure the game is compatible with SCUMM 4/5. Otherwise, consider using ScummVM."
        
        case .invalidDirectory(_):
            return "Select different game directory or change access properties."
            
        case .missingGameDirectory:
            return "Specify the game path using the command line argument `-d [PATH/TO/GAME]`."
            
        case .missingScummVersion:
            return "Specify the SCUMM version using the command line argument `-v{0-8}`"
            
        case .invalidOpcode:
            return "The game data seems to be corrupted."
        }
    }
}
