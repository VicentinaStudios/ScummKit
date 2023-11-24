//
//  ScummCore.swift
//  
//
//  Created by Michael Borgmann on 28/08/2023.
//

import Foundation

/// Represents the ScummCore framework.
public class ScummCore {
    
    /// The URL of the directory containing the Scumm game.
    let gameDirectoryURL: URL
    
    /// The version of the Scumm engine being used.
    let version: ScummVersion
    
    /// The index file associated with the Scumm game.
    public var indexFile: IndexFile?
    
    /// The data file associated with the Scumm game.
    public var dataFile: DataFile?
    
    /// Initializes a ScummCore instance with the provided game directory URL and version.
    ///
    /// - Parameters:
    ///   - gameDirectory: The URL of the directory containing the Scumm game.
    ///   - version: The version of the Scumm engine being used.
    /// - Throws: An error if initializing the index file fails.
    public init(gameDirectory url: URL, version: ScummVersion) throws {
        
        self.gameDirectoryURL = url
        self.version = version
    }
    
    public func loadIndexFile() throws {
        
        switch version {
        case .v4:
            self.indexFile = try IndexFileV4(at: gameDirectoryURL)
        case .v5:
            self.indexFile = try IndexFileV5(at: gameDirectoryURL)
        default:
            throw ScummCoreError.unsupportedVersion(version.rawValue)
        }
    }
    
    public func loadDataFile() throws {
        
        switch version {
        case .v5:
            self.dataFile = try DataFileV5(at: gameDirectoryURL)
        default:
            throw ScummCoreError.unsupportedVersion(version.rawValue)
        }
    }
}
