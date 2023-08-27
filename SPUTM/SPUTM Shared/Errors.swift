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
    
    var errorDescription: String? {
        switch self {
            
        case .scummVersionNotSupported(let version):
            return "SCUMM Version \(version) Not Supported"
        }
    }
    
    var failureReason: String? {
        switch self {
        case.scummVersionNotSupported(_):
            return "Only SCUMM version 4 & 5 are supported, targeting Monkey Island 1 & 2 and Indiana Jones 4."
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .scummVersionNotSupported(_):
            return "Make sure the game is compatible with SCUMM 4/5. Otherwise, consider using ScummVM."
        }
    }
}
