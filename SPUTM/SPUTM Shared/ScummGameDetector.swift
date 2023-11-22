//
//  ScummGameMetaData.swift
//  SPUTM
//
//  Created by Michael Borgmann on 19/11/2023.
//

import Foundation
import ScummCore

struct ScummGameDetector {
    
    static var gameDirectoryURL: URL {
        
        get throws {
            
            guard let path = CLI().extractFilenames else {
                throw EngineError.missingGameDirectory
            }

            var isDirectory: ObjCBool = true
            let isPathExisting = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
            
            guard isPathExisting && isDirectory.boolValue else {
                throw EngineError.invalidDirectory(path)
            }
            
            return URL(filePath: path, directoryHint: .isDirectory)
        }
    }
    
    static var scummVersion: ScummVersion {
        
        get throws {
            
            guard
                let value = CLI().extractTargetVersion,
                let scummVersion = ScummVersion(rawValue: value)
            else {
                throw EngineError.missingScummVersion
            }
            
            return scummVersion
        }
    }
    
    static var scummGame: ScummGame {
        
        get throws {
            
            guard
                let value = CLI().extractGameIdentifier,
                let scummGame = ScummGame(rawValue: value)
            else {
                throw EngineError.missingGameDirectory
            }
            
            return scummGame
        }
    }
    
    static var platform: ScummPlatform {
        
        get throws {
            
            guard
                let value = CLI().extractPlatform,
                let platform = ScummPlatform(rawValue: value)
            else {
                throw EngineError.missingGameDirectory
            }
            
            return platform
        }
    }
    
    static var json: Data? {
        
        guard
            let path = try? ScummGameDetector.gameDirectoryURL.path(percentEncoded: false),
            let version = try? ScummGameDetector.scummVersion,
            let platform = try? ScummGameDetector.platform,
            let game = try? ScummGameDetector.scummGame
        else {
            return nil
        }
        
        let jsonString: String = "{"
            + "\"version\": \(version.rawValue),"
            + "\"platform\": \"\(platform)\","
            + "\"id\": \"\(game)\","
            + "\"path\": \"\(path)\""
            + "}"
        
        return jsonString.data(using: .utf8)
    }
    
    static var gameInfo: GameInfo? {
        
        guard let json = json else {
            fatalError("Couldn't infer game meta data")
        }
        
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(GameInfo.self, from: json)
            return result
        } catch {
            debugPrint(error)
        }
        
        return nil
    }
}
