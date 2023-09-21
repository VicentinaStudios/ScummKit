//
//  BlockTypeTests.swift
//  
//
//  Created by Michael Borgmann on 17/09/2023.
//

import XCTest
@testable import ScummCore

class BlockTypeTests: XCTestCase {
    
    // MARK: - Initialization Tests
    
    func testInitializationWithRN() {
        XCTAssertEqual(BlockType(rawValue: "RN"), .roomNames)
    }
    
    func testInitializationWithRNAM() {
        XCTAssertEqual(BlockType(rawValue: "RNAM"), .roomNames)
    }
    
    func testInitializationWith0R() {
        XCTAssertEqual(BlockType(rawValue: "0R"), .directoryOfRooms)
    }
    
    func testInitializationWithDROO() {
        XCTAssertEqual(BlockType(rawValue: "DROO"), .directoryOfRooms)
    }
    
    func testInitializationWith0S() {
        XCTAssertEqual(BlockType(rawValue: "0S"), .directoryOfScripts)
    }
    
    func testInitializationWithDSCR() {
        XCTAssertEqual(BlockType(rawValue: "DSCR"), .directoryOfScripts)
    }
    
    func testInitializationWith0N() {
        XCTAssertEqual(BlockType(rawValue: "0N"), .directoryOfSounds)
    }
    
    func testInitializationWithDSOU() {
        XCTAssertEqual(BlockType(rawValue: "DSOU"), .directoryOfSounds)
    }
    
    func testInitializationWith0C() {
        XCTAssertEqual(BlockType(rawValue: "0C"), .directoryOfCostumes)
    }
    
    func testInitializationWithDCOS() {
        XCTAssertEqual(BlockType(rawValue: "DCOS"), .directoryOfCostumes)
    }
    
    func testInitializationWith0O() {
        XCTAssertEqual(BlockType(rawValue: "0O"), .directoryOfObjects)
    }
    
    func testInitializationWithDOBJ() {
        XCTAssertEqual(BlockType(rawValue: "DOBJ"), .directoryOfObjects)
    }
    
    func testInitializationWithUnknown() {
        XCTAssertEqual(BlockType(rawValue: "unknown"), .unknown)
    }
}
