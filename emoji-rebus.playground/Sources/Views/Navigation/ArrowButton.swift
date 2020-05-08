import AppKit

enum ArrowDirection { case left, right }

protocol ArrowButtonDelegate: AnyObject {
    func didTapArrowButton(direction: ArrowDirection)
}

final class ArrowButton: NSButton {
    
    weak var delegate: ArrowButtonDelegate?
    
    let direction: ArrowDirection
    
    init(direction: ArrowDirection) {
        self.direction = direction
        super.init(frame: .zero)
        
        setUpImage()
        setUpStyling()
        
        target = self
        action = #selector(didTap)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setUpImage() {
        switch direction {
        case .left: image = NSImage(named: "left_arrow")
        case .right: image = NSImage(named: "right_arrow.png")
        }
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
