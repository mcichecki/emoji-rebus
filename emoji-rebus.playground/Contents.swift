import AppKit
import SpriteKit
import PlaygroundSupport

let scene = MainScene()
let viewRect = CGRect(origin: .zero, size: scene.sceneSize)
let view = SKView(frame: viewRect)
view.presentScene(scene)

PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
