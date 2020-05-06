import AppKit

protocol RebusViewDelegate: AnyObject {
    func didComplete()
}

final class RebusView: NSView {
    weak var delegate: RebusViewDelegate?
    
    lazy var rebusLabel = RebusLabel()
    
    lazy var inputView = InputView()
    
    private(set) var rebus: Rebus! {
        didSet {
            rebusLabel.rebus = rebus
            inputView.numberOfLetters = rebus.numberOfLetters
        }
    }
    
    private lazy var stackView: NSStackView = {
        let stackView = NSStackView()
        stackView.orientation = .vertical
        stackView.spacing = 50.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        
        addSubviews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func updateRebus(_ rebus: Rebus) {
        self.rebus = rebus
        inputView.focus()
    }
    
    private func addSubviews() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        [rebusLabel, inputView].forEach(stackView.addArrangedSubview(_:))
        inputView.inputDelegate = self
    }
    
    private func setUpConstraints() {
        let stackViewConstraints = [
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        
        [stackViewConstraints].activate()
    }
}

// MARK: - InputViewDelegate

extension RebusView: InputViewDelegate {
    func didUpdateInput(_ input: String) {
        guard let rebus = rebus else { return }
        if rebus.valid(input: input) {
            delegate?.didComplete()
            inputView.unfocus()
        } else {
            // print("--- No match ‼️")
        }
    }
    
    func didUpdateInputArr(_ input: [Character?]) {
        let answerChars = Array(rebus.answer) as [Character]
        
        guard input.count == answerChars.count else { fatalError("Number of chars of input and answer don't match") }
        
        var highlightedIndexes: [Int] = []
        for (index, answerChar) in answerChars.enumerated() where answerChar == input[index] {
            highlightedIndexes.append(index)
        }
        inputView.highlight(indexes: highlightedIndexes)
    }
}
