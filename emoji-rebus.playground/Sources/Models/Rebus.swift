import Foundation

struct Rebus {
    var components: [RebusComponent]
    
    public init(_ components: [RebusComponent]) {
        self.components = components
    }
}

enum RebusComponent {
    case text(String)
    case emoji(Character)
    case plus
    case minus(String)
}

enum RebusStorage {
    static let rebuses: [(rebus: Rebus, answer: String)] = [
        (.init([.emoji("🐺"), .minus("olf"), .plus, .minus("ki"), .emoji("🥝"), .minus("i"), .plus, .emoji("🎲"), .minus("ie")]), "wwdc"),
        (.init([.emoji("🧺"), .plus, .emoji("🏐")]), "basketball"),
        (.init([.emoji("🍏"), .minus("le")]), "app"),
        (.init([.text("re"), .plus, .emoji("🚌")]), "rebus"),
    ]
}
