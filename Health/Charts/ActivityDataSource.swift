//
//  LineGraphDataSource.swift
//  Health
//
//  Created by Kimmo Kärkkäinen on 5/2/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import ResearchKit
import AWAREFramework

class ActivityDataSource: NSObject, ORKValueRangeGraphChartViewDataSource {
    var activity: [[String: Double]] = []
    
    override init() {
        super.init()
        
        activity = getActivityForLastWeek()
    }
    
    func getActivityForLastWeek() -> [[String: Double]] {
        let initialValues: [String: Double] = [
            "automotive": 0,
            "cycling": 0,
            "running": 0,
            "stationary": 0,
            "unknown": 0,
            "walking": 0
        ]
        
        let initialEntry: [String: Any] = [:]
        
        return stride(from: 6, through: 0, by: -1).map { (daysPast) -> [String: Double] in
            let date = Date.init(timeIntervalSinceNow: -86400*TimeInterval(daysPast)).startOfDay
            let initialAcc = (initialValues, initialEntry, date.timeIntervalSince1970)
            
            let (accumulated,_,_) = getDataForDate(sensorName: SENSOR_IOS_ACTIVITY_RECOGNITION, date: date).sorted(by: { (first, second) -> Bool in
                    guard let first = first as? [String:Any] else {
                        return true
                    }
                    guard let second = second as? [String:Any] else {
                        return true
                    }
                    guard let timestamp1 = first["timestamp"] as? Double else {
                        return true
                    }
                    guard let timestamp2 = second["timestamp"] as? Double else {
                        return true
                    }
                    return timestamp1<timestamp2
            }).reduce(initialAcc, { (acc, entry) in
                
                let (accumulated, prevEntry, prevTime) = acc
                guard let currentEntry = entry as? Dictionary<String, Any> else {
                    return (accumulated, prevEntry, prevTime)
                }
                
                guard let currentTime = currentEntry["timestamp"] as? TimeInterval else {
                    return (accumulated, prevEntry, prevTime)
                }
                
                let newAccumulated = accumulated.map { k, v -> (String, Double) in
                    if let prevValue = prevEntry[k] as? Int, prevValue==1 {
                        return (k, v + (currentTime-prevTime)/1000/60/60)
                    } else {
                        return (k, v)
                    }
                }
                
                let newAccumulatedDict = Dictionary.init(uniqueKeysWithValues: newAccumulated)
                
                return (newAccumulatedDict, currentEntry, currentTime)
            })
            
            return accumulated
        }
    }

    func numberOfPlots(in graphChartView: ORKGraphChartView) -> Int {
        return 1
    }
    
    func graphChartView(_ graphChartView: ORKGraphChartView, dataPointForPointIndex pointIndex: Int, plotIndex: Int) -> ORKValueRange {
        let walking = activity[pointIndex]["walking"] ?? 0
        let cycling = activity[pointIndex]["cycling"] ?? 0
        let running = activity[pointIndex]["running"] ?? 0
        let total = walking + cycling + running
        return ORKValueRange(value: total)
    }

    func graphChartView(_ graphChartView: ORKGraphChartView, numberOfDataPointsForPlotIndex plotIndex: Int) -> Int {
        return activity.count
    }

    func graphChartView(_ graphChartView: ORKGraphChartView, titleForXAxisAtPointIndex pointIndex: Int) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE"
        
        let daysPast = 6-pointIndex
        return dateFormatter.string(from: Date.init(timeIntervalSinceNow: TimeInterval(-86400*daysPast)))
    }
}
