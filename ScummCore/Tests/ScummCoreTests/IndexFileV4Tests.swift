//
//  IndexFileV4Tests.swift
//  
//
//  Created by Michael Borgmann on 22/09/2023.
//

import XCTest
@testable import ScummCore

final class IndexFileV4Tests: XCTestCase {
    
    var gameDirectoryURL: URL!
    var indexFile: IndexFileV4!
    var temporaryDirectory: URL!

    override func setUpWithError() throws {
        guard let path = TestHelper.gameInfo?
            .first(where: { $0.version == .v4 })?
            .path
        else {
            _ = XCTSkip("No SCUMM v4 game found.")
            return
        }
        
        gameDirectoryURL = URL(filePath: path)
        indexFile = try IndexFileV4(at: gameDirectoryURL)
        
        temporaryDirectory = try createDirectoryWithReadError()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testScummV4IndexFile() throws {
        
        guard
            let path = TestHelper.gameInfo?.first(where: { $0.version == .v4 })?.path
        else {
            _ = XCTSkip("No SCUMM v4 game found.")
            return
        }
        
        let gameDirectoryURL = URL(filePath: path)
        
        let indexFile = try IndexFileV4(at: gameDirectoryURL)
    }
}

extension IndexFileV4Tests {
    
    func createInvalidIndexFileDirectory() -> URL {
        
        let tempDirURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            
        let invalidIndexFileURL = tempDirURL.appendingPathComponent("invalid")
        FileManager.default.createFile(atPath: invalidIndexFileURL.path, contents: Data())
            
        return tempDirURL
    }
    
    func createDirectoryWithReadError() throws -> URL {

        let tempDirURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            
        try FileManager.default.createDirectory(at: tempDirURL, withIntermediateDirectories: true, attributes: nil)
            
        let validIndexFileURL = tempDirURL.appendingPathComponent("000.LFL")
        try mockData.write(to: validIndexFileURL)
            
        return tempDirURL
    }

    
    var mockData: Data {
        "TEST".data(using: .utf8)!
    }
}
