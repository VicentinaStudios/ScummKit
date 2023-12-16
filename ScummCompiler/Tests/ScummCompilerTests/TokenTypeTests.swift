import XCTest
@testable import ScummCompiler

final class ScummCompilerTests: XCTestCase {
    
    func testLeftParenthesesTokenTypeExist() throws {
        
        XCTAssertTrue(TokenType.allCases.contains(.lparen))
        XCTAssertTrue(TokenType.allCases.contains(.rparen))
    }
}
