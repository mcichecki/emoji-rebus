import AppKit

protocol SliderDelegate: AnyObject {
    func didMoveToIndex(_ index: Int)
}

final class Slider: NSSlider {
    weak var delegate: SliderDelegate?
    
    init() {
        super.init(frame: .zero)
        
        target = self
        action = #selector(sliderDidMove)
        
        isContinuous = false
        allowsTickMarkValuesOnly = true
        numberOfTickMarks = 5
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func update(numberOfRebuses: Int) {
        minValue = 0
        maxValue = Double(numberOfRebuses - 1)
        integerValue = Int(maxValue)
        numberOfTickMarks = numberOfRebuses
    }
    
    @objc private func sliderDidMove() {
        print("--- didMove: \(integerValue)")
        delegate?.didMoveToIndex(integerValue)
    }
}
