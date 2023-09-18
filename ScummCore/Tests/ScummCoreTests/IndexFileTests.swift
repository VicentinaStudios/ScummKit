//
//  IndexFileTests.swift
//  
//
//  Created by Michael Borgmann on 15/09/2023.
//

import XCTest
@testable import ScummCore

final class IndexFileTests: XCTestCase {
    
    func testScummV4IndexFile() throws {
        
        guard
            let path = TestHelper.gameInfo?.first(where: { $0.version == .v4 })?.path
        else {
            _ = XCTSkip("No SCUMM v4 game found.")
            return
        }
        
        let gameDirectoryURL = URL(filePath: path)
        
        let indexFile = try IndexFileV4(at: gameDirectoryURL)
    }
    
    func testScummV5IndexFile() throws {
        
        guard
            let path = TestHelper.gameInfo?.first(where: { $0.version == .v5 })?.path
        else {
            _ = XCTSkip("No SCUMM v5 game found.")
            return
        }
        
        let gameDirectoryURL = URL(filePath: path)
        
        let indexFile = try IndexFileV5(at: gameDirectoryURL)
    }
}
