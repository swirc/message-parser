public struct IRCMessage {
    var server: Optional<String> = .none
    var nick: Optional<String> = .none
    var user: Optional<String> = .none
    var host: Optional<String> = .none
    var command: String = ""
    var params: [String] = []
    
    init() {}
}
