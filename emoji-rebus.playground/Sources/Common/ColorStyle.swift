import AppKit

// https://flatuicolors.com/palette/us

enum ColorStyle {
    static let gray: NSColor = .rgb(99, 110, 114)
    static let darkGray: NSColor = .rgb(83, 92, 104)//.rgb(47, 54, 64)
    static let red: NSColor = .rgb(214, 48, 49)
    static let green: NSColor = .rgb(0, 184, 148)
    static let lightGreen: NSColor = .rgb(85, 239, 196)
    static let white: NSColor = .white
    static let black: NSColor = .black
    
    static let backgroundColors: [NSColor] = Background.allColors
    
    // MARK: - Background colors
    
    enum Background: CaseIterable {
        case darkOcean
        case darkBlue
        case darkGreen
        case darkPurple
        case darkYellow
        case darkOrange
        
        var color: NSColor {
            switch self {
            case .darkOcean: return .rgb(0, 206, 201) // Robin's Egg Blue
            case .darkBlue: return .rgb(9, 132, 227) // Electron Blue
            case .darkGreen: return .rgb(0, 184, 148) // Mint Leaf
            case .darkPurple: return .rgb(108, 92, 231) // Exodus Fruit
            case .darkYellow: return .rgb(253, 203, 110) // Bright Yarrow
            case .darkOrange: return .rgb(225, 112, 85) // Orangeville
            }
        }
        
        static let allColors = allCases.map { $0.color }
    }
}
