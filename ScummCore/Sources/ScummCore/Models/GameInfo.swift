//
//  GameInfo.swift
//  
//
//  Created by Michael Borgmann on 17/09/2023.
//

import Foundation

/**
 A struct representing information about a SCUMM game.
 
 - Parameters:
     - version: The version of the SCUMM game.
     - platform: The platform on which the game runs.
     - id: A unique identifier for the game.
     - path: The path to the game directory.
 */
public struct GameInfo: Decodable {
    
    /// The version of the SCUMM game.
    public let version: ScummVersion
    
    /// The platform on which the game runs.
    public let platform: ScummPlatform
    
    /// A unique identifier for the game.
    public let id: ScummGame
    
    /// The path to the game directory.
    public let path: String

    /// Enum defining the coding keys used for encoding and decoding `GameInfo` objects.
    enum CodingKeys: String, CodingKey {
        
        case version
        case platform
        case id
        case path
    }
    
    
    /// Initializes a `GameInfo` object by decoding data from the given decoder.
    ///
    /// - Parameter decoder: The decoder to read data from.
    /// - Throws: An error of type `ScummCoreError` if decoding fails due to unsupported data or missing keys.
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.version = try {
            
            let version = try container.decode(Int.self, forKey: .version)
            
            guard let scummVersion = ScummVersion(rawValue: version) else {
                throw ScummCoreError.unsupportedVersion(version)
            }
            
            return scummVersion
        }()
        
        self.platform = try {
            
            let platform = try container.decode(String.self, forKey: .platform)
            
            guard let platform = ScummPlatform(rawValue: platform) else {
                throw ScummCoreError.unsupportedPlatform(platform)
            }
            
            return platform
        }()
        
        self.id = try {
            
            let gameIdentifier = try container.decode(String.self, forKey: .id)
            
            guard let gameIdentifier = ScummGame(rawValue: gameIdentifier)else {
                throw ScummCoreError.unsupportedGame(gameIdentifier)
            }
            
            return gameIdentifier
        }()
        
        self.path = try container.decode(String.self, forKey: .path)
    }
}
