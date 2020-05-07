import AppKit

final public class DifficultyView: NSTextField {
    var difficulty: Rebus.Difficulty? {
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
        isEditable = false
        alignment = .center
        wantsLayer = true
        layer?.backgroundColor = ColorStyle.darkGray.cgColor
        sizeToFit()
        usesSingleLineMode = false
    }
    
    private func configure() {
        guard let difficulty = difficulty else {
            self.isHidden = true
            return
        }
        
        isHidden = false
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        
        let commonAttrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: ColorStyle.white,
            .font: NSFont.systemFont(ofSize: 18.0),
            .paragraphStyle: paragraphStyle
        ]
        
        let attributedString = NSMutableAttributedString(string: "Difficulty: ")
        
        let range = NSRange(location: 0, length: attributedString.length)
        attributedString.addAttributes(commonAttrs, range: range)
        
        let difficultyColor: NSColor
        switch difficulty {
        case .easy: difficultyColor = .green
        case .medium: difficultyColor = .yellow
        case .hard: difficultyColor = .red
        }
        
        attributedString.append(.init(string: difficulty.rawValue, attributes: [
            .foregroundColor: difficultyColor,
            .font: NSFont.systemFont(ofSize: 22.0),
        ]))
        attributedStringValue = attributedString
    }
}
