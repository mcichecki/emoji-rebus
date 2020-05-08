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
    
    static let backgroundColors: [NSColor] = [
        Background.ocean,
        Background.blue
    ]
    
    // MARK: - Background colors
    
    enum Background {
        static let ocean: NSColor = .rgb(0, 206, 201)
        static let blue: NSColor = .rgb(9, 132, 227)
    }
}
