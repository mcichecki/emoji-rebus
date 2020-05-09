import AppKit

protocol RebusViewDelegate: AnyObject {
    func didComplete()
}

final class RebusView: NSView {
    weak var delegate: RebusViewDelegate?
    
    lazy var rebusLabel: RebusLabel = configure()
    lazy var inputView: InputView = configure()
    
    private(set) var rebus: Rebus! {
        didSet {
            rebusLabel.rebus = rebus
            inputView.numberOfLetters = rebus.numberOfLetters
        }
    }
    
    init() {
        super.init(frame: .zero)
        
        addSubviews()
        setUpConstraints()
        setUpStyling()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func updateRebus(_ rebus: Rebus?) {
        guard let rebus = rebus else {
            print("--- no new rebus")
            return
        }
        
        self.rebus = rebus
        inputView.focus()
    }
    
    private func addSubviews() {
        addSubviews(rebusLabel, inputView)
        
        inputView.inputDelegate = self
    }
    
    private func setUpConstraints() {
        let margin: CGFloat = 20.0
        
        rebusLabel.activateConstraints {
            [$0.topAnchor.constraint(equalTo: topAnchor, constant: margin),
             $0.centerXAnchor.constraint(equalTo: centerXAnchor)]
        }
        
        inputView.activateConstraints {
            [$0.topAnchor.constraint(greaterThanOrEqualTo: rebusLabel.bottomAnchor, constant: 20.0),
             $0.centerXAnchor.constraint(equalTo: centerXAnchor),
             $0.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -margin)]
        }
    }
    
    private func setUpStyling() {
//        setBackgroundColor(.red)
        setBackgroundColor(ColorStyle.Background.blue)
        layer?.cornerRadius = 8.0
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
        let answerChars = Array(rebus.answer.title) as [Character]
        
        guard input.count == answerChars.count else { fatalError("Number of chars of input and answer don't match") }
        
        var highlightedIndexes: [Int] = []
        for (index, answerChar) in answerChars.enumerated() where answerChar.lowercased() == input[index]?.lowercased() {
            highlightedIndexes.append(index)
        }
        inputView.highlight(indexes: highlightedIndexes)
    }
}
