import Foundation

public struct Rebus: Codable {
    enum Difficulty: Int, CaseIterable {
        case easy = 1, medium, hard
        
        var stars: String { Array<String>(repeating: "⭐️", count: rawValue).joined() }
    }
    
    var components: [RebusComponent]
    
    var answer: Answer
    
    var numberOfLetters: Int { answer.title.count }
    
    var emojis: [String] {
        components
            .compactMap {
                guard case let .emoji(emojiCharacter) = $0 else { return nil }
                return String(emojiCharacter)
        }
    }
    
    var difficultyLevel: Difficulty {
        let numberOfComponents = components.count
        switch numberOfComponents {
        case 0...7: return .easy
        case 7...9: return .medium
        default: return .hard
        }
    }
    
    init(_ components: RebusComponent..., ans: String, description: String = "") {
        self.components = components
        self.answer = Answer(title: ans, description: description)
    }
    
    func valid(input: String) -> Bool {
        if input.lowercased() == answer.title.lowercased() { return true }
        return false
    }
}
