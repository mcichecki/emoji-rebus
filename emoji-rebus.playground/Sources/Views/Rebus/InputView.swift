import AppKit
import Foundation

protocol InputViewDelegate: AnyObject {
    func didUpdateInput(_ input: String)
    func didUpdateInputArr(_ input: [Character?])
}

// TODO: Handle top bottom keys + backspace
private enum ArrowKey: UInt16 {
    case left = 123
    case right = 124
}

private enum BackspaceKey: UInt16 {
    case backspace = 51
}

private enum Direction {
    case previous, next
}

final public class InputView: NSStackView {
    weak var inputDelegate: InputViewDelegate?
    
    var numberOfLetters: Int = 0 {
        didSet {
            arrangedSubviews.forEach { $0.removeFromSuperview() }
            setUpTextFields()
        }
    }
    
    var isDisabled = false
    
    private(set) var input: String = "" {
        didSet {
            inputDelegate?.didUpdateInput(input)
        }
    }
    
    private var textFields: [LetterInputTextField] { arrangedSubviews.compactMap { $0.subviews.first as? LetterInputTextField } }
    
    private var lastIndex: Int { textFields.map { $0.tag }.max() ?? 0 }
    
    private let regex: String = "^[a-zA-Z0-9]$"
    
    init() {
        super.init(frame: .zero)
        
        setUp()
        setUpTextFields()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    public override func keyUp(with event: NSEvent) {
        let keyCode = event.keyCode
        if let arrowKey = ArrowKey(rawValue: keyCode) {
            handleArrowKey(arrowKey)
        }
        if BackspaceKey(rawValue: keyCode) != nil {
            handleBackspace()
        }
    }
    
    // TODO: Bug with same letters
    func highlight(indexes: [Int]) {
        textFields.enumerated().forEach { offset, textField in
            NSAnimationContext.runAnimationGroup { context in
                context.duration = 0.5
                context.allowsImplicitAnimation = true
                
                let color = (indexes.contains(offset) ? ColorStyle.green : ColorStyle.white).cgColor
                textField.layer?.borderColor = color
                textField.layer?.borderWidth = indexes.contains(offset) ? 3.0 : 2.0
            }
            
        }
    }
    
    func focus() {
        _ = textFields.first?.becomeFirstResponder()
    }
    
    func unfocus() {
        window?.makeFirstResponder(nil)
    }
    
    // TODO: Disable when completed
    func fillLetters(rebus: Rebus) {
        let answer = rebus.answer.title
        guard rebus.answer.title.count == textFields.count else { return }
        
        let enumeratedAnswer = answer.enumerated()
        enumeratedAnswer.forEach { offset, char in
            textFields[offset].stringValue = String(char)
            textFields[offset].isEditable = false
        }
        
        highlight(indexes: enumeratedAnswer.map { $0.offset })
        
        unfocus()
        isDisabled = true
    }
    
    private func setUp() {
        orientation = .horizontal
        spacing = 3.0
        distribution = .fill
    }
    
    private func setUpTextFields() {
        (0..<numberOfLetters)
            .forEach { index in
                let inputView = configure { view in
                    //                    view.wantsLayer = true
                    //                    view.layer?.backgroundColor = view.layer?.backgroundColor // TODO: needed?
                    
                }
                
                let letterInputTextField: LetterInputTextField = configure { view in
                    view.tag = index
                }
                
                inputView.addSubviews(letterInputTextField)
                
                inputView.activateConstraints {
                    [$0.widthAnchor.constraint(equalToConstant: 35.0),
                     $0.heightAnchor.constraint(equalToConstant: 90.0)]
                }
                
                letterInputTextField.activateConstraints {
                    [$0.centerXAnchor.constraint(equalTo: inputView.centerXAnchor),
                     $0.centerYAnchor.constraint(equalTo: inputView.centerYAnchor),
                     $0.heightAnchor.constraint(equalTo: inputView.heightAnchor, multiplier: 0.5),
                     $0.widthAnchor.constraint(equalTo: inputView.widthAnchor, multiplier: 1.0)]
                }
                
                letterInputTextField.delegate = self
                addArrangedSubview(inputView)
        }
    }
    
    private func updateInput() {
        input = textFields.map { $0.stringValue }.reduce("", +)
        
        let arr: [Character?] = textFields.map { $0.stringValue.first }
        
        inputDelegate?.didUpdateInputArr(arr)
    }
    
    private func handleBackspace() {
        guard let currentIndex = textFields.firstIndex(where: { $0.focused }) else { return }
        if textFields[currentIndex].stringValue.isEmpty {
            switchTextField(direction: .previous, currentIndex: currentIndex)
        }
    }
    
    private func handleArrowKey(_ key: ArrowKey) {
        guard let currentIndex = textFields.firstIndex(where: { $0.focused }) else { return }
        
        var direction: Direction
        switch key {
        case .left: direction = .previous
        case .right: direction = .next
        }
        
        switchTextField(direction: direction, currentIndex: currentIndex)
    }
    
    private func switchTextField(direction: Direction, currentIndex: Int) {
        let notLast = currentIndex != lastIndex
        let notFirst = currentIndex != 0
        switch direction {
        case .previous:
            if notFirst { _ = textFields.first(where: { $0.tag == currentIndex - 1 })?.becomeFirstResponder() }
        case .next:
            if notLast { _ = textFields.first(where: { $0.tag == currentIndex + 1 })?.becomeFirstResponder() }
        }
    }
}

// TODO: move to next textfield when space is typed?
extension InputView: NSTextFieldDelegate {
    public func controlTextDidChange(_ obj: Notification) {
        guard let textField = obj.object as? NSTextField else { return }
        
        if !(textField.stringValue.isEmpty || textField.stringValue.matches(regex)) {
            if let lastChar = textField.stringValue.last {
                if String(lastChar).matches(regex) {
                    textField.stringValue = String(lastChar)
                } else if let firstLetter = textField.stringValue.compactMap ({ String($0) }).first, firstLetter.matches(regex) {
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
        
        let notLast = textField.tag != lastIndex
        let notFirst = textField.tag != 0
        
        if notFirst && textField.stringValue.isEmpty {
            _ = textFields.first(where: { $0.tag == textField.tag - 1 })?.becomeFirstResponder()
        }
        
        if notLast && !textField.stringValue.isEmpty {
            _ = textFields.first(where: { $0.tag == textField.tag + 1 })?.becomeFirstResponder()
        }
        
        updateInput()
    }
}
