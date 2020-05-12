import Foundation
import AppKit

final class EmojiEmitterLayer: CAEmitterLayer {
    private let emojis = ["🏀", "✅", "🙄"]
    private lazy var images = emojis.compactMap { $0.emojiImage() }
    private lazy var velocities = emojis.map { _ in CGFloat.random(in: 80...150) }
    private var numberOfEmojis: Int { emojis.count }
    private var randomNumber: Int { .random(in: 0 ..< numberOfEmojis) }
    private var randomVelocity: CGFloat { velocities[randomNumber] }

    init(frameSize: CGRect) {
        super.init()
        
        emitterPosition = CGPoint(x: frameSize.width / 2, y: -10)
        emitterShape = CAEmitterLayerEmitterShape.line
        emitterSize = CGSize(width: frameSize.width, height: 2.0)
        emitterCells = generateEmitterCells()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func generateEmitterCells() -> [CAEmitterCell] {
        (0 ..< numberOfEmojis)
            .map { index in
                let cell = CAEmitterCell()
                
                cell.birthRate = 4.0
                cell.lifetime = 15.0
                cell.lifetimeRange = 5.0
                cell.velocity = randomVelocity
                cell.velocityRange = 0
                cell.emissionLongitude = randomNumber % 2 == 0 ? .pi : -.pi
                cell.emissionRange = 0.5
                cell.spin = randomNumber % 2 == 0 ? 1 : -1
                cell.spinRange = 0.5
                cell.contents = getNextImage(i: index)
                cell.scale = 0.8
                cell.scaleRange = 0.8
                cell.alphaRange = 0.5
                
                return cell
        }
    }
    
    private func getNextImage(i: Int) -> CGImage {
        let image = images[i % numberOfEmojis]
        var imageRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        let cgImage = image.cgImage(forProposedRect: &imageRect, context: nil, hints: nil)!
        return cgImage
    }
}