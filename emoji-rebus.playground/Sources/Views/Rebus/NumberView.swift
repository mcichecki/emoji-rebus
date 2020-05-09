import AppKit

final class NumberView: NSView {
    lazy var numberLabel: NSTextField = configure { textField in
        textField.isEditable = false
        textField.isBezeled = false
        textField.alignment = .right
        textField.drawsBackground = false
        textField.sizeToFit()
        textField.usesSingleLineMode = false
        textField.font = .systemFont(ofSize: 18.0, weight: .medium)
    }
    
    init() {
        super.init(frame: .zero)
        
        setUpSubviews()
        setUpConstraints()
        setUpStyling()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateLabel(index: Int, numberOfItems: Int) {
        numberLabel.stringValue = "\(index)/\(numberOfItems)"
    }
    
    private func setUpSubviews() {
        addSubviews(numberLabel)
    }
    
    private func setUpConstraints() {
        numberLabel.activateConstraints {
            [$0.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10.0),
             $0.centerYAnchor.constraint(equalTo: centerYAnchor),
             $0.widthAnchor.constraint(equalToConstant: 50.0)]
        }
        
        activateConstraints {
            [$0.heightAnchor.constraint(equalToConstant: 40.0)]
        }
    }
    
    private func setUpStyling() {
        setBackgroundColor(.darkGray)
    }
}
