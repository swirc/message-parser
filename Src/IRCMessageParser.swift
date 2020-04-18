import Foundation

final public class IRCMessageParser {
    public init() {}

    public func parse(rawMessage: String) -> Optional<IRCMessage> {
        if rawMessage.count > 510 {
            return .none
        }
        
        var message = IRCMessage()
        var data = rawMessage.trimmingCharacters(in: .whitespacesAndNewlines)
        if data.first == ":" {
            data.removeFirst()

            let prefix = String(data.prefix { (char: Character) -> Bool in
                char != " "
            })

            data.removeFirst(prefix.count + 1)

            if prefix.firstIndex(of: "@") != nil {
                var parts = prefix.split(separator: "@")
                let name = String(parts.removeFirst())
                if name.firstIndex(of: "!") != nil {
                    var nameParts = name.split(separator: "!")
                    message.nick = String(nameParts.removeFirst())
                    message.user = String(nameParts.removeFirst())
                } else {
                    message.nick = .some(name)
                }
                
                message.host = .some(String(parts.removeFirst()))
            } else {
                message.server = .some(prefix)
            }
        }
        
        if let command = parseCommand(data: data) {
            message.command = command
            data.removeFirst(command.count)
            if data.first == " " {
                data.removeFirst()
            }
        } else {
            return .none
        }
        
        if let params = parseParams(data: &data) {
            message.params = params
         } else {
            return .none
         }

        return .some(message)
    }
    
    private func parseCommand(data: String) -> Optional<String> {
        if data.first!.isNumber {
            let command = data.prefix { (char: Character) -> Bool in
                char.isNumber
            }
            
            if command.count == 3 {
                return .some(String(command))
            }
            
            return .none
        }

        return String(data.prefix { (char: Character) -> Bool in
            char != " "
        })
    }
    
    private func parseParams(data: inout String) -> Optional<[String]> {
        var params: [String] = []
        while let char = data.first {
            if char == " " {
                data.removeFirst()
            } else if char == ":" {
                data.removeFirst()
                params.append(data)
                
                return .some(params)
            } else {
                let param = String(data.prefix(while: { (char: Character) -> Bool in
                    char != " "
                }))

                data.removeFirst(param.count)
                params.append(param)
            }
            
            if params.count > 15 {
                return .none
            }
        }

        return .some(params)
    }
}
