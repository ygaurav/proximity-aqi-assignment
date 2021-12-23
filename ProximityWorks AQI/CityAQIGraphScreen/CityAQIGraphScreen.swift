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
        
        let leftAxis = chartView.getAxis(.left)
        leftAxis.axisMinimum = 0
        leftAxis.axisMaximum = 500
        
        chartView.xAxis.valueFormatter = XAxisValueFormatter()
        
        chartView.getAxis(.right).enabled = false
    }
    
    private func setupChartConstraints() {
        chartView.topAnchor ==||== doneButton.bottomAnchor
        chartView.leadingAnchor ==||== view.leadingAnchor
        view.trailingAnchor ==||== chartView.trailingAnchor
        view.bottomAnchor ==||== chartView.bottomAnchor
    }
    
    func update(history: [DataPoint]) {
        print(history)
        let entries = history.map { ChartDataEntry(x: $0.x, y: $0.y) }
        
        DispatchQueue.main.async {
            self.chartView.data = LineChartData(dataSet: self.lineChartDataSet(with: entries))
        }
    }
    
    func lineChartDataSet(with entries: [ChartDataEntry]) -> LineChartDataSet {
        let dataSet = LineChartDataSet(entries: entries, label: "AQI")
        
        dataSet.mode = .cubicBezier
        dataSet.drawCirclesEnabled = false
        dataSet.lineWidth = 2
        dataSet.circleRadius = 4
        dataSet.setCircleColor(.blue)
        dataSet.highlightColor = .systemPink
        dataSet.fillColor = .systemGreen
        dataSet.fillAlpha = 1

        return dataSet
    }
}

class XAxisValueFormatter: AxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        "\(Int(value * -1)) secs"
    }
}
