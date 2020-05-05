import AppKit
import Foundation

protocol InputViewDelegate: AnyObject {
    func didUpdateInput(_ input: String)
}

final public class InputView: NSStackView {
    weak var inputDelegate: InputViewDelegate?
    
    var numberOfLetters: Int = 0 {
        didSet {
            arrangedSubviews.forEach { $0.removeFromSuperview() }
            setUpTextFields()
        }
    }
    
    private(set) var input: String = "" {
        didSet {
            inputDelegate?.didUpdateInput(input)
        }
    }
    
    private var textFields: [NSTextField] { arrangedSubviews.compactMap { $0.subviews.first as? NSTextField } }
    
    
    init() {
        super.init(frame: .zero)
        
        setUp()
        setUpTextFields()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setUp() {
        orientation = .horizontal
        spacing = 3.0
        distribution = .fill
    }
    
    private func setUpTextFields() {
        (0..<numberOfLetters)
            .forEach { index in
                let inputView = NSView()
                inputView.translatesAutoresizingMaskIntoConstraints = false
                inputView.wantsLayer = true
                inputView.layer?.backgroundColor = inputView.layer?.backgroundColor
                let letterInputTextField = LetterInputTextField()
                letterInputTextField.tag = index
                
                inputView.addSubview(letterInputTextField)
                
                let inputViewConstraints = [
                    inputView.widthAnchor.constraint(equalToConstant: 35.0),
                    inputView.heightAnchor.constraint(equalToConstant: 90.0)
                ]
                
                let textFieldConstraints = [
                    letterInputTextField.centerXAnchor.constraint(equalTo: inputView.centerXAnchor),
                    letterInputTextField.centerYAnchor.constraint(equalTo: inputView.centerYAnchor),
                    letterInputTextField.heightAnchor.constraint(equalTo: inputView.heightAnchor, multiplier: 0.5),
                    letterInputTextField.widthAnchor.constraint(equalTo: inputView.widthAnchor, multiplier: 1.0)
                ]
                
                [inputViewConstraints, textFieldConstraints].forEach(NSLayoutConstraint.activate(_:))
                
                letterInputTextField.delegate = self
                addArrangedSubview(inputView)
        }
    }
    
    private func updateInput() {
        input = textFields.map { $0.stringValue }.reduce("", +)
    }
}

extension InputView: NSTextFieldDelegate {
    public func controlTextDidChange(_ obj: Notification) {
        guard let textField = obj.object as? NSTextField else { return }
        
        if !(textField.stringValue.isEmpty || textField.stringValue.matches("^[a-zA-Z]$")) {
            if let lastChar = textField.stringValue.last {
                if String(lastChar).matches("^[a-zA-Z]$") {
                    textField.stringValue = String(lastChar)
                } else if let firstLetter = textField.stringValue.compactMap ({ String($0) }).first, firstLetter.matches("^[a-zA-Z]$") {
                    textField.stringValue = firstLetter
                } else {
                    textField.stringValue = ""
                    return
                }
            } else {
                textField.stringValue = ""
                return
            }
        }
        
        let notLast = textField.tag != numberOfLetters - 1
        let notFirst = textField.tag != 0
        
        if notFirst && textField.stringValue.isEmpty {
            let previousTextField = textFields.first(where: { $0.tag == textField.tag - 1 })
            previousTextField?.becomeFirstResponder()
        }
        
        if notLast && !textField.stringValue.isEmpty {
            let nextTextField = textFields.first(where: { $0.tag == textField.tag + 1 })
            nextTextField?.becomeFirstResponder()
        }
        
        updateInput()
    }
}
