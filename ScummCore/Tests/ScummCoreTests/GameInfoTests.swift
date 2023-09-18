//
//  GameInfoTests.swift
//  
//
//  Created by Michael Borgmann on 17/09/2023.
//

import XCTest
@testable import ScummCore

final class GameInfoTests: XCTestCase {
    
    let json = """
    {
        "version": 5,
        "platform": "dos",
        "id": "monkey",
        "path": "/path/to/game"
    }
    """.data(using: .utf8)!
    
    var gameInfo: GameInfo!

    override func setUpWithError() throws {
        
        super.setUp()
        
        let decoder = JSONDecoder()
        gameInfo = try decoder.decode(GameInfo.self, from: json)
    }

    override func tearDownWithError() throws {
        gameInfo = nil
        super.tearDown()
    }

    func testDecodingVersion() throws {
        XCTAssertEqual(gameInfo.version, .v5)
    }

    func testDecodingPlatform() throws {
        XCTAssertEqual(gameInfo.platform, .dos)
    }

    func testDecodingID() throws {
        XCTAssertEqual(gameInfo.id, .monkey)
    }

    func testDecodingPath() throws {
        XCTAssertEqual(gameInfo.path, "/path/to/game")
    }
}
