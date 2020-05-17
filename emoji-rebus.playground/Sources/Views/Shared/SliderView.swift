import AppKit

protocol SliderDelegate: AnyObject {
    func didMoveToIndex(_ index: Int)
}

final class SliderView: NSView {
    weak var delegate: SliderDelegate?
    
    private lazy var slider: NSSlider = configure { slider in
        slider.cell = SliderCell()
        
        slider.target = self
        slider.action = #selector(sliderDidMove)
        slider.isContinuous = true
        slider.allowsTickMarkValuesOnly = true
    }
    
    private lazy var valueLabel: NSTextField = configure { textField in
        textField.alphaValue = 0.0
        textField.isEditable = false
        textField.isBezeled = false
        textField.alignment = .right
        textField.textColor = ColorStyle.darkGray
        textField.wantsLayer = true
        textField.layer?.cornerRadius = 5.0
        textField.alignment = .center
        textField.sizeToFit()
        textField.drawsBackground = true
        textField.backgroundColor = ColorStyle.white
        textField.font = .systemFont(ofSize: 14.0, weight: .semibold)
    }
    
    private lazy var stackView: NSStackView = configure { stackView in
        stackView.spacing = 5.0
    }
    
    fileprivate(set) var tracking: Bool = false {
        didSet {
            tracking ? showLabel() : hideLabel()
        }
    }
    
    init() {
        super.init(frame: .zero)
        
        [slider, valueLabel].forEach(stackView.addArrangedSubview(_:))
        addSubview(stackView)
        
        valueLabel.activateConstraints {
            [$0.widthAnchor.constraint(equalToConstant: 28.0)]
        }
        
        slider.activateConstraints {
            [$0.widthAnchor.constraint(equalToConstant: 100.0)]
        }
        
        stackView.activateConstraints {
            [$0.topAnchor.constraint(equalTo: topAnchor),
             $0.leadingAnchor.constraint(equalTo: leadingAnchor),
             $0.trailingAnchor.constraint(equalTo: trailingAnchor),
             $0.bottomAnchor.constraint(equalTo: bottomAnchor)]
        }
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func update(numberOfRebuses: Int) {
        slider.minValue = 0
        slider.maxValue = Double(numberOfRebuses - 1)
        slider.integerValue = Int(slider.maxValue)
        slider.numberOfTickMarks = numberOfRebuses
    }
    
    func updateValue(_ value: Int) {
        slider.intValue = Int32(value)
    }
    
    func setState(enabled: Bool) {
        slider.isEnabled = enabled
    }
    
    @objc private func sliderDidMove() {
        if !tracking {
            delegate?.didMoveToIndex(slider.integerValue)
        } else {
            valueLabel.stringValue = String(slider.intValue + 1)
        }
    }
    
    private func showLabel() {
        valueLabel.stringValue = String(slider.intValue)
        animateLabel(show: true)
    }
    
    private func hideLabel() {
        animateLabel(show: false)
    }
    
    private func animateLabel(show: Bool) {
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.1
            context.allowsImplicitAnimation = true
            
            self.valueLabel.alphaValue = show ? 1.0 : 0.0
        }
    }
}

final class SliderCell: NSSliderCell {
    private var sliderView: SliderView? { controlView?.superview?.superview as? SliderView }
    
    override func startTracking(at startPoint: NSPoint, in controlView: NSView) -> Bool {
        sliderView?.tracking = true
        return super.startTracking(at: startPoint, in: controlView)
    }
    
    override func stopTracking(last lastPoint: NSPoint, current stopPoint: NSPoint, in controlView: NSView, mouseIsUp flag: Bool) {
        super.stopTracking(last: lastPoint, current: stopPoint, in: controlView, mouseIsUp: flag)
        sliderView?.tracking = false
    }
    
}
