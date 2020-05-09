import AppKit

protocol AnswerViewDelegate: AnyObject {
    func didTapClose()
}

final class AnswerView: NSView {
    weak var delegate: AnswerViewDelegate?
    
    var answer: Answer! {
        didSet {
            updateAnswer(answer)
        }
    }
    
    lazy var titleTextField: NSTextField = configure { textField in
        textFieldConfig(textField)
        textField.font = NSFont.systemFont(ofSize: 24.0)
    }
    
    lazy var descriptionTextField: NSTextField = configure { textField in
        textFieldConfig(textField)
        textField.font = NSFont.systemFont(ofSize: 16.0)
    }
    
    private let textFieldConfig: (NSTextField) -> Void = { textField in
        textField.alignment = .center
        textField.isEditable = false
        textField.isBezeled = false
        textField.textColor = ColorStyle.white
        textField.backgroundColor = ColorStyle.green
    }
    
    private let closeButton: NSButton = configure { closeButton in
        closeButton.title = "✕"
        closeButton.bezelStyle = .inline
    }
    
    init() {
        super.init(frame: .zero)
        
        addSubviews()
        setUpConstraints()
        setUpViews()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func addSubviews() {
        [titleTextField, descriptionTextField, closeButton].forEach(addSubview(_:))
    }
    
    private func setUpConstraints() {
        titleTextField.activateConstraints {
            [$0.topAnchor.constraint(equalTo: closeButton.centerYAnchor, constant: 10.0),
             $0.centerXAnchor.constraint(equalTo: centerXAnchor),
             $0.heightAnchor.constraint(equalToConstant: 40.0),
             $0.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5)]
        }
        
        closeButton.activateConstraints {
            [$0.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
             $0.topAnchor.constraint(equalTo: topAnchor, constant: 10.0),
             $0.heightAnchor.constraint(equalToConstant: 20.0),
             $0.widthAnchor.constraint(equalToConstant: 20.0)]
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
        layer?.backgroundColor = ColorStyle.green.cgColor
        layer?.cornerRadius = 5.0
        layer?.borderColor = ColorStyle.lightGreen.cgColor
        layer?.borderWidth = 3.0
        titleTextField.stringValue = "Answer"
        descriptionTextField.stringValue = "Some longer, multiline description..."
        
        closeButton.target = self
        closeButton.action = #selector(closeButtonTapped)
    }
    
    @objc private func closeButtonTapped() {
        delegate?.didTapClose()
    }
    
    private func updateAnswer(_ answer: Answer) {
        titleTextField.stringValue = answer.title
        descriptionTextField.stringValue = answer.description
    }
}
