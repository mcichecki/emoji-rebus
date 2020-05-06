import Foundation

struct Rebus {
    var components: [RebusComponent]
    var answer: String
    
    var numberOfLetters: Int { answer.count }
    
    public init(_ components: [RebusComponent], ans: String) {
        self.components = components
        answer = ans
    }
}

enum RebusComponent {
    case text(String)
    case emoji(Character)
    case plus
    case minus(String)
}

enum RebusStorage {
    static let rebuses: [Rebus] = [
        (.init([.emoji("🐺"), .minus("olf"), .plus, .minus("ki"), .emoji("🥝"), .minus("i"), .plus, .emoji("🎲"), .minus("ie")], ans: "wwdc")),
//        (.init([.emoji("🧺"), .plus, .emoji("🏐")], ans: "basketball")),
        (.init([.emoji("🍏"), .minus("le")], ans: "app")),
        (.init([.text("re"), .plus, .emoji("🚌")], ans: "rebus")),
    ]
}
