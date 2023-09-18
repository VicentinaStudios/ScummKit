import XCTest
@testable import ScummCore

// MARK: - Unit Tests

import XCTest

class ScummCoreTests: XCTestCase {
    
    var gameDirectoryURL: URL!
    
    var version: ScummVersion!
    
    override func setUp() {
        
        super.setUp()
        
        self.version = .v5
        
        guard let path = TestHelper.gameInfo?.first?.path else {
            XCTFail("No game path found")
            fatalError()
        }
        
        gameDirectoryURL = URL(filePath: path)
    }
    
    override func tearDown() {
        
        version = nil
        gameDirectoryURL = nil
        
        super.tearDown()
    }
    
    func testInitialization() throws {
        
        let scummCore = try ScummCore(gameDirectory: gameDirectoryURL, version: version)
        
        XCTAssertEqual(scummCore.gameDirectoryURL, gameDirectoryURL)
        XCTAssertEqual(scummCore.version, version)
    }
    
    /*
    func testIndexFileLoading() throws {
        
        let scummCore = try ScummCore(gameDirectory: gameDirectoryURL, version: version)
        
        try scummCore.loadIndexFile()
        
        XCTAssertNotNil(scummCore.indexFile)
    }
    */
}
    
    /*
    func testInitializationThrowsError() {
        
        let invalidURL = URL(fileURLWithPath: "/invalid/path")
        let version: ScummVersion = .v6
        
        do {
            let scummCore = try ScummCore(gameDirectory: invalidURL, version: version)
            XCTFail("Expected an error to be thrown")
        } catch let error as ScumeCoreError {
            XCTAssertEqual(error, ScumeCoreError.noIndexFileFound(invalidURL.path))
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
    */
