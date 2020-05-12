import AppKit
import SpriteKit
import Foundation

public final class RebusScene: SKScene, SizeableScene {
    private enum AnswerState {
        case center, bottom, hidden
        
        var offset: CGFloat {
            switch self {
            case .center: return -100.0
            case .bottom: return 20.0
            case .hidden: return 300.0
            }
        }
    }
    
    public let sceneSize = CGSize(width: 560, height: 540)
    
    private var currentIndex = 0 {
        didSet {
            let color = backgroundColors[currentIndex % backgroundColors.count]
            scene?.backgroundColor = color
            hintButton.updateTextColor(color)
            rebusView.numberView.updateLabel(index: currentIndex + 1, numberOfItems: rebusProvider.rebuses.count)
            currentRebus = rebusProvider.getRebus(at: currentIndex)
        }
    }
    
    private var currentRebus: Rebus? {
        didSet {
            rebusView.updateRebus(currentRebus)
            guard let rebus = currentRebus else { return }
            difficultyView.difficulty = rebus.difficultyLevel
            if answerTopConstraint != nil && !rebusProvider.rebuses[currentIndex].completed {
                hideAnswer {
                    self.answerView.answer = rebus.answer
                }
            } else {
                self.answerView.answer = rebus.answer
            }
        }
    }
    
    private lazy var rebusProvider = RebusProvider.shared
    private lazy var speechSynthesizer = SpeechSynthesizer()
    
    private lazy var rebusView = RebusView()
    private lazy var answerView = AnswerView(speechSynthesizer: speechSynthesizer)
    private lazy var difficultyView = DifficultyView()
    private lazy var leftArrow = ArrowButton(direction: .left)
    private lazy var rightArrow = ArrowButton(direction: .right)
    private lazy var fadeView: NSView = configure { view in
        view.alphaValue = 0.0
        view.setBackgroundColor(ColorStyle.black)
    }
    private lazy var hintButton: FilledButton = configure { button in
        button.buttonTitle = "Hint"
        button.buttonDelegate = self
        button.updateTextColor(scene?.backgroundColor ?? ColorStyle.white)
    }
    private lazy var sliderView: SliderView = configure { slider in
        slider.isHidden = true
        slider.delegate = self
    }
    private var answerTopConstraint: NSLayoutConstraint!
    private let backgroundColors = ColorStyle.backgroundColors.shuffled()
    
    public override init() {
        super.init(size: sceneSize)
        
        currentIndex = 0
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    public override func didMove(to view: SKView) {
        super.didMove(to: view)
                
        currentIndex = 0
        
        rebusView.delegate = self
        if let rebus = currentRebus {
            rebusView.updateRebus(rebus)
        }
        
        view.addSubviews(rebusView, fadeView, difficultyView, leftArrow, rightArrow, hintButton, sliderView, answerView)
        
        rebusView.activateConstraints {
            [$0.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             $0.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -85.0),
             $0.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
             $0.heightAnchor.constraint(equalToConstant: 220.0)]
        }
        
        answerTopConstraint = answerView.topAnchor.constraint(equalTo: rebusView.bottomAnchor, constant: AnswerState.hidden.offset)
        
        answerView.activateConstraints {
            [$0.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             answerTopConstraint,
             $0.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)]
        }
        
        difficultyView.activateConstraints {
            [$0.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             $0.topAnchor.constraint(equalTo: view.topAnchor, constant: 5.0),
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
        
        fadeView.activateConstraints {
            [$0.topAnchor.constraint(equalTo: view.topAnchor),
             $0.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             $0.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             $0.bottomAnchor.constraint(equalTo: view.bottomAnchor)]
        }
        
        hintButton.activateConstraints {
            [$0.topAnchor.constraint(equalTo: view.topAnchor, constant: 5.0),
             $0.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5.0)]
        }
        
        sliderView.activateConstraints {
            [$0.topAnchor.constraint(equalTo: view.topAnchor, constant: 10.0),
             $0.centerXAnchor.constraint(equalTo: view.centerXAnchor)]
        }
        
        answerView.alphaValue = 0.0
        fadeView.layer?.zPosition = (difficultyView.layer?.zPosition ?? 0) + 1
        answerView.layer?.zPosition = (fadeView.layer?.zPosition ?? 0) + 1
        
        answerView.delegate = self
    }
    
    private func presentAnswer(state: AnswerState = .center) {
        answerView.alphaValue = 1.0
        let animations: (NSAnimationContext) -> Void = { context in
            context.duration = 0.3
            context.allowsImplicitAnimation = true
            context.timingFunction = CAMediaTimingFunction(name: .easeOut)
            
            self.answerTopConstraint.constant = state.offset
            if state == .center {
                self.fadeView.alphaValue = 0.5
            } else if state == .bottom {
                self.answerView.closeButtonHidden = true
            }
            self.view?.layoutSubtreeIfNeeded()
        }
        
        let completion = state == .center ? { self.answerView.readAnswer() } : nil
        
        NSAnimationContext.runAnimationGroup(animations, completionHandler: completion)
    }
    
    private func hideAnswer(hideCompletion: (() -> Void)? = nil) {
        let animations: (NSAnimationContext) -> Void = { context in
            context.duration = 0.3
            context.allowsImplicitAnimation = true
            context.timingFunction = CAMediaTimingFunction(name: .easeOut)
            
            self.answerTopConstraint.constant = AnswerState.hidden.offset
            self.fadeView.alphaValue = 0.0
            self.view?.layoutSubtreeIfNeeded()
        }
        
        let completion: () -> Void = {
            self.answerView.alphaValue = 0.0
            self.answerView.closeButtonHidden = false
            hideCompletion?()
        }
        
        NSAnimationContext.runAnimationGroup(animations, completionHandler: completion)
    }
    
    private func didTapHintButton() {
        guard let rebus = currentRebus else { return }
        speechSynthesizer.speak(rebus)
    }
}

// MARK: - RebusViewDelegate

extension RebusScene: RebusViewDelegate {
    func didComplete() {
        [leftArrow, rightArrow].forEach { $0.isEnabled = false }
        presentAnswer()
    }
}

// MARK: - AnswerViewDelegate

extension RebusScene: AnswerViewDelegate {
    func didTapClose() {
        rebusProvider.markAsComplete(index: currentIndex)
        let isLast = currentIndex == rebusProvider.rebuses.count - 1
        if currentIndex < rebusProvider.rebuses.count - 1 {
            currentIndex += 1
        } else if isLast {
            hideAnswer()
        }
        let numberOfCompleted = rebusProvider.numberOfCompleted
        if numberOfCompleted >= 1 && !isLast {
            sliderView.isHidden = false
            sliderView.update(numberOfRebuses: rebusProvider.numberOfCompleted + 1)
        }
        updateArrowsAndHint()
    }
    
    private func updateArrowsAndHint() {
        [leftArrow, rightArrow].forEach { $0.isEnabled = true }
        
        // checks if there is next rebus
        let nextIndex = currentIndex + 1
        guard rebusProvider.rebuses.indices.contains(nextIndex) else {
            leftArrow.isHidden = false
            rightArrow.isHidden = true
            return
        }
        
        let currentRebusCompleted = rebusProvider.rebuses[currentIndex].completed
        hintButton.isHidden = currentRebusCompleted
        leftArrow.isHidden = currentIndex == 0
        rightArrow.isHidden = !(currentRebusCompleted || rebusProvider.rebuses[nextIndex].completed)
    }
}

// MARK: - ArrowButtonDelegate

extension RebusScene: ArrowButtonDelegate {
    func didTapArrowButton(direction: ArrowDirection) {
        currentIndex += direction.rawValue
        
        updateArrowsAndHint()
        showCompleted()
        sliderView.updateValue(currentIndex)
    }
    
    private func showCompleted() {
        if rebusProvider.rebuses.indices.contains(currentIndex),
            rebusProvider.rebuses[currentIndex].completed {
            presentAnswer(state: .bottom)
            rebusView.fillLetters()
        }
    }
}

// MARK: - FilledButtonDelegate

extension RebusScene: FilledButtonDelegate {
    func didTap() {
        didTapHintButton()
    }
}

// MARK: - SliderDelegate

extension RebusScene: SliderDelegate {
    func didMoveToIndex(_ index: Int) {
        guard index != currentIndex else { return }
        currentIndex = index
        updateArrowsAndHint()
        showCompleted()
    }
}
