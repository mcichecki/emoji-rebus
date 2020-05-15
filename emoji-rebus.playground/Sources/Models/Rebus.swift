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
        if input.lowercased() == answer.title.lowercased() { return true}
        return false
    }
}

// TODO: Remove
public enum RebusStorage {
    // https://gist.github.com/rxaviers/7360908
    public static let rebuses: [Rebus] = [
        
        .init(
            .text("a"), .plus, .minus("war"), .emoji("⚠️"), .minus("ng"), .plus, .minus("to"), .emoji("🍅"), .minus("to"), .plus, .text("ls"),
            ans: "animals",
            description: """
            Every day, 50 to 100 species of plants and animals become extinct because of human activities.

            In order to slow or prevent the extinction of further animal species, organizations are establishing programs to protect their habitat.
            """
        ),
        .init(
            .minus("ta"), .emoji("🌮"), .plus, .emoji("2️⃣"),
            ans: "co2",
            description: """
            The gas formed when carbon is burned or when people and animals breathe out.

            Increasing levels of carbon dioxide in the atmosphere are linked to global warming.
            """
        ),
        .init(
            .text("pla"), .plus, .minus("ham"), .emoji("🐹"), .minus("er"), .plus, .emoji("🧊"), .minus("e"),
            ans: "plastic",
            description: """
            The world uses 160,000 plastic bags every second which affect animals life.

            Try to reduce using plastic bags and buying bottled water.
            """
        ),
        .init(
            .text("fo"), .plus, .minus("d"), .emoji("👗"), .minus("s"), .plus, .text("t"),
            ans: "forest",
            description: """
            Forests around the world are cut and burned but a lot of living creatures depend on them.

            They absorb carbon and provide habitat for wildlife.
            """
        ),
        .init(
            .text("w"), .plus, .emoji("🏧"), .minus("m"), .plus, .text("er"),
            ans: "water",
            description: """
            Water is essential to life but only 3% of our planet’s water is drinkable, rest is salt water.


            Polluted water is of great concern to the aquatic organism, plants, humans and climate.
            """
        ),
        .init(
            .emoji("⌚️"), .minus("tch"), .plus, .emoji("⭐️"), .minus("ar"), .plus, .text("e"),
            ans: "waste",
            description: """
            Solid waste affects climate change through landfill methane emission.

            The manufacturing, distribution and use of products as well as waste, affect the Earth’s climate.
            """
        ),
        .init(
            .minus("c"), .emoji("🧢"), .plus, .text("p"), .plus, .minus("turt"), .emoji("🐢"),
            ans: "apple",
            description: """
            Apple is a company which greatly focuses on environment.

            As part of its commitment to combat climate change and create a healthier environment, 100% of its global facilties are powered with clean energy and their newest products are made from 100% recycled aluminum.
            """
        ),
        .init(
            .emoji("☁️"), .minus("oud"), .plus, .text("im"), .plus, .minus("c"), .emoji("🐱"), .plus, .text("e"),
            ans: "climate",
            description: """
            Global climate change has already had observable effects on the environment.

            Glaciers have shrunk, ice on rivers and lakes is breaking up earlier, plant and animal ranges have shifted and trees are flowering sooner.
            """
        ),
        .init(
            .text("env"), .plus, .minus("f"), .emoji("🔥"), .minus("e"), .plus, .text("onm"), .plus, .minus("t"), .emoji("⛺️"),
            ans: "environment",
            description: """
            The surroundings or conditions in which people, animals and plants live.

            There are many ways that we can protect out planet - use reusable bags, recycle, save water and many more.
            """
        ),
        .init(
            .text("e"), .plus, .emoji("🐄"), .minus("w"), .plus, .emoji("🔒"), .minus("ck"), .plus, .text("gy"),
            ans: "ecology",
            description: """
            The branch of biology that deals with the relations of organisms and their physical surroundings.

            Ecologists examine how living things depend on one another.
            """
        ),
        .init(
            .text("e"), .plus, .emoji("🌽"), .minus("rn"), .plus, .text("syst"), .plus, .minus("g"), .emoji("💎"),
            ans: "ecosystem",
            description: """
            A biological community of interacting organisms and their physical environment.

            Future climate change is expected to further affect many ecosystems.
            """
        ),
        .init(
            .minus("fi"), .emoji("🔥"), .plus, .minus("motor"), .emoji("🏍"), .minus("e"), .plus, .text("ing"),
            ans: "recycling",
            description: """
            Conversion of waste into reusable material is very important.

            Make sure you’re putting the right materials in your recycling container.
            """
        ),
        .init(
            .emoji("🚲"), .minus("ke"), .plus, .text("odeg"), .plus, .emoji("📻"), .minus("io"), .plus, .text("able"),
            ans: "biodegradable",
            description: """
            For example biodegradable packaging is capable of being decomposed by bacteria which help avoid pollution.
            """
        ),
        .init(
            .text("p"), .plus, .minus("l"), .emoji("🍭"), .minus("ipop"), .plus, .text("u"), .plus, .minus("sta"), .emoji("🚉"),
            ans: "pollution",
            description: """
            The presence of a substance in the environment which is harmful and has posonous effect on the environment.
            """
        ),
        .init(
            .text("oz"), .plus, .emoji("1️⃣"),
            ans: "ozone",
            description: """
            Ozone molecules in the atmosphere provide us with protection from the sun rays.

            Banning the chemicals is constantly decreasing the ozone hole.
            """
        )
    ]
    
    // TODO: Remove
    public static let testRebuses: [Rebus] = [
        (.init(.emoji("🍏"), .minus("le"), ans: "app")),
        (.init(.emoji("🐺"), .minus("olf"), .plus, .minus("ki"), .emoji("🥝"), .minus("i"), .plus, .emoji("🎲"), .minus("ie"), ans: "wwdc")),
        //        (.init(.emoji("🧺"), .plus, .emoji("🏐"), ans: "basketball")),
        (.init(.text("re"), .plus, .emoji("🚌"), ans: "rebus")),
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
 - apple ✅
 - science ✅
 - climate ✅
 - environment ✅
 - ecology ✅
 - ecosystem ✅
 - recycle ✅
 */
