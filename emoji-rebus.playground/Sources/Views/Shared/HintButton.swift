import AppKit

protocol HintButtonDelegate: AnyObject {
    func didTap()
}

final class HintButton: NSButton {
    weak var buttonDelegate: HintButtonDelegate?
    
    private var textColor: NSColor = .white {
        didSet { contentTintColor = textColor }
    }
    
    init() {
        super.init(frame: .zero)
        
        setUp()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override var intrinsicContentSize: NSSize {
        var size = super.intrinsicContentSize
        size.width += 7.0
        size.height += 5.0
        return size
    }
    
    func setUp() {
        isBordered = false
        title = "Hint"
        font = .systemFont(ofSize: 20.0)
        contentTintColor = ColorStyle.white
        setButtonType(.momentaryChange)
        alignment = .center
        setBackgroundColor(.white)
        layer?.cornerRadius = 5.0
    }
    
    func updateTextColor(_ color: NSColor) {
        textColor = color
    }
    
    override func mouseDown(with event: NSEvent) {
        buttonDelegate?.didTap()
        setBackgroundColor(NSColor.white.withAlphaComponent(0.8))
    }
    
    override func mouseUp(with event: NSEvent) {
        setBackgroundColor(.white)
    }
}
