//
//  ResourceHeaderTests.swift
//  
//
//  Created by Michael Borgmann on 23/11/2023.
//

import XCTest
@testable import ScummCore

class MockResourceHeaderFile {
    
    var tempFileURL: URL!
    var testData: [UInt8]!
    var scummFile: ScummFile!
    
    init(testData: [UInt8]? = nil) {
        
        if testData == nil {
            self.testData = [
                0x4c, 0x4f, 0x46, 0x46, // resource type
                0x00, 0x00, 0x00, 0x08, // resource size
            ]
        } else {
            self.testData = testData
        }
        
        tempFileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("testfile.bin")
        
        do {
            try Data(self.testData).write(to: tempFileURL)
            scummFile = try ScummFile(fileURL: tempFileURL)
        } catch {
            XCTFail("Failed to set up temporary file: \(error)")
        }
    }
}

class ResourceHeaderTests: XCTestCase {
    
    var mockFile: MockResourceHeaderFile!
    
    override func tearDown() {
        super.tearDown()
        try? FileManager.default.removeItem(at: mockFile.tempFileURL)
    }

    func testResourceHeaderInitialization() {
        
        mockFile = MockResourceHeaderFile()
        
        do {
            let header = try ResourceHeader(from: mockFile.scummFile, offset: 0)

            XCTAssertEqual(header.resourceType, .roomOffsets)
            XCTAssertEqual(header.resourceSize, 8)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testResourceHeaderInvalidType() {
        
        let mockData: [UInt8] = [0x00, 0x00, 0x00, 0x01]
        mockFile = MockResourceHeaderFile(testData: mockData)

        XCTAssertThrowsError(try ResourceHeader(from: mockFile.scummFile, offset: 0)) { error in
            
            XCTAssertTrue(error is ScummCoreError)
            XCTAssertEqual(error as? ScummCoreError, .missingResource("Block Header", "data file"))
        }
    }
}
