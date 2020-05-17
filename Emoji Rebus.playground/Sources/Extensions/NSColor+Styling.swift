import AppKit

// https://flatuicolors.com/palette/us

extension NSColor {
    static func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, alpha: CGFloat = 1.0) -> NSColor {
        .init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
    }
}
