import AppKit

final class RebusLabel: NSTextField {
    var rebus: Rebus? {
        didSet {
            configure()
        }
    }
    
    init() {
        super.init(frame: .zero)
        
        setUp()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setUp() {
        backgroundColor = .white
        isBezeled = false
        isEditable = false
        alignment = .center
        wantsLayer = true
        
        sizeToFit()
    }
    
    private func configure() {
        guard let rebus = rebus else { return }
        let attributedString = NSMutableAttributedString(string: "")
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        
        let commonAttrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: NSColor.black,
            .font: NSFont.systemFont(ofSize: 34.0),
            .paragraphStyle: paragraphStyle
        ]
        
        for component in rebus.components {
            var componentAttributedString: NSMutableAttributedString
            switch component {
            case .text(let text):
                componentAttributedString = .init(string: text)
            case .emoji(let emoji):
                componentAttributedString = .init(string: String(emoji))
            case .plus:
                componentAttributedString = .init(string: " + ")
            case .minus(let removedText):
                componentAttributedString = .init(string: removedText, attributes: [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    .strikethroughColor: NSColor.red.withAlphaComponent(0.5)
                ])
            }
            
            let range = NSRange(location: 0, length: componentAttributedString.length)
            componentAttributedString.addAttributes(commonAttrs, range: range)
            
            attributedString.append(componentAttributedString)
            
            attributedStringValue = attributedString
        }
    }
}
