//
//  RoomOffsetTests.swift
//  
//
//  Created by Michael Borgmann on 23/11/2023.
//

import XCTest
@testable import ScummCore

class MockRoomOffsetsFile {
    
    var tempFileURL: URL!
    var testData: [UInt8]!
    var scummFile: ScummFile!
    
    init(testData: [UInt8]? = nil) {
        
        if testData == nil {
            self.testData = [
                0x4c, 0x45, 0x43, 0x46, // LECF
                0x00, 0x00, 0x00, 0x20, // file size
                0x4c, 0x4f, 0x46, 0x46, // ResourceType
                0x00, 0x00, 0x00, 0x12, // ResourceSize
                0x02,                   // number of rooms
                0x01,                   // room 1
                0x0a, 0x0b, 0x0c, 0x0d, // offset room 1
                0x02,                   // room 2
                0x12, 0x34, 0x56, 0x78  // offset room 2
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

class RoomOffsetTests: XCTestCase {

    var mockFile: MockRoomOffsetsFile!

    override func tearDown() {
        super.tearDown()
        try? FileManager.default.removeItem(at: mockFile.tempFileURL)
    }

    func testRoomOffsetInitialization() {
        
        mockFile = MockRoomOffsetsFile()

        do {
            
            try? mockFile.scummFile.move(to: 17)
            let roomOffset = try RoomOffset.createRoomOffset(from: mockFile.scummFile)

            XCTAssertEqual(roomOffset.roomNumber, 1)
            XCTAssertEqual(roomOffset.offset, 0x0d0c0b0a)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testReadAllRoomOffsets() {
        
        do {
            
            mockFile = MockRoomOffsetsFile()
            try mockFile.scummFile.move(to: 0)
            
            let roomOffsets = try RoomOffset.readAll(from: mockFile.scummFile).get()

            XCTAssertEqual(roomOffsets.count, 2)
            XCTAssertEqual(roomOffsets[0].roomNumber, 1)
            XCTAssertEqual(roomOffsets[0].offset, 0x0d0c0b0a)
            XCTAssertEqual(roomOffsets[1].roomNumber, 2)
            XCTAssertEqual(roomOffsets[1].offset, 0x78563412)
            
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
