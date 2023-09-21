//
//  File.swift
//  
//
//  Created by Michael Borgmann on 17/09/2023.
//

import XCTest
@testable import ScummCore

struct TestHelper {
    
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
