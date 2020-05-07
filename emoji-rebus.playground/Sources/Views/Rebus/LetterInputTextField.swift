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
        backgroundColor = .white
        
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        layer?.cornerRadius = 5.0
        layer?.borderWidth = 3.0
        layer?.borderColor = ColorStyle.gray.cgColor
        focusRingType = .none
        font = NSFont.systemFont(ofSize: 30.0)
    }
}
