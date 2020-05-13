import Foundation
import AppKit

extension String {
    func emojiImage(width: Int = 70, height: Int = 70, imageAlpha alpha: CGFloat = 0.2) -> NSImage? {
        let size = 24
        let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue
        )
        context?.setAlpha(alpha)
        
        guard width > size, !self.isEmpty, let drawingContext = context, let firstLetter = first else { return nil }
        
        let imageSize = NSSize(width: width, height: height)
        let targetRect = NSRect(origin: .zero, size: imageSize)
        let font = NSFont.systemFont(ofSize: CGFloat(width - size))
        
        NSGraphicsContext.saveGraphicsState()
        
        NSGraphicsContext.current = NSGraphicsContext(cgContext: drawingContext, flipped: false)
        NSString(string: String(firstLetter)).draw(in: targetRect, withAttributes: [.font: font])
        NSGraphicsContext.restoreGraphicsState()
        
        guard let coreImage = drawingContext.makeImage() else { return nil }
        return NSImage(cgImage: coreImage, size: imageSize)
    }
}
