//
//  CityAQIGraphScreen.swift
//  ProximityWorks AQI
//
//  Created by Gaurav Yadav on 21/12/21.
//

import UIKit
import Charts

class CityAQIGraphViewController: UIViewController, CityAQIHistoryViewModelDelegate {
    
    var viewModel: CityAQIGraphViewModel!
    
    @IBOutlet weak var doneButton: UIButton!
    
    private var chartView: LineChartView = {
        let chart = LineChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        return chart
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(chartView)
        
        setupChartView()
        setupChartConstraints()
        
        viewModel.onLoad()
    }
    
    @IBAction func onDone(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    func setupChartView() {
        chartView.dragEnabled = false
        chartView.pinchZoomEnabled = false
        chartView.drawGridBackgroundEnabled = false
        
        chartView.xAxis.valueFormatter = XAxisValueFormatter()
        
        chartView.getAxis(.right).enabled = false
    }
    
    private func setupChartConstraints() {
        chartView.topAnchor ==||== doneButton.bottomAnchor
        chartView.safeAreaLayoutGuide.leadingAnchor ==||== view.safeAreaLayoutGuide.leadingAnchor
        view.safeAreaLayoutGuide.trailingAnchor ==||== chartView.safeAreaLayoutGuide.trailingAnchor
        view.safeAreaLayoutGuide.bottomAnchor ==||== chartView.safeAreaLayoutGuide.bottomAnchor
    }
    
    func update(history: [DataPoint]) {
        let entries = history.map { ChartDataEntry(x: $0.x, y: $0.y) }
    
        // Graph's Y axis
        // Min is 50 less than minimum value of chart data point
        // Max is 50 more than maximum value of chart data point
        // This is to show visible deviation i AQI's 0-500 is too big, & only a range of 10 looks wildly exaggerated changes
        let minY = entries.min { $0.y < $1.y }?.y ?? 0
        let maxY = entries.max { $0.y > $1.y }?.y ?? 500
        
        let leftAxis = chartView.getAxis(.left)
        leftAxis.axisMinimum = max(0, minY - 50)
        leftAxis.axisMaximum = min(500, maxY + 50)
        
        DispatchQueue.main.async {
            self.chartView.data = LineChartData(dataSet: self.lineChartDataSet(with: entries))
        }
    }
    
    func lineChartDataSet(with entries: [ChartDataEntry]) -> LineChartDataSet {
        let dataSet = LineChartDataSet(entries: entries, label: "AQI")
        
        dataSet.mode = .cubicBezier
        dataSet.drawCirclesEnabled = false
        dataSet.lineWidth = 1.5
        dataSet.setColor(.systemBlue)
        return dataSet
    }
}

class XAxisValueFormatter: AxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        "\(Int(value * -1)) secs"
    }
}
