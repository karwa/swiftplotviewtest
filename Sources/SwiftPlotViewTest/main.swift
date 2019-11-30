// !/usr/bin/swift

//
// - This is just some AppKit boilerplate to launch a window.
//
import AppKit
@available(OSX 10.15, *)
class AppDelegate: NSObject, NSApplicationDelegate {
    let window = NSWindow()
    let windowDelegate = WindowDelegate()
    func applicationDidFinishLaunching(_ notification: Notification) {
        let contentSize = NSSize(width:800, height:600)
        window.setContentSize(contentSize)
        window.styleMask = [.titled, .closable, .miniaturizable, .resizable]
        window.level = .floating
        window.delegate = windowDelegate
        window.title = "GraphView"
        
        let graph = NSHostingView(rootView: DemoView())
        graph.frame = NSRect(origin: NSPoint(x:0, y:0), size: contentSize)
        graph.autoresizingMask = [.height, .width]
        window.contentView!.addSubview(graph)
        window.center()
        window.makeKeyAndOrderFront(window)
    }
    class WindowDelegate: NSObject, NSWindowDelegate {
        func windowWillClose(_ notification: Notification) {
            NSApplication.shared.terminate(0)
        }
    }
}

//
// - This is the actual view.
//

import SwiftPlot
import SwiftUI

struct DemoView: View {
    @State private var values = [Int]()
    @State private var historyLength = 100
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    func advanceGraph() {
        values.append(contentsOf: (0...5).lazy.map { _ in Int.random(in: 20...30) })
        values[...] = values.suffix(historyLength)
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("SwiftPlot meets SwiftUI").font(.headline).colorScheme(.dark)
            }.padding(10)
            List {
                PlotView { demo_lineGraph }
                    .background(Color.white)
                    .frame(height: 400)
                PlotView { demo_gridPlots }
                    .frame(height: 600)
                PlotView {
                    let plot = LineGraph<Float, Float>()
                    plot.enablePrimaryAxisGrid = true
                    plot.addSeries(values.reversed().map { Float($0) }, label: "", color: .red)
                    plot.plotTitle.title = "Network congestion"
                    return plot
                }.frame(height: 150)
                    .onReceive(timer) { _ in self.advanceGraph() }
            }
        }
    }
}




//
// - More AppKit boilerplate.
//

let app = NSApplication.shared
let del = AppDelegate()
app.delegate = del
app.run()
