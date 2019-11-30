import SwiftPlot
import Foundation

let demo_lineGraph: Plot = {
    let lineGraph = LineGraph<Float,Float>(enablePrimaryAxisGrid: true,
                                           enableSecondaryAxisGrid: false)
    let clamp: ClosedRange<Float>? = -150...150
    lineGraph.addFunction({ pow($0, 2) }, minX: -5, maxX: 5, clampY: clamp, label: "2", color: .lightBlue)
    lineGraph.addFunction({ pow($0, 3) }, minX: -5, maxX: 5, clampY: clamp, label: "3", color: .orange)
    lineGraph.addFunction({ pow($0, 4) }, minX: -5, maxX: 5, clampY: clamp, label: "4", color: .red)
    lineGraph.addFunction({ pow($0, 5) }, minX: -5, maxX: 5, clampY: clamp, label: "5", color: .brown)
    lineGraph.addFunction({ pow($0 , 6) }, minX: -5, maxX: 5, clampY: clamp, label: "6", color: .purple)
    lineGraph.addFunction({ pow($0 , 7) }, minX: -5, maxX: 5, clampY: clamp, label: "6", color: .green)
    lineGraph.plotTitle.title = "GraphView Demo"
    lineGraph.plotLabel.xLabel = "x"
    lineGraph.plotLabel.yLabel = "y"
            lineGraph.backgroundColor = .transparent
    return lineGraph
}()

let demo_gridPlots: Plot = {
    let sub = SubPlot(layout: .grid(rows: 2, columns: 2))

    let x:[Float] = [0,100,263,489]
    let y:[Float] = [0,320,310,170]

    let lineGraph1 = LineGraph<Float,Float>(enablePrimaryAxisGrid: true)
    lineGraph1.addSeries(x, y, label: "Plot 1", color: .lightBlue)
    lineGraph1.plotTitle = PlotTitle("PLOT 1")
    lineGraph1.plotLabel = PlotLabel(xLabel: "X-AXIS", yLabel: "Y-AXIS", labelSize: 12)
    lineGraph1.markerTextSize = 10

    let lineGraph2 = LineGraph<Float,Float>(enablePrimaryAxisGrid: true)
    lineGraph2.addSeries(x, y, label: "Plot 2", color: .orange)
    lineGraph2.plotTitle = PlotTitle("PLOT 2")
    lineGraph2.plotLabel = PlotLabel(xLabel: "X-AXIS", yLabel: "Y-AXIS", labelSize: 12)
    lineGraph2.markerTextSize = 10

    let lineGraph3 = LineGraph<Float,Float>(enablePrimaryAxisGrid: true)
    lineGraph3.addSeries(x, y, label: "Plot 3", color: .brown)
    lineGraph3.plotTitle = PlotTitle("PLOT 3")
    lineGraph3.plotLabel = PlotLabel(xLabel: "X-AXIS", yLabel: "Y-AXIS", labelSize: 12)
    lineGraph3.markerTextSize = 10

    let lineGraph4 = LineGraph<Float,Float>(enablePrimaryAxisGrid: true)
    lineGraph4.addSeries(x, y, label: "Plot 4", color: .green)
    lineGraph4.plotTitle = PlotTitle("PLOT 4")
    lineGraph4.plotLabel = PlotLabel(xLabel: "X-AXIS", yLabel: "Y-AXIS", labelSize: 12)
    lineGraph4.markerTextSize = 10

    sub.plots.append(lineGraph1)
    sub.plots.append(lineGraph2)
    sub.plots.append(lineGraph3)
//    sub.plots.append(lineGraph4)

    let sub2 = SubPlot(layout: .horizontal)
    sub2.plots.append(lineGraph3)
    sub2.plots.append(lineGraph4)

    sub.plots.append(sub2)
    return sub
}()
