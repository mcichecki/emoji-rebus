import AppKit
import SpriteKit

public final class MainScene: SKScene {
    public let sceneSize = CGSize(width: 400, height: 560)
    
    private var currentIndex = 0 {
        didSet { currentRebus = RebusStorage.rebuses[currentIndex] }
    }
    
    private var currentRebus = RebusStorage.rebuses[0] {
        didSet { rebusView.updateRebus(currentRebus) }
    }
    
    private lazy var rebusView = RebusView()
    
    private lazy var answerView = AnswerView()
    
    public override init() {
        super.init(size: sceneSize)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    public override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        scene?.backgroundColor = .darkGray
        currentIndex = 0
        
        rebusView.delegate = self
        rebusView.updateRebus(currentRebus)
        rebusView.translatesAutoresizingMaskIntoConstraints = false
        
//        view.addSubview(rebusView)
//
//        let rebusViewConstraints = [
//            rebusView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            rebusView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            rebusView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
//            rebusView.heightAnchor.constraint(equalToConstant: 300.0)
//        ]
//
//        [rebusViewConstraints].activate()
        view.addSubview(answerView)
        answerView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            answerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            answerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            answerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            answerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
        ]
        
        [constraints].activate()
    }
    
    private func presentAnswer() {
        guard let view = view else { return }
        print("--- presentAnswer")
//        view.addSubview(answerView)
//        let constraints = [
//            answerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
//            answerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
//            answerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            answerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ]
//
//        [constraints].activate()
    }
}

// MARK: - RebusViewDelegate

extension MainScene: RebusViewDelegate {
    func didComplete() {
        presentAnswer()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
            self.currentIndex += 1
        }
    }
}

