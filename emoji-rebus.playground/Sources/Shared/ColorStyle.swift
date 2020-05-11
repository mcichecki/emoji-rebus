import AppKit

// https://flatuicolors.com/palette/us

enum ColorStyle {
    static let darkGray: NSColor = .rgb(83, 92, 104)
    static let red: NSColor = .rgb(214, 48, 49)
    static let green: NSColor = .rgb(0, 184, 148)
    static let white: NSColor = .white
    static let black: NSColor = .black
    
    static let backgroundColors: [NSColor] = Background.allColors
    
    // MARK: - Background colors
    
    enum Background: CaseIterable {
        case darkGreen
        case darkOcean
        case darkBlue
        case darkPurple
        case darkOrange
        case darkRed
        case darkGray
        
        var color: NSColor {
            switch self {
            case .darkGreen: return .rgb(0, 184, 148) // Mint Leaf
            case .darkOcean: return .rgb(0, 206, 201) // Robin's Egg Blue
            case .darkBlue: return .rgb(9, 132, 227) // Electron Blue
            case .darkPurple: return .rgb(108, 92, 231) // Exodus Fruit
            case .darkOrange: return .rgb(225, 112, 85) // Orangeville
            case .darkRed: return .rgb(214, 48, 49) // Chi Gong
            case .darkGray: return .rgb(178, 190, 195) // Soothing Breeze
            }
        }
        
        static let allColors = allCases.map { $0.color }
    }
}
