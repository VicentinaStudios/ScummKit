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
    
    func testReadConstantInvalidIndex() {
        
        XCTAssertThrowsError(try chunk.readConstant(at: 0)) { error in
            XCTAssertEqual(error as? ChunkError, ChunkError.invalidConstantIndex(0, 0))
        }
        
        XCTAssertThrowsError(try chunk.readConstant(at: 1)) { error in
            XCTAssertEqual(error as? ChunkError, ChunkError.invalidConstantIndex(1, 0))
        }
    }
    
    func testReadWord() throws {
        
        try chunk.write(byte: 0x12, line: 1)
        try chunk.write(byte: 0x34, line: 1)
        
        let word = try chunk.readWord(at: 0)
        
        XCTAssertEqual(word, 0x3412)
    }
    
    func testReadWordOutOfBounds() {
        XCTAssertThrowsError(try chunk.readWord(at: 0)) { error in
            XCTAssertEqual(error as? ChunkError, ChunkError.outOfBounds("word", 0, 0))
        }
    }
    
    func testReadWordInsufficientBytes() {
        
        try? chunk.write(byte: 0xAA, line: 1)
        
        XCTAssertThrowsError(try chunk.readWord(at: 0)) { error in
            XCTAssertEqual(error as? ChunkError, ChunkError.insufficientBytes("word", 0, 1))
        }
    }
    
    func testLineNumbers() throws {
        
        try chunk.write(byte: 0xAA, line: 1)
        try chunk.write(byte: 0xBB, line: 2)
        try chunk.write(byte: 0xCC, line: 3)

        XCTAssertEqual(chunk.lines, [1, 2, 3])
    }

    func testConstants() {
        
        let index1 = chunk.addConstant(value: .int(42))
        let index2 = chunk.addConstant(value: .int(55))

        XCTAssertEqual(index1, 0)
        XCTAssertEqual(index2, 1)

        if case let .int(first) = try? chunk.readConstant(at: 0),
           case let .int(second) = try? chunk.readConstant(at: 1)
        {
            XCTAssertEqual(first, 42)
            XCTAssertEqual(second, 55)
        } else {
            XCTFail("Can't get value from constant.")
            return
        }
    }

    func testReadConstantOutOfBounds() {
        
        XCTAssertThrowsError(try chunk.readConstant(at: -1)) { error in
            XCTAssertEqual(error as? ChunkError, ChunkError.invalidConstantIndex(-1, 0))
        }

        XCTAssertThrowsError(try chunk.readConstant(at: Int.max)) { error in
            XCTAssertEqual(error as? ChunkError, ChunkError.invalidConstantIndex(Int.max, 0))
        }
    }

    func testReadLineNumberOutOfBounds() {
        
        XCTAssertThrowsError(try chunk.read(at: -1)) { error in
            XCTAssertEqual(error as? ChunkError, ChunkError.outOfBounds("byte", -1, 0))
        }

        XCTAssertThrowsError(try chunk.read(at: Int.max)) { error in
            XCTAssertEqual(error as? ChunkError, ChunkError.outOfBounds("byte", Int.max, 0))
        }
    }
}
