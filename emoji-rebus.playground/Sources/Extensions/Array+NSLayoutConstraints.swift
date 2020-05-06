import AppKit

extension Array where Element == Array<NSLayoutConstraint> {
    func activate() {
        self.forEach(NSLayoutConstraint.activate(_:))
    }
}
