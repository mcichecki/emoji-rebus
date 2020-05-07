import AppKit
import SpriteKit
import Foundation

public final class MainScene: SKScene, SizeableScene {
    public let sceneSize = CGSize(width: 400, height: 560)
    
    private var currentIndex = 0 {
        didSet { currentRebus = RebusStorage.rebuses[currentIndex] }
    }
    
    private var currentRebus = RebusStorage.rebuses[0] {
        didSet { rebusView.updateRebus(currentRebus) }
    }
    
    private lazy var rebusView = RebusView()
    
    private lazy var answerView = AnswerView()
    
    private let animationDuration: TimeInterval = 0.6
    
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
        rebusView.updateRebus(currentRebus)
        
        view.addSubviews(rebusView, answerView)
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
        answerView.alphaValue = 0.0
    }
    
    private func presentAnswer() {
        answerView.alphaValue = 1.0
        
        let animations: (NSAnimationContext) -> Void = { context in
            context.duration = self.animationDuration
            context.allowsImplicitAnimation = true
            context.timingFunction = CAMediaTimingFunction(name: .easeOut)
            
            self.centerYConstraint.constant = 0.0
            
            self.view?.layoutSubtreeIfNeeded()
        }
        
        NSAnimationContext.runAnimationGroup(animations)
    }
    
    private func hideAnswer() {
        let animations: (NSAnimationContext) -> Void = { context in
            context.duration = self.animationDuration
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
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.hideAnswer()
            //            self.currentIndex += 1
        }
    }
}
