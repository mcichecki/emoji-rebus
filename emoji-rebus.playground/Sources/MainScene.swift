import AppKit
import SpriteKit

public final class MainScene: SKScene {
    public let sceneSize = CGSize(width: 400, height: 560)
    
    private let frameWidth: CGFloat
    private let frameHeight: CGFloat
    
    public override init() {
        self.frameWidth = sceneSize.width
        self.frameHeight = sceneSize.height
        super.init(size: sceneSize)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    public override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        scene?.backgroundColor = .darkGray
        
        let inputView = InputView(numberOfLetters: 5)
        view.addSubview(inputView)
        inputView.translatesAutoresizingMaskIntoConstraints = false
        let inputViewConstraints = [
            inputView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            inputView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            inputView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50.0),
//            inputView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50.0),
            inputView.heightAnchor.constraint(equalToConstant: 200.0)
        ]
        NSLayoutConstraint.activate(inputViewConstraints)
    }
}

// MARK: - NSTextFieldDelegate

extension MainScene: NSTextFieldDelegate {
    public func controlTextDidChange(_ obj: Notification) {
        //        print("--- obj: \(obj.object as? NSTextField)")
        guard let textField = obj.object as? NSTextField else { return }
        print(textField.stringValue)
    }
}
