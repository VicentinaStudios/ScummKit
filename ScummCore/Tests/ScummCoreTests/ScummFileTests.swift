//
//  ScummFileTests.swift
//  
//
//  Created by Michael Borgmann on 01/09/2023.
//

import XCTest
@testable import ScummCore

class ScummFileTests: XCTestCase {
    
    var tempFileURL: URL!
    var testData: [UInt8]!
    var scummFile: ScummFile!
    
    override func setUp() {

        super.setUp()
        
        // Create temporary files for testing
        testData = [0x01, 0x02, 0x03, 0x04]
        
        tempFileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("testfile.bin")
        
        do {
            try Data(testData).write(to: tempFileURL)
            scummFile = try ScummFile(fileURL: tempFileURL)
        } catch {
            XCTFail("Failed to set up temporary file: \(error)")
        }
    }
    
    override func tearDown() {
        super.tearDown()
        
        do {
            try FileManager.default.removeItem(at: tempFileURL)
        } catch {
            print("Error cleaning up temporary file: \(error)")
        }
    }

    func testReadUInt32BE() throws {
        
        let result = try scummFile.readUInt32BE
        
        XCTAssertEqual(result, 0x01020304)
    }
    
    func testReadUInt32LE() throws {
        
        let result = try scummFile.readUInt32LE
        
        XCTAssertEqual(result, 0x04030201)
    }
    
    func testReadUInt16BE() throws {
        
        let result = try scummFile.readUInt16BE
        
        XCTAssertEqual(result, 0x0102)
    }
    
    func testReadUInt16LE() throws {
        
        let result = try scummFile.readUInt16LE
        
        XCTAssertEqual(result, 0x0201)
    }
    
    func testMoveToValidPosition() throws {
        
        let newPosition = 1
        
        try scummFile.move(to: newPosition)
        
        XCTAssertEqual(scummFile.currentPosition, newPosition)
    }
    
    func testMoveToInvalidPosition() {
        
        let invalidPosition = 1000000
        
        XCTAssertThrowsError(try scummFile.move(to: invalidPosition)) { error in
            XCTAssertEqual(error as? ScummCoreError, ScummCoreError.insufficientData)
        }
    }
    
    func testReadAfterMove() throws {
        
        let newPosition = 2
        
        try scummFile.move(to: newPosition)
        let actualValue = try scummFile.readUInt16BE
        
        // Assert
        XCTAssertEqual(actualValue, 0x0304)
    }
    
    func testConsumeUInt8Valid() {
        
        do {
            let value = try scummFile.consumeUInt8
            XCTAssertEqual(value, 0x01)
            XCTAssertEqual(scummFile.currentPosition, 1)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testConsumeUInt8InsufficientData() {
        
        scummFile.currentPosition = 4
        
        XCTAssertThrowsError(try scummFile.consumeUInt8) { error in
            XCTAssertEqual(error as? ScummCoreError, ScummCoreError.insufficientData)
        }
    }
    
    func testConsumeUInt16LEValid() {
        
        do {
            
            let value = try scummFile.consumeUInt16LE
            XCTAssertEqual(value, 0x0201)
            XCTAssertEqual(scummFile.currentPosition, 2)
            
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testConsumeUInt16LEInsufficientData() {
        
        scummFile.currentPosition = 3
        
        XCTAssertThrowsError(try scummFile.consumeUInt16LE) { error in
            XCTAssertEqual(error as? ScummCoreError, ScummCoreError.insufficientData)
        }
    }

    func testConsumeUInt16BEValid() {
        
        do {
            let value: UInt16 = try scummFile.consumeUInt16BE
            XCTAssertEqual(value, 0x0102)
            XCTAssertEqual(scummFile.currentPosition, 2)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testConsumeUInt16BEInsufficientData() {
        
        scummFile.currentPosition = 3
        
        XCTAssertThrowsError(try scummFile.consumeUInt16BE) { error in
            XCTAssertEqual(error as? ScummCoreError, ScummCoreError.insufficientData)
        }
    }

    func testConsumeUInt32LEValid() {
        
        do {
            let value: UInt32 = try scummFile.consumeUInt32LE
            XCTAssertEqual(value, 0x04030201)
            XCTAssertEqual(scummFile.currentPosition, 4)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testConsumeUInt32LEInsufficientData() {
        scummFile.currentPosition = 1
        
        XCTAssertThrowsError(try scummFile.consumeUInt32LE) { error in
            XCTAssertEqual(error as? ScummCoreError, ScummCoreError.insufficientData)
        }
    }

    func testConsumeUInt32BEValid() {
        do {
            let value: UInt32 = try scummFile.consumeUInt32BE
            XCTAssertEqual(value, 0x01020304)
            XCTAssertEqual(scummFile.currentPosition, 4)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testConsumeUInt32BEInsufficientData() {
        scummFile.currentPosition = 1
        
        XCTAssertThrowsError(try scummFile.consumeUInt32BE) { error in
            XCTAssertEqual(error as? ScummCoreError, ScummCoreError.insufficientData)
        }
    }
    
    func testIsNotEndOfFileWhenLoaded() {
        XCTAssertFalse(scummFile.isEndOfFile, "File position should not be at the end initially")
    }
    
    func testIsEndOfFileAfterReadingData() {
        
        _ = try? scummFile.consumeUInt32LE
        
        XCTAssertTrue(scummFile.isEndOfFile, "File position should be at the end after reading all data")
    }
    
    func testIsEndOfFileWhenReadingBeyondEnd() {
        
        _ = try? scummFile.consumeUInt32LE
        _ = try? scummFile.consumeUInt8
        
        XCTAssertTrue(scummFile.isEndOfFile, "File position should remain at the end when attempting to read beyond it")
    }
}
