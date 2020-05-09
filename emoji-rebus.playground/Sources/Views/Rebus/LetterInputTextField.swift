import AppKit

final class LetterInputTextField: NSTextField {
    private(set) var focused = false
    
    init() {
        super.init(frame: .zero)
        setUp()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func becomeFirstResponder() -> Bool {
        let firstResponder = super.becomeFirstResponder()
        if firstResponder { focused = true }
        return firstResponder
    }
    
    override func textDidEndEditing(_ notification: Notification) {
        super.textDidEndEditing(notification)
        focused = false
    }
    
    private func setUp() {
        alignment = .center
        textColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        layer?.cornerRadius = 5.0
        layer?.borderWidth = 2.0
        layer?.borderColor = ColorStyle.white.cgColor
        layer?.backgroundColor = NSColor.rgb(83, 92, 104, alpha: 0.5).cgColor
        focusRingType = .none
        font = .systemFont(ofSize: 30.0)
    }
}
