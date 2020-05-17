import SpriteKit

public protocol SizeableScene where Self: SKScene {
    var sceneSize: CGSize { get }
}
