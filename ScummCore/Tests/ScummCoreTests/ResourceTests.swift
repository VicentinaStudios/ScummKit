//
//  ResourceTests.swift
//  
//
//  Created by Michael Borgmann on 21/09/2023.
//

import XCTest
@testable import ScummCore

final class ResourceTests: XCTestCase {
    
    let roomNumbers = [1, 2, 3]
    let offsets = [100, 200, 300]
    
    func testDirectoryEntry() {
        
        let entry = Resources.DirectoryEntry(roomNumber: 42, offset: 100)
        
        XCTAssertEqual(entry.roomNumber, 42, "Room number should be 42")
        XCTAssertEqual(entry.offset, 100, "Offset should be 100")
    }
    
    func testNumberOfEntries() {
        
        let entries = Resources.DirectoryEntry.convert(roomNumbers: roomNumbers, offsets: offsets)
        
        XCTAssertEqual(entries.count, 3, "There should be 3 directory entries")
    }
    
    func testDirectoryEntryProperties() {
        
        let entries = Resources.DirectoryEntry.convert(roomNumbers: roomNumbers, offsets: offsets)
        
        XCTAssertEqual(entries[0].roomNumber, 1, "Room number in the first entry should be 1")
        XCTAssertEqual(entries[0].offset, 100, "Offset in the first entry should be 100")
        
        XCTAssertEqual(entries[1].roomNumber, 2, "Room number in the second entry should be 2")
        XCTAssertEqual(entries[1].offset, 200, "Offset in the second entry should be 200")
        
        XCTAssertEqual(entries[2].roomNumber, 3, "Room number in the third entry should be 3")
        XCTAssertEqual(entries[2].offset, 300, "Offset in the third entry should be 300")
    }
}
