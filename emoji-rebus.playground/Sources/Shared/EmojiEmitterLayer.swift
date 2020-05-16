import Foundation
import AppKit

final class EmojiEmitterLayer: CAEmitterLayer {
    enum State {
        case welcome, rebus
        
        var scale: CGFloat {
            switch self {
            case .welcome: return 0.4
            case .rebus: return 0.7
            }
        }
        
        var scaleRange: CGFloat {
            switch self {
            case .welcome: return 0.2
            case .rebus: return 0.9
            }
        }
        
        
    }
    
    private var emojis: [String] = []
    private var images: [NSImage] { emojis.compactMap { $0.emojiImage() } }
    private var velocities: [CGFloat] { emojis.map { _ in CGFloat.random(in: 40...80) } }
    private var numberOfEmojis: Int { emojis.count }
    private var randomNumber: Int { .random(in: 0 ..< numberOfEmojis) }
    private var randomVelocity: CGFloat { velocities[randomNumber] }
    
    init(frameSize: CGRect) {
        super.init()
        
        emitterPosition = CGPoint(x: frameSize.width / 2, y: -10)
        emitterShape = CAEmitterLayerEmitterShape.line
        emitterSize = CGSize(width: frameSize.width, height: 2.0)
    }
    
    func updateEmojis(_ emojis: [String], state: State = .rebus) {
        self.emojis = emojis
        emitterCells = generateEmitterCells(state: state)
    }
    
    func reset() {
        self.emojis = []
        emitterCells = generateEmitterCells(state: .rebus)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func generateEmitterCells(state: State) -> [CAEmitterCell] {
        (0 ..< numberOfEmojis)
            .map { index in
                let cell = CAEmitterCell()
                
                cell.birthRate = 2.5
                cell.lifetime = 15.0
                cell.lifetimeRange = 5.0
                cell.velocity = randomVelocity
                cell.velocityRange = 20
                cell.emissionLongitude = randomNumber % 2 == 0 ? .pi : -.pi
                cell.emissionRange = 0.5
                cell.spin = randomNumber % 2 == 0 ? 1 : -1
                cell.spinRange = 2.0
                cell.contents = getNextImage(i: index)
                cell.scale = state.scale
                cell.scaleRange = state.scaleRange
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
