import AppKit
import SpriteKit
import Foundation

public final class MainScene: SKScene, SizeableScene {
    public let sceneSize = CGSize(width: 560, height: 500)
    
    private var currentIndex = 0 {
        didSet {
            scene?.backgroundColor = backgroundColors[currentIndex % backgroundColors.count]
            rebusView.numberView.updateLabel(index: currentIndex + 1, numberOfItems: rebusProvider.rebuses.count)
            currentRebus = rebusProvider.getRebus(at: currentIndex)
        }
    }
    
    private var currentRebus: Rebus? {
        didSet {
            rebusView.updateRebus(currentRebus)
            if let rebus = currentRebus {
                answerView.answer = rebus.answer
                difficultyView.difficulty = rebus.difficultyLevel
            }
        }
    }
    
    private lazy var rebusProvider = RebusProvider.shared
    
    private lazy var rebusView = RebusView()
    private lazy var answerView = AnswerView()
    private lazy var difficultyView = DifficultyView()
    private lazy var leftArrow = ArrowButton(direction: .left)
    private lazy var rightArrow = ArrowButton(direction: .right)
    private var centerYConstraint: NSLayoutConstraint!
    private let backgroundColors = ColorStyle.backgroundColors.shuffled()
    
    public override init() {
        super.init(size: sceneSize)
        
        currentIndex = 0
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    public override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        // TODO: randomize colors
//        scene?.backgroundColor = ColorStyle.darkGray
        currentIndex = 0
        
        rebusView.delegate = self
        if let rebus = currentRebus {
            rebusView.updateRebus(rebus)
        }
        
        view.addSubviews(rebusView, answerView, difficultyView, leftArrow, rightArrow)
        
        rebusView.activateConstraints {
            [$0.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             $0.centerYAnchor.constraint(equalTo: view.centerYAnchor),
             $0.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
             $0.heightAnchor.constraint(equalToConstant: 220.0)]
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
             $0.heightAnchor.constraint(equalToConstant: 80.0),
             $0.widthAnchor.constraint(equalToConstant: 100.0)]
        }
        
        let buttonSize: CGFloat = 30.0
        leftArrow.activateConstraints {
            [$0.trailingAnchor.constraint(equalTo: rebusView.leadingAnchor, constant: -10.0),
             $0.centerYAnchor.constraint(equalTo: rebusView.centerYAnchor),
             $0.heightAnchor.constraint(equalToConstant: buttonSize),
             $0.widthAnchor.constraint(equalToConstant: buttonSize)
            ]
        }
        
        rightArrow.activateConstraints {
            [$0.leadingAnchor.constraint(equalTo: rebusView.trailingAnchor, constant: 10.0),
             $0.centerYAnchor.constraint(equalTo: rebusView.centerYAnchor),
             $0.heightAnchor.constraint(equalToConstant: buttonSize),
             $0.widthAnchor.constraint(equalToConstant: buttonSize)]
        }
        
        [leftArrow, rightArrow].forEach {
            $0.delegate = self
            $0.isHidden = true
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
        rebusProvider.markAsComplete(index: currentIndex)
        updateArrows()
        if currentIndex < rebusProvider.rebuses.count - 1 {
            currentIndex += 1
        }
    }
    
    private func updateArrows() {
        // checks if there is next rebus
        let nextIndex = currentIndex + 1
        guard rebusProvider.rebuses.indices.contains(nextIndex) else {
            leftArrow.isHidden = false
            rightArrow.isHidden = true
            return
        }
        
        leftArrow.isHidden = currentIndex == 0
        rightArrow.isHidden = !(rebusProvider.rebuses[currentIndex].completed || rebusProvider.rebuses[nextIndex].completed)
    }
}

// MARK: - ArrowButtonDelegate

extension MainScene: ArrowButtonDelegate {
    func didTapArrowButton(direction: ArrowDirection) {
        switch direction {
        case .left: currentIndex -= 1
        case .right: currentIndex += 1
        }
        
        updateArrows()
        fillLettersIfPossible()
    }
    
    private func fillLettersIfPossible() {
        guard rebusProvider.rebuses.indices.contains(currentIndex) else { return }
        guard rebusProvider.rebuses[currentIndex].completed else { return }
        
        rebusView.fillLetters()
    }
}
