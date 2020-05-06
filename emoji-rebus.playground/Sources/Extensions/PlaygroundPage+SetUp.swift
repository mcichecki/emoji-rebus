import PlaygroundSupport
import SpriteKit

public extension PlaygroundPage {
    func setUpScene(_ scene: SizeableScene) {
        let viewRect = CGRect(origin: .zero, size: scene.size)
        let view = SKView(frame: viewRect)
        view.presentScene(scene)
        
        liveView = view
    }
}
