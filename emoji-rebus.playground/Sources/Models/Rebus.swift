import Foundation

public struct Rebus: Codable {
    enum Difficulty: String, CaseIterable {
        case easy, medium, hard
    }
    
    var components: [RebusComponent]

    var answer: Answer
    
    var numberOfLetters: Int { answer.title.count }
    
    var difficultyLevel: Difficulty { Difficulty.allCases.randomElement() ?? .easy } // TODO: add some "algorithm"
    
    // TODO: Add init with args...
    init(_ components: [RebusComponent], ans: String, description: String = "") {
        self.components = components
        self.answer = Answer(title: ans, description: description)
    }
    
    func valid(input: String) -> Bool {
        if input.lowercased() == answer.title.lowercased() { return true}
        return false
    }
}

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

public enum RebusStorage {
    // https://gist.github.com/rxaviers/7360908 (Google Chrome search)
    public static let rebuses: [Rebus] = [
        // TODO: Ice Cube emoji: https://emojipedia.org/ice-cube/
        // TODO: SHould we have:
        // 🍈 - melon
        // minus me + 🍈 + minus on = l
        // or
        // 🍈 + minus meon = l
        .init([.text("pla"), .plus, .emoji("🚉"), .minus("ation"), .plus, .emoji("🧊"), .minus("e")],
              ans: "plastic", description: "..."),
        .init([.emoji("⛲️"), .minus("untain"), .plus, .emoji("🚻"), .minus("room")],
              ans: "forest", description: "..."),
        .init([.text("w"), .plus, .emoji("🏧"), .minus("m"), .plus, .text("er")],
              ans: "water", description: "..."),
        .init([.emoji("⌚️"), .minus("tch"), .plus, .emoji("⭐️"), .minus("ar"), .plus, .text("e")],
              ans: "waste", description: "..."),
        .init([.text("a"), .plus, .emoji("9️⃣"), .minus("ne"), .plus, .emoji("🍅"), .minus("toto"), .plus, .text("l")],
              ans: "animal", description: "..."),
        .init([.minus("ta"), .emoji("🌮"), .plus, .emoji("2️⃣")],
              ans: "co2", description: "...")
    ]
    
    public static let testRebuses: [Rebus] = [
        (.init([.emoji("🍏"), .minus("le")], ans: "app")),
        (.init([.emoji("🐺"), .minus("olf"), .plus, .minus("ki"), .emoji("🥝"), .minus("i"), .plus, .emoji("🎲"), .minus("ie")], ans: "wwdc")),
        //        (.init([.emoji("🧺"), .plus, .emoji("🏐")], ans: "basketball")),
        (.init([.text("re"), .plus, .emoji("🚌")], ans: "rebus")),
    ]
}

/*
 List of rebuses
 - plastic ✅
 - forest ✅
 - contamination
 - water ✅
 - waste ✅
 - animal ✅
 - co2 ✅
 */
