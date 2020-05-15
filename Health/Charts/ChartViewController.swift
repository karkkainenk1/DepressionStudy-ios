//
//  ChartViewController.swift
//  Health
//
//  Created by Kimmo Kärkkäinen on 5/2/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import CareKit

class ChartViewController: OCKListViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    var processingTask: DispatchWorkItem?
    
    override func viewWillAppear(_ animated: Bool) {
        let processingTask = DispatchWorkItem {
            let conversations = getConversationsForLastWeek().map { CGFloat($0) }
            let steps = getPedometerForLastWeek().map { CGFloat($0) }
            let activity = getActivityForLastWeek()
            let noise = getNoiseForLastWeek().map { CGFloat($0) }
            
            DispatchQueue.main.sync {
                self.activityIndicator?.stopAnimating()
                self.clear()
                self.addPedometerChart(steps)
                self.addActivityChart(activity)
                self.addNoiseChart(noise)
                self.addConversationsChart(conversations)
            }
        }
        
        self.processingTask = processingTask
        
        DispatchQueue.global(qos: .default).async(execute: processingTask)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let processingTask = processingTask else {
            return
        }
        
        processingTask.cancel()
        self.processingTask = nil
    }
    
    func addPedometerChart(_ steps: [CGFloat]) {
        addChart(headerTitle: "Walking (Steps)", values: [steps], legend: [""], colors: [.systemTeal])
    }
    
    func addNoiseChart(_ hours: [CGFloat]) {
        addChart(headerTitle: "Noisy environment (Hours)", values: [hours], legend: [""], colors: [.systemTeal])
    }
    
    func addConversationsChart(_ hours: [CGFloat]) {
        addChart(headerTitle: "Conversations (Hours)", values: [hours], legend: [""], colors: [.systemTeal])
    }
    
    func addActivityChart(_ activity: [[String: Double]]) {
        let walking = activity.map { CGFloat($0["walking"] ?? 0) }
        let cycling = activity.map { CGFloat($0["cycling"] ?? 0) }
        let running = activity.map { CGFloat($0["running"] ?? 0) }
        
        addChart(headerTitle: "Activity (Hours)", values: [walking, running, cycling], legend: ["Walking", "Running", "Cycling"], colors: [.systemTeal, .systemPurple, .systemOrange])
    }
    
    func addChart(headerTitle: String, values: [[CGFloat]], legend: [String], colors: [UIColor]) {
        let chartView = OCKCartesianChartView(type: .bar)

        chartView.headerView.titleLabel.text = headerTitle
        chartView.graphView.dataSeries = (0..<values.count).map { OCKDataSeries(values: values[$0], title: legend[$0], color: colors[$0]) }
        chartView.graphView.horizontalAxisMarkers = (0..<values[0].count).map { self.getWeekday(forDaysPast: values[0].count-$0-1) }
        
        self.appendView(chartView, animated: false)
    }
    
    func getWeekday(forDaysPast daysPast: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE"
        
        return dateFormatter.string(from: Date.init(timeIntervalSinceNow: TimeInterval(-86400*daysPast)))
    }
}
