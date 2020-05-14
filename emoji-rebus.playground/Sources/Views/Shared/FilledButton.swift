import AppKit

enum ButtonActionType {
    case hint, listen
}

protocol FilledButtonDelegate: AnyObject {
    func didTap(_ type: ButtonActionType?)
}

final class FilledButton: NSButton {
    weak var buttonDelegate: FilledButtonDelegate?
    
    private var textColor: NSColor = .white {
        didSet { contentTintColor = textColor }
    }
    
    var buttonTitle: String = "" {
        didSet { title = buttonTitle }
    }
    
    var actionType: ButtonActionType?
    
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
    
    func setState(enabled: Bool) {
        isEnabled = enabled
        setBackground()
    }
    
    func setUp() {
        isBordered = false
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
        guard isEnabled else { return }
        buttonDelegate?.didTap(actionType)
        setBackgroundColor(ColorStyle.white.withAlphaComponent(0.8))
    }
    
    override func mouseUp(with event: NSEvent) {
        setBackground()
    }
    
    private func setBackground() {
        setBackgroundColor(ColorStyle.white.withAlphaComponent(isEnabled ? 1.0 : 0.5))
    }
}
