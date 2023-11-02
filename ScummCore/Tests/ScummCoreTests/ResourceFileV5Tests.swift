//
//  ResourceFileV5Tests.swift
//  
//
//  Created by Michael Borgmann on 22/09/2023.
//

import XCTest
@testable import ScummCore

final class ResourceFileV5Tests: XCTestCase {
    
    var gameDirectoryURL: URL!
    var resourceFile: ResourceFileV5!

    override func setUpWithError() throws {
        
        guard let path = TestHelper.gameInfo?
            .first(where: { $0.version == .v5 })?
            .path
        else {
            _ = XCTSkip("No SCUMM v5 game found.")
            return
        }
        
        gameDirectoryURL = URL(filePath: path)
        resourceFile = try ResourceFileV5(at: gameDirectoryURL)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {

        try resourceFile.readResource(at: 56344, room: 10)
    }
}
