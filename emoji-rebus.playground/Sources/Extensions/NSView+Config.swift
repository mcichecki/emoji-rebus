import AppKit

func configure<View: NSView>(config: (View) -> Void = { _ in return }) -> View {
    let view = View()
    view.translatesAutoresizingMaskIntoConstraints = false
    config(view)
    return view
}

// MARK: - Constraints

extension NSView {
    // TODO: Replace with ...?
    func activateConstraints(_ apply: (NSView) -> [NSLayoutConstraint]) {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(apply(self))
    }
}

// MARK: - Views

extension NSView {
    func addSubviews(_ views: NSView...) {
        views.forEach(addSubview(_:))
    }
}
