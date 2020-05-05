import AppKit
import SpriteKit

public final class MainScene: SKScene {
    public let sceneSize = CGSize(width: 400, height: 560)
    
    private var currentIndex = 0 {
        didSet {
            currentRebus = RebusStorage.rebuses[currentIndex]
        }
    }
    
    private var currentRebus = RebusStorage.rebuses[0] {
        didSet {
            rebusLabel.rebus = currentRebus.rebus
            inputView.numberOfLetters = currentRebus.answer.count
        }
    }
    
    private let rebusLabel = RebusLabel()
    
    private let inputView = InputView()
    
    public override init() {
        super.init(size: sceneSize)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    public override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        scene?.backgroundColor = .darkGray
        currentIndex = 0
        
        inputView.inputDelegate = self
        [rebusLabel, inputView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let rebusLabelConstraints = [
            rebusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            rebusLabel.topAnchor.constraint(equalTo: view.topAnchor),
            rebusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            rebusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rebusLabel.heightAnchor.constraint(equalToConstant: 100.0)
        ]
        
        let inputViewConstraints = [
            inputView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            inputView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            inputView.heightAnchor.constraint(equalToConstant: 200.0)
        ]
        
        [rebusLabelConstraints, inputViewConstraints].forEach(NSLayoutConstraint.activate(_:))
    }
}

// MARK: - InputViewDelegate

extension MainScene: InputViewDelegate {
    func didUpdateInput(_ input: String) {
        if input.lowercased() == currentRebus.answer.lowercased() {
            print("--- Success ✅")
            currentIndex += 1
        } else {
            print("--- No match ‼️")
        }
    }
}
