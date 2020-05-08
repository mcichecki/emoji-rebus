import AppKit
import SpriteKit
import Foundation

public final class MainScene: SKScene, SizeableScene {
    public let sceneSize = CGSize(width: 560, height: 500)
    
    private var currentIndex = 0 {
        didSet { currentRebus = Parser.shared.getRebus(at: currentIndex) }
    }
    
    //    private var currentRebus = RebusStorage.rebuses[0] {
    //        didSet { rebusView.updateRebus(currentRebus) }
    //    }
    
    private var currentRebus: Rebus? = Parser.shared.getRebus(at: 0) {
        didSet {
            rebusView.updateRebus(currentRebus)
            if let rebus = currentRebus {
                answerView.answer = rebus.answer
                difficultyView.difficulty = rebus.difficultyLevel
            }
        }
    }
    
    private lazy var rebusView = RebusView()
    
    private lazy var answerView = AnswerView()
    
    private lazy var difficultyView = DifficultyView()
    
    private var centerYConstraint: NSLayoutConstraint!
    
    public override init() {
        super.init(size: sceneSize)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    public override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        scene?.backgroundColor = ColorStyle.darkGray
        currentIndex = 0
        
        rebusView.delegate = self
        if let rebus = currentRebus {
            rebusView.updateRebus(rebus)
        }
        
        view.addSubviews(rebusView, answerView, difficultyView)
        rebusView.activateConstraints {
            [$0.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             $0.centerYAnchor.constraint(equalTo: view.centerYAnchor),
             $0.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
             $0.heightAnchor.constraint(equalToConstant: 300.0)]
        }
        
        centerYConstraint = answerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: sceneSize.height)
        
        answerView.activateConstraints {
            [$0.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             centerYConstraint,
             $0.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
             $0.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7)]
        }
        
        difficultyView.activateConstraints {
            [$0.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             $0.bottomAnchor.constraint(equalTo: view.bottomAnchor),
             $0.heightAnchor.constraint(equalToConstant: 40.0),
             $0.widthAnchor.constraint(equalToConstant: 200.0)]
        }
        answerView.alphaValue = 0.0
        
        answerView.delegate = self
    }
    
    private func presentAnswer() {
        answerView.alphaValue = 1.0
        
        let animations: (NSAnimationContext) -> Void = { context in
            context.duration = 0.5
            context.allowsImplicitAnimation = true
            context.timingFunction = CAMediaTimingFunction(name: .easeOut)
            
            self.centerYConstraint.constant = 0.0
            
            self.view?.layoutSubtreeIfNeeded()
        }
        
        NSAnimationContext.runAnimationGroup(animations)
    }
    
    private func hideAnswer() {
        let animations: (NSAnimationContext) -> Void = { context in
            context.duration = 0.3
            context.allowsImplicitAnimation = true
            context.timingFunction = CAMediaTimingFunction(name: .easeIn)
            
            self.centerYConstraint.constant = self.sceneSize.height
            
            self.view?.layoutSubtreeIfNeeded()
        }
        
        let completion: () -> Void = {
            self.answerView.alphaValue = 0.0
        }
        
        NSAnimationContext.runAnimationGroup(animations, completionHandler: completion)
    }
}

// MARK: - RebusViewDelegate

extension MainScene: RebusViewDelegate {
    func didComplete() {
        presentAnswer()
    }
}

// MARK: - AnswerViewDelegate

extension MainScene: AnswerViewDelegate {
    func didTapClose() {
        hideAnswer()
        currentIndex += 1
    }
}