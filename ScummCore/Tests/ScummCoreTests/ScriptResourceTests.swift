//
//  ScriptResourceTests.swift
//  
//
//  Created by Michael Borgmann on 23/11/2023.
//

import XCTest
@testable import ScummCore

class MockScriptResourceFile {
    
    var tempFileURL: URL!
    var testData: [UInt8]!
    var scummFile: ScummFile!
    
    init(testData: [UInt8]? = nil) {
        
        if testData == nil {
            self.testData = [
                0x53, 0x43, 0x52, 0x50, // resource type
                0x00, 0x00, 0x00, 0x10, // resource size
                0x01, 0x02, 0x03, 0x04, // Byte code
                0x05, 0x06, 0x07, 0x08, // Byte code
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

class ScriptResourceTests: XCTestCase {
    
    var mockFile: MockScriptResourceFile!
    
    override func setUp() {
        super.setUp()
        mockFile = MockScriptResourceFile()
    }
    
    override func tearDown() {
        super.tearDown()
        try? FileManager.default.removeItem(at: mockFile.tempFileURL)
    }
    
    func testScriptResourceInitialization() {
        
        let script = try? ScriptResource.load(from: mockFile.scummFile, at: 0) as? ScriptResource
            
        XCTAssertEqual(script?.byteCode, [0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08])
        XCTAssertEqual(script?.byteCode.count, 8)
    }
    
    func testScriptResourceInitializationFailure() {
        
        mockFile = MockScriptResourceFile(testData: [0x53, 0x43, 0x52, 0x50, 0x00, 0x00, 0x00, 0x04, 0x01, 0x02, 0x03, 0x04])

        do {
            let _ = try ScriptResource.load(from: mockFile.scummFile, at: 0)
            XCTFail("Expected error but succeeded.")
        } catch let error as ScummCoreError {
            XCTAssertEqual(error, .missingResource("script", "data file"))
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
