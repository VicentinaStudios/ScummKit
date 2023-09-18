//
//  FileUtilsTests.swift
//  
//
//  Created by Michael Borgmann on 17/09/2023.
//

import XCTest
@testable import ScummCore

final class FileUtilsTests: XCTestCase {
    
    var directoryURL: URL!
    
    override func setUpWithError() throws {
        super.setUp()
        
        guard let path = TestHelper.gameInfo?.first?.path else {
            XCTFail("No game path found")
            fatalError()
        }
        
        directoryURL = URL(filePath: path)
    }
    
    override func tearDownWithError() throws {
        directoryURL = nil
    }
    
    func testDirectoryContentNotNil() {
        let contents = FileUtils.directoryContent(in: directoryURL)
        XCTAssertNotNil(contents, "Failed to retrieve directory contents")
    }
    
    func testDirectoryContentNotEmpty() {
        let contents = FileUtils.directoryContent(in: directoryURL)
        XCTAssertFalse(contents!.isEmpty, "Directory contents array is empty")
    }
}
