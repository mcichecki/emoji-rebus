//: A Cocoa based Playground to present user interface

import AppKit
import PlaygroundSupport
import SpriteKit

//let viewController = MainViewController()

//print(viewController.view)
// Present the view in Playground

let scene = MainScene()
let viewRect = CGRect(origin: .zero, size: scene.sceneSize)
let view = SKView(frame: viewRect)
view.presentScene(scene)

PlaygroundPage.current.liveView = view
PlaygroundPage.current.needsIndefiniteExecution = true
