import AppKit

func configure<View: NSView>(config: (View) -> Void = { _ in return }) -> View {
    let view = View()
    view.translatesAutoresizingMaskIntoConstraints = false
    config(view)
    return view
}
