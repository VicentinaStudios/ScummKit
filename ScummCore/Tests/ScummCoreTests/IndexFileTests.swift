//
//  IndexFileTests.swift
//  
//
//  Created by Michael Borgmann on 15/09/2023.
//

import XCTest
@testable import ScummCore

final class IndexFileTests: XCTestCase {
    
    
    func testScummV2IndexFile() throws {
        
        guard
            let path = TestHelper.gameInfo?.first(where: { $0.version == .v2 })?.path
        else {
            _ = XCTSkip("No SCUMM v2 game found.")
            return
        }
        
        let gameDirectoryURL = URL(filePath: path)
        
        let indexFile = try IndexFileV2(at: gameDirectoryURL)
    }
    
    func testScummV3IndexFile() throws {
        
        guard
            let path = TestHelper.gameInfo?.first(where: { $0.version == .v3 })?.path
        else {
            _ = XCTSkip("No SCUMM v3 game found.")
            return
        }
        
        let gameDirectoryURL = URL(filePath: path)
        
        let indexFile = try IndexFileV3(at: gameDirectoryURL)
    }
    
    func testScummV6IndexFile() throws {
        
        guard
            let path = TestHelper.gameInfo?.first(where: { $0.version == .v6 })?.path
        else {
            _ = XCTSkip("No SCUMM v6 game found.")
            return
        }
        
        let gameDirectoryURL = URL(filePath: path)
        
        let indexFile = try IndexFileV6(at: gameDirectoryURL)
    }
}
