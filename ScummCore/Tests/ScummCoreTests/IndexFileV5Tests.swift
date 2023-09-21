//
//  IndexFileV5Tests.swift
//  
//
//  Created by Michael Borgmann on 19/09/2023.
//

import XCTest
@testable import ScummCore

final class IndexFileV5Tests: XCTestCase {
    
    var gameDirectoryURL: URL!
    var indexFile: IndexFileV5!
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
        
        temporaryDirectory = try createDirectoryWithReadError()
    }
    
    override func tearDownWithError() throws {
        try FileManager.default.removeItem(at: temporaryDirectory)
    }
    
    func testInitializationWithValidDirectory() {
        XCTAssertNotNil(indexFile, "IndexFileV5 should be initialized with a valid directory")
    }
    
    func testInitializationWithEmptyDirectory() {
        
        let emptyDirectoryURL = FileManager.default.temporaryDirectory
        let emptyIndexFile = try? IndexFileV5(at: emptyDirectoryURL)
            
        XCTAssertNil(emptyIndexFile, "IndexFileV5 should not be initialized with an empty directory")
    }
    
    func testInitializationWithIndexFileInitializationError() {
        
        let invalidIndexFileDirectoryURL = createInvalidIndexFileDirectory()

        do {
            _ = try IndexFileV5(at: invalidIndexFileDirectoryURL)
            XCTFail("Initialization should throw an error")
        } catch let error as ScummCoreError {
            XCTAssertEqual(error, ScummCoreError.noIndexFileFound(invalidIndexFileDirectoryURL.path()), "Error should match")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testInitializationWithIndexFileReadingError() {
        
        guard let directoryURLWithReadError = try? createDirectoryWithReadError() else {
            XCTFail("Can't create mock index file")
            return
        }

        do {
            _ = try IndexFileV5(at: directoryURLWithReadError)
            XCTFail("Initialization should throw an error")
        } catch let error as ScummCoreError {
            XCTAssertEqual(error, ScummCoreError.insufficientData, "Error should match")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}

extension IndexFileV5Tests {
    
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
            
        let validIndexFileURL = tempDirURL.appendingPathComponent("valid.000")
        try mockData.write(to: validIndexFileURL)
            
        return tempDirURL
    }

    
    var mockData: Data {
        "TEST".data(using: .utf8)!
    }
}


