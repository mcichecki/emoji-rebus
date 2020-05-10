import AppKit
import SpriteKit
import Foundation

public final class WelcomeScene: SKScene, SizeableScene {
    public let sceneSize = CGSize(width: 560, height: 540)
    
    private lazy var welcomeTextField: NSTextField = configure { textField in
        textFieldConfig(textField)
        textField.stringValue = """
        Today you have a chance to solve rebuses and learn about ecology and our planet Earth.
        Rebuses in this playground consist of letters and emojis.
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
        In case of any problems, you can use hint in the top left corner.
        Good luck!
        """
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
    private var indexOfFinish = 0
    
    public override init() {
        super.init(size: sceneSize)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    public override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        setUpViews()
        setUpConstraints()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.setViewsAlpha(views: [self.welcomeRebusView])
        }
        
        speechSynthesizer.speechSynthesizerDelegate = self
        speechSynthesizer.speak(text: welcomeTextField.stringValue)
    }
    
    private func setUpViews() {
        guard let view = view else { return }
        view.addSubviews(welcomeTextField, welcomeRebusView, completionTextField)
    }
    
    private func setUpConstraints() {
        guard let view = view else { return }
        
        welcomeTextField.activateConstraints {
            [$0.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.0),
             $0.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.0),
             $0.heightAnchor.constraint(equalToConstant: 65.0),
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
        indexOfFinish += 1
        
        if indexOfFinish > 1 {
            presentMainScene()
        }
    }
    
    private func presentMainScene() {
        let transition = SKTransition.moveIn(with: .up, duration: 0.5)
        let scene = MainScene()
        
        if let subviews = view?.subviews {
            setViewsAlpha(views: subviews, hidden: true) {
                subviews.forEach { $0.removeFromSuperview() }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            self.view?.presentScene(scene, transition: transition)
        }
    }
}