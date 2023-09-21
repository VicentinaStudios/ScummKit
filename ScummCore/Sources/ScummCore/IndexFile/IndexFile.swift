//
//  File.swift
//  
//
//  Created by Michael Borgmann on 28/08/2023.
//

import Foundation

/// A protocol representing an index file for Scumm games.
public protocol IndexFile {
    
    /// The URL of the index file if found, otherwise `nil`.
    var indexFileURL: URL { get }
    
    /// List of the room names in a SCUMM game.
    var roomNames: [RoomName]? { get }
    
    /// List of  available resources in a SCUMM game, including rooms, scripts, sounds, costumes, characters, and objects.
    var resources: Resources? { get }
    
    /// Initializes an index file instance for a game located at the provided directory URL.
    ///
    /// - Parameter gameDirectoryURL: The URL of the directory containing the game files.
    /// - Throws: An error of type `ScummCoreError` if the index file is not found.
    init(at gameDirectoryURL: URL) throws
    
    /// Reads the contents of the index file located at the specified URL.
    ///
    /// - Parameter fileURL: The URL of the index file to be read.
    /// - Throws: An error of type `ScummCoreError` if an issue occurs while reading the file.
    func readIndexFile(_ fileURL: URL) throws
}
