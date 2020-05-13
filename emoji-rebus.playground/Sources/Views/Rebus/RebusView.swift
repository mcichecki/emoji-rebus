import AppKit

protocol RebusViewDelegate: AnyObject {
    func didComplete()
}

final class RebusView: NSVisualEffectView {
    weak var delegate: RebusViewDelegate?
    
    lazy var numberView: NumberView = configure()
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
        guard let rebus = rebus else { return }
        
        self.rebus = rebus
        inputView.focus()
    }
    
    func fillLetters() {
        inputView.fillLetters(rebus: rebus)
    }
    
    private func addSubviews() {
        addSubviews(numberView, rebusLabel, inputView)
        
        inputView.inputDelegate = self
    }
    
    private func setUpConstraints() {
        let margin: CGFloat = 7.0
        
        numberView.activateConstraints {
            [$0.topAnchor.constraint(equalTo: topAnchor),
             $0.widthAnchor.constraint(equalTo: widthAnchor)]
        }
        
        rebusLabel.activateConstraints {
            [$0.topAnchor.constraint(equalTo: numberView.bottomAnchor, constant: 15.0),
             $0.centerXAnchor.constraint(equalTo: centerXAnchor)]
        }
        
        inputView.activateConstraints {
            [$0.topAnchor.constraint(greaterThanOrEqualTo: rebusLabel.bottomAnchor, constant: margin),
             $0.centerXAnchor.constraint(equalTo: centerXAnchor),
             $0.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -margin)]
        }
    }
    
    private func setUpStyling() {
        material = .sheet
        blendingMode = .withinWindow
    }
}

// MARK: - InputViewDelegate

extension RebusView: InputViewDelegate {
    func didUpdateInput(_ input: String) {
        guard let rebus = rebus, rebus.valid(input: input) else { return }
        delegate?.didComplete()
        inputView.unfocus()
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
