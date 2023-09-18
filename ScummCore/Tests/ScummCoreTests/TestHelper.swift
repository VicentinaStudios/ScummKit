//
//  File.swift
//  
//
//  Created by Michael Borgmann on 17/09/2023.
//

import XCTest
@testable import ScummCore

struct TestHelper {
    
    /*
    static var gameDirectoryURL: URL {
        
        /*
        let path = CommandLine.arguments[1]
        
        var isDirectory: ObjCBool = true
        let isPathExisting = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        
        guard isPathExisting && isDirectory.boolValue else {
            XCTFail("Missing game path as argument in scheme")
            fatalError()
        }
        
        return URL(filePath: path)
        */
        
        return URL(filePath: "/Users/michael/Desktop/ScummViewer/Monkey1")
    }
    */
    
    static var gameInfo: [GameInfo]? {
                    
        var gamesJSON: String?
        var gameInfos: [GameInfo]?
        
        for (index, arg) in CommandLine.arguments.enumerated() {
            if arg == "--games" {
                if index + 1 < CommandLine.arguments.count {
                    gamesJSON = CommandLine.arguments[index + 1]
                    break
                }
            }
        }
        
        if let gamesJSON = gamesJSON {
            
            do {
                
                let jsonData = gamesJSON.data(using: .utf8)!
                gameInfos = try JSONDecoder().decode([GameInfo].self, from: jsonData)
                
            } catch {
                XCTFail("No valid game data")
            }
        }
        
        return gameInfos
    }
}


