import AppKit

enum ArrowDirection: Int { case left = -1, right = 1 }

protocol ArrowButtonDelegate: AnyObject {
    func didTapArrowButton(direction: ArrowDirection)
}

final class ArrowButton: NSButton {
    
    weak var delegate: ArrowButtonDelegate?
    
    let direction: ArrowDirection
    
    init(direction: ArrowDirection) {
        self.direction = direction
        super.init(frame: .zero)
        
        setUpStyling()
        
        target = self
        action = #selector(didTap)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func draw(_ dirtyRect: NSRect) {
        let width = bounds.width
        let height = bounds.height
        
        NSColor.white.set()
        
        var points: [(x: CGFloat, y: CGFloat)] = [(0.8, 0.9), (0.4, 0.5), (0.8, 0.1)]
        if direction == .right {
            points = points.map { (1 - $0, $1) }
        }
        
        let path = NSBezierPath()
        guard let firstPoint = points.first else { return }
        path.move(to: CGPoint(x: width * firstPoint.x, y: height * firstPoint.y))
        Array(points.dropFirst()).forEach { point in
            path.line(to: CGPoint(x: width * point.0, y: height * point.1))
        }
        
        path.lineWidth = 6
        path.stroke()
    }
    
    private func setUpStyling() {
        imagePosition = .imageOnly
        isBordered = false
        imageScaling = .scaleProportionallyDown
    }
    
    @objc private func didTap() {
        delegate?.didTapArrowButton(direction: direction)
    }
}
