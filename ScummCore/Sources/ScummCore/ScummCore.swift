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
    var indexFile: IndexFile?
    
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
        // Implement index file loading logic here
        // Set 'indexFile' property based on the loaded index file
        // If loading fails, throw a 'noIndexFileFound' error
        self.indexFile = try IndexFileV5(at: gameDirectoryURL)
    }
}
