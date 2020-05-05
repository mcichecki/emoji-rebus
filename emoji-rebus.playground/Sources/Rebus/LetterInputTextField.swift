import AppKit

final class LetterInputTextField: NSTextField {
    init() {
        super.init(frame: .zero)
        
        setUp()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setUp() {
        alignment = .center
        backgroundColor = .white
        
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        layer?.cornerRadius = 5.0
        layer?.borderWidth = 2.0
        layer?.borderColor = NSColor.darkGray.cgColor
        focusRingType = .none
        font = NSFont.systemFont(ofSize: 30.0)
    }
}
