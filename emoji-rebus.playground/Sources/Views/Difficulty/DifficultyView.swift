import AppKit

final public class DifficultyView: NSView {
    enum FontSize {
        static let regular: CGFloat = 20.0
    }
    
    var difficulty: Rebus.Difficulty? {
        didSet { configure() }
    }
    
    private lazy var textField = NSTextField()
    
    
    private let fontSize: CGFloat = 24.0
    
    init() {
        super.init(frame: .zero)
        
        setUp()
        addSubviews(textField)
        setUpConstraints()
        setUpTextField()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setUp() {
        wantsLayer = true
        layer?.backgroundColor = ColorStyle.darkGray.cgColor // TODO: Update
    }
    
    private func setUpConstraints() {
        textField.activateConstraints {
            [$0.centerXAnchor.constraint(equalTo: centerXAnchor),
             $0.centerYAnchor.constraint(equalTo: centerYAnchor),
             $0.heightAnchor.constraint(equalToConstant: FontSize.regular * 1.2),
             $0.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.0)]
        }
    }
    
    private func setUpTextField() {
        textField.isEditable = false
        textField.isBezeled = false
        textField.alignment = .center
        textField.drawsBackground = false
        textField.sizeToFit()
        textField.usesSingleLineMode = false
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
            .font: NSFont.systemFont(ofSize: FontSize.regular),
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
            .font: NSFont.systemFont(ofSize: FontSize.regular),
        ]))
        textField.attributedStringValue = attributedString
    }
}
