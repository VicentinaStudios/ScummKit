//
//  DataFileTests.swift
//  
//
//  Created by Michael Borgmann on 23/11/2023.
//

import XCTest
@testable import ScummCore

final class DataFileTests: XCTestCase {
    
    var gameDirectoryURL: URL!
    var indexFile: IndexFileV5!
    var dataFile: DataFileV5!
    var temporaryDirectory: URL!

    override func setUpWithError() throws {
        
        guard let path = TestHelper.gameInfo?
            .first(where: { $0.version == .v5 })?
            .path
        else {
            _ = XCTSkip("No SCUMM v5 game found.")
            return
        }
        
        gameDirectoryURL = URL(filePath: path)
        indexFile = try IndexFileV5(at: gameDirectoryURL)
        dataFile = try DataFileV5(at: gameDirectoryURL)
        
        //temporaryDirectory = try createDirectoryWithReadError()
    }
    
    override func tearDownWithError() throws {
//        try FileManager.default.removeItem(at: temporaryDirectory)
    }
    
    func testInitializationWithValidDirectory() {
        XCTAssertNotNil(dataFile, "DataFileV5 should be initialized with a valid directory")
    }
    
    func testInitializationWithEmptyDirectory() {
        
        let emptyDirectoryURL = FileManager.default.temporaryDirectory
        let emptyDataFile = try? DataFileV5(at: emptyDirectoryURL)
            
        XCTAssertNil(emptyDataFile, "DataFileV5 should not be initialized with an empty directory")
    }
    
    func testDataFileHasRoomOffsetTable() {
        XCTAssertNotNil(try? dataFile.roomOffsets)
    }
    
    func testIndexFilesHasReadScripts() {
        
        let resource = indexFile.resources!.scripts[1]
        
        let script = try? dataFile.readResource(resource: resource, type: .script) as? ScriptResource
        
        XCTAssertNotNil(script)
    }
}
