//
//  ChunkTests.swift
//  
//
//  Created by Michael Borgmann on 14/12/2023.
//

import XCTest
@testable import ScummCompiler

final class ChunkTests: XCTestCase {
    
    var chunk: Chunk!

    override func setUpWithError() throws {
        try super.setUpWithError()
        chunk = Chunk()
    }

    override func tearDownWithError() throws {
        chunk = nil
        try super.tearDownWithError()
    }
    
    func testChunkIsEmptyOnStart() throws {
        XCTAssertEqual(chunk?.size, 0)
    }

    
    func testWriteAndReadByte() throws {
        
        XCTAssertEqual(chunk.size, 0)
        
        try chunk.write(byte: 0xAA, line: 1)
        
        XCTAssertEqual(chunk.size, 1)
        
        let readByte = try chunk.read(at: 0)
        XCTAssertEqual(readByte, 0xAA)
    }
    
    func testReadOutOfBounds() {
        
        XCTAssertThrowsError(try chunk.read(at: 0)) { error in
            XCTAssertEqual(error as? ChunkError, ChunkError.outOfBounds("byte", 0, 0))
        }
    }
    
    func testReadNegativeOffset() {
        
        XCTAssertThrowsError(try chunk.read(at: -1)) { error in
            XCTAssertEqual(error as? ChunkError, ChunkError.outOfBounds("byte", -1, 0))
        }
    }
    
    func testMultipleWritesAndReads() throws {
        let chunk = Chunk()
        
        try chunk.write(byte: 0xAA, line: 1)
        try chunk.write(byte: 0xBB, line: 1)
        try chunk.write(byte: 0xCC, line: 1)
        
        XCTAssertEqual(chunk.size, 3)
        
        let byte1 = try chunk.read(at: 0)
        let byte2 = try chunk.read(at: 1)
        let byte3 = try chunk.read(at: 2)
        
        XCTAssertEqual(byte1, 0xAA)
        XCTAssertEqual(byte2, 0xBB)
        XCTAssertEqual(byte3, 0xCC)
    }
}
