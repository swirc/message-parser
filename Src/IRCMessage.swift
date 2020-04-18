public struct IRCMessage {
    public var server: Optional<String> = .none
    public var nick: Optional<String> = .none
    public var user: Optional<String> = .none
    public var host: Optional<String> = .none
    public var command: String = ""
    public var params: [String] = []
    
    public init() {}
}
