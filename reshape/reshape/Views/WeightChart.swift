//
//  WeightChart.swift
//  reshape
//
//  Created by Иван Фомин on 22.04.2022.
//

import UIKit
import Charts

protocol WeightChartDelegate: AnyObject {
    func numberOfDays(in weighchart: WeightChart) -> Int
    func weightChart(_ weighchart: WeightChart, numOfData number: Int) -> ChartDataEntry
    func daysForVisual(_ weighchart: WeightChart, numOfData number: Int) -> String
}

class WeightChart: LineChartView {
    weak var weightDelegate: WeightChartDelegate?
    private var numOfLastDay: Int = 0
    private var dateFormatter = DateChartFormatter()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        setupChart()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        reloadData()
    }
    
    func reloadData() {
        leftAxis.resetCustomAxisMax()
        leftAxis.resetCustomAxisMin()
        
        // Исполняемый механизм по числу дней
        numOfLastDay = weightDelegate?.numberOfDays(in: self) ?? 0
        if numOfLastDay == 0 { return }
        var dateArray: [String] = []
        var weightData: [ChartDataEntry] = []
        for i in 0...numOfLastDay {
            guard let currentData = weightDelegate?.weightChart(self, numOfData: numOfLastDay-i) else {
                print("[WEIGHTCHART] Can't get data at \(i) position")
                continue
            }
            currentData.x = Double(i)
            weightData.insert(currentData, at: i)
            dateArray.insert(weightDelegate?.daysForVisual(self, numOfData: numOfLastDay-i) ?? "", at: i)
        }
        dateFormatter.uploadDaysString(from: dateArray)
        setData(entries: weightData)
        leftAxis.axisMinimum = leftAxis.entries.min() ?? 0
        leftAxis.axisMaximum = leftAxis.entries.max() ?? 0
    }
    
    private func setData(entries: [ChartDataEntry]) {
        let set = LineChartDataSet(entries: entries)
        set.lineWidth = 2
        set.setColor(.violetColor)
        set.circleRadius = 4
        set.circleColors = [.violetColor]
        set.drawCircleHoleEnabled = false
        set.drawValuesEnabled = false
        set.drawHorizontalHighlightIndicatorEnabled = false
        set.drawVerticalHighlightIndicatorEnabled = false
        self.data = LineChartData(dataSet: set)
    }
    
    func setupChart() {
        noDataText = "Загрузка данных..."
        legend.enabled = false
        setViewPortOffsets(left: 25, top: 16, right: 16, bottom: 16)
        doubleTapToZoomEnabled = false
        pinchZoomEnabled = false
        
        rightAxis.enabled = false
        
        leftAxis.enabled = true
        leftAxis.labelFont = .systemFont(ofSize: 9)
        leftAxis.labelTextColor = .white
        leftAxis.axisLineDashLengths = [5, 5]
        leftAxis.axisLineColor = .lightGrayColor
        leftAxis.axisLineWidth = 1
        leftAxis.spaceBottom = 0.5
        leftAxis.spaceTop = 0.5
        leftAxis.xOffset = 7
        
        leftAxis.gridLineDashLengths = [5, 5]
        leftAxis.gridLineWidth = 1
        leftAxis.gridColor = .lightGrayColor
        
        leftAxis.labelCount = 5
        leftAxis.granularity = 1
        
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 9)
        xAxis.labelTextColor = .white
        xAxis.axisLineDashLengths = [5, 5]
        xAxis.axisLineColor = .lightGrayColor
        xAxis.axisLineWidth = 1
        
        xAxis.gridLineDashLengths = [5, 5]
        xAxis.gridLineWidth = 1
        xAxis.gridColor = .lightGrayColor
        xAxis.valueFormatter = dateFormatter
        xAxis.granularity = 1
    }
}

final class DateChartFormatter: AxisValueFormatter {
    private var daysString: [String] = []
    
    func uploadDaysString(from string: [String]) {
        daysString = string
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return daysString[Int(value)]
    }
}
