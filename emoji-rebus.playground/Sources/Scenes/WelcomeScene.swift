import AppKit
import SpriteKit
import Foundation

public final class WelcomeScene: SKScene, SizeableScene {
    public let sceneSize = CGSize(width: 680, height: 540)
    
    private lazy var welcomeTextField: NSTextField = configure { textField in
        textFieldConfig(textField)
        textField.stringValue = """
        Today you have a chance to solve rebuses and learn about ecology and our planet Earth.
        Use a keyboard to enter letters and solve the rebus. For example, combining letters R, E and bus emoji result in word rebus.
        """
    }
    
    private lazy var welcomeRebusView: RebusView = configure { rebusView in
        rebusView.alphaValue = 0.0
        rebusView.updateRebus(Rebus(.text("re"), .plus, .emoji("🚌"), ans: "rebus"))
        rebusView.delegate = self
    }
    
    private lazy var completionTextField: NSTextField = configure { textField in
        textFieldConfig(textField)
        textField.alphaValue = 0.0
        textField.stringValue = """
        Good job 🎉
        In case of any problems, you can use a hint button in the top left corner.
        Good luck!
        """
    }
    
    private lazy var skipButton: FilledButton = configure { button in
        button.alphaValue = 0.0
        button.buttonTitle = "skip intro"
        button.buttonDelegate = self
        button.updateTextColor(scene?.backgroundColor ?? ColorStyle.black)
    }
    
    private let textFieldConfig: (NSTextField) -> Void = { textField in
        textField.isEditable = false
        textField.isBezeled = false
        textField.alignment = .center
        textField.drawsBackground = false
        textField.sizeToFit()
        textField.usesSingleLineMode = false
        textField.font = .systemFont(ofSize: 18.0, weight: .light)
    }
    
    private lazy var speechSynthesizer = SpeechSynthesizer()
    private var state: SceneState = .initial
    private var emitter: EmojiEmitterLayer!
    
    public override init() {
        super.init(size: sceneSize)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    public override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        setUpEmitter(in: view)
        setUpViews()
        setUpConstraints()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.setViewsAlpha(views: [self.welcomeRebusView, self.skipButton])
        }
        
        speechSynthesizer.speechSynthesizerDelegate = self
        speechSynthesizer.speak(text: welcomeTextField.stringValue)
    }
    
    private func setUpEmitter(in view: SKView) {
        let emitter = EmojiEmitterLayer(frameSize: view.frame)
        view.layer?.addSublayer(emitter)
        self.emitter = emitter
        
        let emojis = ["🦠", "🍁", "🌍", "🌊", "🌸", "☀️", "🐠", "🦆", "🦁"]
        emitter.updateEmojis(emojis, state: .welcome)
    }
    
    private func setUpViews() {
        guard let view = view else { return }
        view.addSubviews(welcomeTextField, welcomeRebusView, completionTextField, skipButton)
    }
    
    private func setUpConstraints() {
        guard let view = view else { return }
        
        welcomeTextField.activateConstraints {
            [$0.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.0),
             $0.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.0),
             $0.heightAnchor.constraint(equalToConstant: 90.0),
             $0.bottomAnchor.constraint(equalTo: welcomeRebusView.topAnchor, constant: -20.0)]
        }
        
        welcomeRebusView.activateConstraints {
            [$0.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             $0.centerYAnchor.constraint(equalTo: view.centerYAnchor),
             $0.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
             $0.heightAnchor.constraint(equalToConstant: 220.0)]
        }
        
        completionTextField.activateConstraints {
            [$0.topAnchor.constraint(equalTo: welcomeRebusView.bottomAnchor, constant: 20.0),
             $0.leadingAnchor.constraint(equalTo: welcomeTextField.leadingAnchor),
             $0.trailingAnchor.constraint(equalTo: welcomeTextField.trailingAnchor),
             $0.heightAnchor.constraint(equalToConstant: 65.0)]
        }
        
        skipButton.activateConstraints {
            [$0.topAnchor.constraint(equalTo: completionTextField.bottomAnchor, constant: 15.0),
             $0.centerXAnchor.constraint(equalTo: view.centerXAnchor)]
        }
    }
    
    private func setViewsAlpha(views: [NSView], hidden: Bool = false, completion: (() -> Void)? = nil) {
        let animations: (NSAnimationContext) -> Void = { context in
            context.duration = 0.3
            context.allowsImplicitAnimation = true
            
            views.forEach { $0.alphaValue = hidden ? 0.0 : 1.0 }
            self.view?.layoutSubtreeIfNeeded()
        }
        
        NSAnimationContext.runAnimationGroup(animations) {
            completion?()
        }
    }
    
}

// MARK: - RebusViewDelegate

extension WelcomeScene: RebusViewDelegate {
    func didComplete() {
        setViewsAlpha(views: [completionTextField])
        speechSynthesizer.speak(text: completionTextField.stringValue)
    }
}

// MARK: - SpeechSynthesizerDelegate

extension WelcomeScene: SpeechSynthesizerDelegate {
    func didFinish() {
        switch state {
        case .initial: state = .isSpeaking
        case .isSpeaking:
            state = .finished
            presentRebusScene()
        default: return
        }
    }
    
    private func presentRebusScene() {
        let transition = SKTransition.moveIn(with: .up, duration: 0.5)
        let scene = RebusScene()
        
        if let subviews = view?.subviews {
            setViewsAlpha(views: subviews, hidden: true) {
                subviews.forEach { $0.removeFromSuperview() }
            }
        }
        
        emitter.reset()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
            self.view?.presentScene(scene, transition: transition)
        }
    }
}

// MARK: - FilledButtonDelegate

extension WelcomeScene: FilledButtonDelegate {
    func didTap(_ buttonType: ButtonActionType?) {
        guard state != .finished else { return }

        state = .finished
        speechSynthesizer.stop()
        presentRebusScene()
    }
}

// MARK - State

private enum SceneState {
    case initial
    case isSpeaking
    case finished
}
