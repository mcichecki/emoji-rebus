import AppKit

final public class InputView: NSStackView {
    private(set) var input: String = "" {
        didSet {
            print("--- full input: \(input)")
        }
    }
    
    private let numberOfLetters: Int
    
    init(numberOfLetters: Int) {
        self.numberOfLetters = numberOfLetters
        super.init(frame: .zero)
        
        setUp()
        setUpTextFields()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setUp() {
        orientation = .horizontal
        spacing = 10.0
        distribution = .fill
    }
    
    private func setUpTextFields() {
        (0..<numberOfLetters)
            .forEach { index in
                print("--- index: \(index)")
                let textField = NSTextField()
                textField.alignment = .center
                textField.tag = index
                textField.backgroundColor = .white//colors.randomElement()
                
                textField.translatesAutoresizingMaskIntoConstraints = false
                let constraints = [
                    textField.widthAnchor.constraint(equalToConstant: 50.0),
                    textField.heightAnchor.constraint(equalToConstant: 50.0)
                ]
                
                NSLayoutConstraint.activate(constraints)
                
                textField.wantsLayer = true
                textField.layer?.cornerRadius = 5.0
                textField.layer?.borderWidth = 2.0
                textField.layer?.borderColor = NSColor.darkGray.cgColor
                textField.focusRingType = .none
                
                textField.delegate = self
                addArrangedSubview(textField)
        }
    }
    
    private func updateInput() {
        let textFields = arrangedSubviews.compactMap { $0 as? NSTextField }
        
        input = textFields.map { $0.stringValue }.reduce("", +)
    }
}

extension InputView: NSTextFieldDelegate {
    public func controlTextDidChange(_ obj: Notification) {
        // regex: ^[a-zA-Z]$
        guard let textField = obj.object as? NSTextField else { return }
        
        if textField.stringValue.count > 1 {
            textField.stringValue = String(textField.stringValue.last ?? Character(""))
        }
        
        let notLast = textField.tag != numberOfLetters - 1
        let notFirst = textField.tag != 0
        
        if notFirst && textField.stringValue.isEmpty {
            let previousTextField = arrangedSubviews.first(where: { $0.tag == textField.tag - 1 })
            previousTextField?.becomeFirstResponder()
        }
        if notLast && !textField.stringValue.isEmpty {
            let nextTextField = arrangedSubviews.first(where: { $0.tag == textField.tag + 1 })
            nextTextField?.becomeFirstResponder()
        }
        
//        print("tag: \(te  xtField.tag) | \(textField.stringValue)")
        
        updateInput()
    }
    
    
}
