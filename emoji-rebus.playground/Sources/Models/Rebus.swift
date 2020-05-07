import Foundation

/*
 [
 {
 "components": [
 {
 "type": "emoji",
 "value": "🐺"
 },
 {
 "type": "minus",
 "value": "olf"
 }
 ],
 "answer": {
 "title": "test title",
 "description": "test description"
 }
 }
 ]
 */

struct Rebus: Decodable {
    var components: [RebusComponent]
    //    var answer: String
    var answer: Answer
    
    var numberOfLetters: Int { answer.title.count }
    
    init(_ components: [RebusComponent], ans: String) {
        self.components = components
        self.answer = Answer(title: ans, description: "empty description")
    }
    
    func valid(input: String) -> Bool {
        if input.lowercased() == answer.title.lowercased() { return true}
        return false
    }
}

enum RebusComponent: Decodable {
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
        
        print("--- type: \(type), value: \(value)")
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
}

enum RebusStorage {
    static let rebuses: [Rebus] = [
        (.init([.emoji("🍏"), .minus("le")], ans: "app")),
        (.init([.emoji("🐺"), .minus("olf"), .plus, .minus("ki"), .emoji("🥝"), .minus("i"), .plus, .emoji("🎲"), .minus("ie")], ans: "wwdc")),
        //        (.init([.emoji("🧺"), .plus, .emoji("🏐")], ans: "basketball")),
        (.init([.text("re"), .plus, .emoji("🚌")], ans: "rebus")),
    ]
}
