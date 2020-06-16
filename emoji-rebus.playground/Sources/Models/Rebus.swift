import Foundation

/*
 Links
 - https://www.myenglishpages.com/site_php_files/vocabulary-lesson-environment.php
 - https://www.theworldcounts.com/stories/Facts-about-the-Environment
 - https://www.fastweb.com/student-life/articles/eight-simple-ways-to-help-the-environment
 */

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
        case 0...6: return .easy
        case 6...8: return .medium
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
        
        // print("--- type: \(type), value: \(value)")
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
            The gas formed when carbon is burned, or when people or animals breathe out.

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

            The manufacturing, distribution and use of products as well as waste generation result in GHG emissions and affect the Earth’s climate.
            """
        ),
        .init(
            .minus("gr"), .emoji("🍇"), .minus("es"), .plus, .text("p"), .plus, .minus("wha"), .emoji("🐋"),
            ans: "apple",
            description: """
            Apple is a company which greatly focuses on environment.

            As part of its commitment to combat climate change and create a healthier environment, 100% of its global facilties are powered with clean energy and their newest products are made from 100% recycled aluminum.
            """
        ),
        .init(
            .emoji("✂️"), .minus("ssors"), .plus, .text("ence"),
            ans: "science",
            description: """

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
            ans: "ecology", // TODO:
            description: """
            The branch of biology that deals with the relations of organisms and their physical surroundings.

            
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
            .minus("fi"), .emoji("🔥"), .plus, .minus("motor"), .emoji("🏍"), .minus("le"), .plus, .minus("turt"), .emoji("🐢"),
            ans: "recycle",
            description: """
            Conversion of waste into reusable material is very important.

            Make sure you’re putting the right materials in your recycling container.
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
