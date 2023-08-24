//
//  Errors.swift
//  ScummViewer
//
//  Created by Michael Borgmann on 22/08/2023.
//

import Foundation

enum FileError: Error {
    case loadFailure
    case saveFailure
    case urlFailure
}

enum RuntimeError: LocalizedError {
    
    case noDirectorySet
    case emptyDirectory
    case unknownVersion
    
    var errorDescription: String? {
        switch self {
        case .noDirectorySet:
            return "No Directory Set"
        case .emptyDirectory:
            return "Empty Directory"
        case .unknownVersion:
            return "Unkown Version"
        }
    }
    
    var failureReason: String? {
        switch self {
        case .noDirectorySet:
            return "No directory selected to load from."
        case .emptyDirectory:
            return "No files found in directory."
        case .unknownVersion:
            return "Couldn't determine SCUMM version. Maybe the game isn't supported or the files are corrupted."
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .noDirectorySet:
            return "Change to directory of SCUMM game to be loaded."
        case .emptyDirectory:
            return "Select directory of SCUMM game to be loaded."
        case .unknownVersion:
            return "Try to update the ScummViewer or exchange the game for a supported version."
        }
    }
}
