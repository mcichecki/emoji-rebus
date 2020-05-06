import AppKit

final class AnswerView: NSView {
    lazy var titleTextField: NSTextField = configure { textField in
        textFieldConfig(textField)
        textField.font = NSFont.systemFont(ofSize: 30.0)
    }
    
    lazy var descriptionTextField: NSTextField = configure { textField in
        textFieldConfig(textField)
        textField.font = NSFont.systemFont(ofSize: 20.0)
    }
    
    private let textFieldConfig: (NSTextField) -> Void = { textField in
        textField.isEditable = false
        textField.wantsLayer = true
        textField.layer?.backgroundColor = NSColor.red.cgColor
        textField.alignment = .center
        textField.layer?.cornerRadius = 5.0
    }
    
    init() {
        super.init(frame: .zero)
        
        addSubviews()
        setUpConstraints()
        setUpViews()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func addSubviews() {
        [titleTextField, descriptionTextField].forEach(addSubview(_:))
    }
    
    private func setUpConstraints() {
        titleTextField.activateConstraints {
            [$0.topAnchor.constraint(equalTo: topAnchor, constant: 20.0),
             $0.centerXAnchor.constraint(equalTo: centerXAnchor),
             $0.heightAnchor.constraint(equalToConstant: 30.0),
             $0.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5)]
        }
        
        descriptionTextField.activateConstraints {
            [$0.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20.0),
             $0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.0),
             $0.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.0),
             $0.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20.0)]
        }
    }
    
    private func setUpViews() {
        wantsLayer = true
        layer?.backgroundColor = NSColor.blue.cgColor
        layer?.cornerRadius = 5.0
        titleTextField.stringValue = "Answer"
        descriptionTextField.stringValue = "Some longer, multiline description..."
    }
}
