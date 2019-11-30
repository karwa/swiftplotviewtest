import SwiftPlot
import QuartzRenderer

// SwiftPlot - AppKit bridge.
#if canImport(AppKit)
import AppKit
public class PlotNSView: NSView {
    public var plot: Plot? {
        didSet { refreshPlot() }
    }
    public func refreshPlot() {
        setNeedsDisplay(bounds)
    }
    override public func draw(_ dirtyRect: NSRect) {
        guard let plot = plot else { return }
        let size = Size(bounds.size)
        let renderer = QuartzRenderer(externalContext: NSGraphicsContext.current!.cgContext, dimensions: size)
        plot.drawGraph(size: size, renderer: renderer)
    }
}
#endif

// SwiftPlot - UIKit bridge.
#if canImport(UIKit) && !os(watchOS) // watchOS UIKit doesn't have UIView.
import UIKit
public class PlotUIView: UIView {
    public var plot: Plot? {
        didSet { refreshPlot() }
    }
    public func refreshPlot() {
        setNeedsDisplay(bounds)
    }
    public override func draw(_ rect: CGRect) {
        guard let plot = plot else { return }
        let size = Size(bounds.size)
        // The specific CGContexts we get from UIKit are vertically flipped.
        let ctx = UIGraphicsGetCurrentContext()!
        let transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: CGFloat(size.height))
        ctx.concatenate(transform)
        let renderer = QuartzRenderer(externalContext: ctx, dimensions: size)
        plot.drawGraph(size: size, renderer: renderer)
    }
}
#endif

// SwiftPlot - SwiftUI bridge.
#if canImport(SwiftUI)
import SwiftUI

public struct PlotView {
    // TODO: Is there a cleaner way to do this?
    // We want setting a new Plot to invalidate the view.
    private class Box: ObservableObject {
        var plot: Plot? {
            willSet { self.objectWillChange.send() }
        }
    }
    @ObservedObject private var box = Box()
    
    public init(_ block: ()->Plot) {
        self.box.plot = block()
    }
    
    public init(_ layout: SubPlot.StackPattern = .horizontal, block: ()->[Plot]) {
        self.init {
            let subplot = SubPlot(layout: layout)
            subplot.plots = block()
            return subplot
        }
    }
}

// SwiftUI - AppKit bridge.
#if canImport(AppKit)
extension PlotView: NSViewRepresentable {
    public func makeNSView(context: Context) -> PlotNSView {
        let view = PlotNSView()
        view.plot = box.plot
        return view
    }
    public func updateNSView(_ nsView: PlotNSView, context: Context) {
        nsView.plot = box.plot
    }
}
#endif

// SwiftUI - UIKit bridge.
#if canImport(UIKit) && !os(watchOS)
extension PlotView: UIViewRepresentable {
    public func makeUIView(context: Context) -> PlotUIView {
        let view = PlotUIView()
        view.plot = box.plot
        return view
    }
    public func updateUIView(_ uiView: PlotUIView, context: Context) {
        uiView.plot = box.plot
    }
}
#endif

// SwiftUI fallback implementation.
#if os(watchOS)
@available(watchOS 6.0, *)
extension PlotView: View {
    public var body: some View {
        GeometryReader { proxy -> Image in
            let renderer = QuartzRenderer(size: Size(proxy.size))
            _ = self.box.plot?.drawGraph(size: renderer.imageSize, renderer: renderer)
            return Image(renderer.makeCGImage()!, scale: 1, label: Text(""))
        }
    }
}
#endif

#endif // canImport(SwiftUI)
