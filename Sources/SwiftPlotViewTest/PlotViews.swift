import SwiftPlot
import QuartzRenderer
#if canImport(AppKit)
import AppKit

public class PlotNSView: NSView {
    public var plot: Plot? {
        didSet { setNeedsDisplay(bounds) }
    }
    override public func draw(_ dirtyRect: NSRect) {
        guard let plot = plot else { return }
        let size = Size(bounds.size)
        let renderer = QuartzRenderer(externalContext: NSGraphicsContext.current!.cgContext, dimensions: size)
        plot.drawGraph(size: size, renderer: renderer)
    }
}
#endif

#if canImport(SwiftUI)
import SwiftUI

public struct PlotView: View {
    // TODO: Is there some way to replace this with a @State variable?
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

#endif // canImport(SwiftUI)
