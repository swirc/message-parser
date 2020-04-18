import XCTest

@testable import SWIRCMessageParser

class IRCMessageParserTests: XCTestCase {
    private var parser: IRCMessageParser!

    override func setUpWithError() throws {
        parser = IRCMessageParser()
    }

    func testParseServer() throws {
        let message = parser.parse(rawMessage: ":server FOO")
        XCTAssertEqual(message!.server, "server")
    }
    
    func testParseNickHost() throws {
        let message = parser.parse(rawMessage: ":nick@host FOO")
        XCTAssertEqual(message!.nick, "nick")
        XCTAssertEqual(message!.host, "host")
    }
    
    func testParseNickUserHost() throws {
        let message = parser.parse(rawMessage: ":nick!user@host FOO")
        XCTAssertEqual(message!.nick, "nick")
        XCTAssertEqual(message!.user, "user")
        XCTAssertEqual(message!.host, "host")
    }
    
    func testParseCommand() throws {
        let message = parser.parse(rawMessage: ":nick@host FOO")
        XCTAssertEqual(message!.command, "FOO")
    }
    
    func testParseCommandNumeric() throws {
        let message = parser.parse(rawMessage: ":nick@host 333")
        XCTAssertEqual(message!.command, "333")
    }
    
    func testParseCommandNumericTooShort() throws {
        XCTAssertNil(parser.parse(rawMessage: ":nick@host 22"))
    }
    
    func testParseCommandNumericTooLong() throws {
        XCTAssertNil(parser.parse(rawMessage: ":nick@host 4444"))
    }
    
    func testParseParams() throws {
        let message = parser.parse(rawMessage: ":nick@host FOO param1 param2 :trailing param with spaces")
        XCTAssertEqual(message!.params, ["param1", "param2", "trailing param with spaces"])
    }
    
    func testParseTooManyParams() throws {
        XCTAssertNil(parser.parse(rawMessage: ":nick@host FOO 0 1 2 3 4 5 6 7 8 9 a b c d e f"))
    }
    
    func testParseTooLongMessage() throws {
        XCTAssertNil(parser.parse(rawMessage: String(repeating: "a", count: 511)))
    }
}
