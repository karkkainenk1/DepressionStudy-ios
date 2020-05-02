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

class PedometerDataSource: NSObject, ORKValueRangeGraphChartViewDataSource {
    var plotPoints: [ORKValueRange] = []
    
    override init() {
        super.init()
        
        plotPoints = getPedometerForLastWeek()
    }
    
    func getPedometerForLastWeek() -> [ORKValueRange] {
        return stride(from: 6, through: 0, by: -1).map { (daysPast) -> Int in
            let date = Date.init(timeIntervalSinceNow: -86400*TimeInterval(daysPast)).startOfDay
            
            return getDataForDate(sensorName: SENSOR_PLUGIN_PEDOMETER, date: date).reduce(0, { (acc, x) -> Int in
                guard let x = x as? Dictionary<String, Any> else {
                    return acc
                }
                
                guard let num_steps = x["number_of_steps"] as? Int else {
                    return acc
                }
                
                return acc + num_steps
            })
        }.map {ORKValueRange(value: Double($0))}
    }

    func numberOfPlots(in graphChartView: ORKGraphChartView) -> Int {
        return 1
    }
    
    func graphChartView(_ graphChartView: ORKGraphChartView, dataPointForPointIndex pointIndex: Int, plotIndex: Int) -> ORKValueRange {
        print(pointIndex, plotPoints[pointIndex])
        return plotPoints[pointIndex]
    }

    func graphChartView(_ graphChartView: ORKGraphChartView, numberOfDataPointsForPlotIndex plotIndex: Int) -> Int {
        return plotPoints.count
    }

    func graphChartView(_ graphChartView: ORKGraphChartView, titleForXAxisAtPointIndex pointIndex: Int) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE"
        
        let daysPast = 6-pointIndex
        return dateFormatter.string(from: Date.init(timeIntervalSinceNow: TimeInterval(-86400*daysPast)))
    }
}
