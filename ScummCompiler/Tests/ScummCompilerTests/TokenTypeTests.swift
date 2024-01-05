import XCTest
@testable import ScummCompiler

final class ScummCompilerTests: XCTestCase {
    
    func testLeftParenthesesTokenTypeExist() throws {
        
        XCTAssertTrue(TokenType.allCases.contains(.leftParen))
        XCTAssertTrue(TokenType.allCases.contains(.rightParen))
    }
}
