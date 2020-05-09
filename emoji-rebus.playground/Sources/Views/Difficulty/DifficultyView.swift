import AppKit

final public class DifficultyView: NSView {
    enum FontSize {
        static let regular: CGFloat = 20.0
    }
    
    var difficulty: Rebus.Difficulty? {
        didSet { configureLabels() }
    }
    
    private lazy var titleTextField: NSTextField = configure { textField in
        textFieldConfig(textField)
        textField.attributedStringValue = NSAttributedString(string: "Difficulty", attributes: commonAttrs)
        textField.backgroundColor = .red
    }
    private lazy var difficultyTextField: NSTextField = configure { textField in
        textFieldConfig(textField)
        textField.backgroundColor = .yellow
    }
    
    private let fontSize: CGFloat = 24.0
    
    private let commonAttrs: [NSAttributedString.Key: Any] = {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        
        return [
            .foregroundColor: ColorStyle.white,
            .font: NSFont.systemFont(ofSize: FontSize.regular),
            .paragraphStyle: paragraphStyle
        ]
    }()
    
    private let textFieldConfig: (NSTextField) -> Void = { textField in
        textField.isEditable = false
        textField.isBezeled = false
        textField.alignment = .center
        textField.drawsBackground = false
        textField.sizeToFit()
        textField.usesSingleLineMode = false
    }
    
    init() {
        super.init(frame: .zero)
        
        addSubviews(titleTextField, difficultyTextField)
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setUpConstraints() {
        titleTextField.activateConstraints {
            [$0.centerXAnchor.constraint(equalTo: centerXAnchor),
             $0.heightAnchor.constraint(equalToConstant: FontSize.regular * 1.2),
             $0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5.0),
             $0.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5.0)]
        }
        
        difficultyTextField.activateConstraints {
            [$0.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 5.0),
                $0.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
                $0.heightAnchor.constraint(equalTo: titleTextField.heightAnchor),
                $0.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5.0)]
        }
    }
    
    private func configureLabels() {
        guard let difficulty = difficulty else {
            self.isHidden = true
            return
        }
        
        isHidden = false
        
        let attributedString = NSMutableAttributedString(string: difficulty.rawValue, attributes: commonAttrs)
        difficultyTextField.attributedStringValue = attributedString
    }
}
