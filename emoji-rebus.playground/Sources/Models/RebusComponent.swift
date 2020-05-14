import Foundation

enum RebusComponent: Codable {
    case text(String)
    case emoji(Character)
    case plus
    case minus(String)
    
    enum CodingKeys: String, CodingKey {
        case type
        case value
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        let value = try container.decodeIfPresent(String.self, forKey: .value) ?? ""
        
        if type == "text" {
            self = .text(value)
        } else if type == "emoji" {
            guard let emojiCharacter = [Character](value).first else { fatalError("Could not get character") }
            self = .emoji(emojiCharacter)
        } else if type == "plus" {
            self = .plus
        } else if type == "minus" {
            self = .minus(value)
        } else {
            fatalError("Unrecognized type")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        let value: String?
        let type: String
        switch self {
        case .text(let text):
            value = text
            type = "text"
        case .emoji(let emoji):
            value = String(emoji)
            type = "emoji"
        case .plus:
            value = nil
            type = "plus"
        case .minus(let text):
            value = text
            type = "minus"
        }
        try container.encodeIfPresent(value, forKey: .value)
        try container.encode(type, forKey: .type)
    }
}
