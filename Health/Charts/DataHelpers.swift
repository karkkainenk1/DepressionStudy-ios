//
//  DataHelpers.swift
//  Health
//
//  Created by Kimmo Kärkkäinen on 5/2/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import AWAREFramework

func getDataForDate(sensorName: String, date: Date) -> [Any] {
    if let sensor = AWARESensorManager.shared().getSensor(sensorName) {
        if let storage = sensor.storage {
            let data = storage.fetchData(from: date.startOfDay, to: date.endOfDay)
            return data
        }
    }
    
    return []
}

func getDataForYesterday(sensorName: String) -> [Any] {
    return getDataForDate(sensorName: sensorName, date: Date.init(timeIntervalSinceNow: -86400).startOfDay)
}

func getPedometerForLastWeek() -> [Int] {
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
    }
}

func getNoiseForLastWeek() -> [Double] {
    return stride(from: 6, through: 0, by: -1).map { (daysPast) -> Double in
        let date = Date.init(timeIntervalSinceNow: -86400*TimeInterval(daysPast)).startOfDay
        let initialAcc = (0.0, date.timeIntervalSince1970, 1)
        
        let (total,_,_) = getDataForDate(sensorName: SENSOR_AMBIENT_NOISE, date: date).sorted(by: orderByDate).reduce(initialAcc, { (acc, entry) in
            let (total, prevTime, prevValue) = acc
            
            guard let currentEntry = entry as? Dictionary<String, Any>,
                let currentTime = currentEntry["timestamp"] as? TimeInterval,
                let currentValue = currentEntry["is_silent"] as? Int else {
                return (total, prevTime, 1)
            }
            
            if prevValue==0 {
                let timeDiff = (currentTime-prevTime)/1000/60/60
                let newTotal = total + timeDiff
                return (newTotal, currentTime, currentValue)
            } else {
                return (total, currentTime, currentValue)
            }
        })
    
        return total
    }
}

func getConversationsForLastWeek() -> [Double] {
    return stride(from: 6, through: 0, by: -1).map { (daysPast) -> Double in
        let date = Date.init(timeIntervalSinceNow: -86400*TimeInterval(daysPast)).startOfDay
        let initialAcc = (0.0, date.timeIntervalSince1970, 0)
        
        let (total,_,_) = getDataForDate(sensorName: SENSOR_PLUGIN_STUDENTLIFE_AUDIO, date: date).sorted(by: orderByDate).reduce(initialAcc, { (acc, entry) in
            let (total, prevTime, prevValue) = acc
            
            guard let currentEntry = entry as? Dictionary<String, Any>,
                let currentTime = currentEntry["timestamp"] as? TimeInterval,
                let currentValue = currentEntry["inference"] as? Int else {
                return (total, prevTime, 0)
            }
            if prevValue==2 {
                let timeDiff = (currentTime-prevTime)/1000/60/60
                let newTotal = total + timeDiff
                return (newTotal, currentTime, currentValue)
            } else {
                return (total, currentTime, currentValue)
            }
        })
    
        return total
    }
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
        
        let (accumulated,_,_) = getDataForDate(sensorName: SENSOR_IOS_ACTIVITY_RECOGNITION, date: date).sorted(by: orderByDate).reduce(initialAcc, { (acc, entry) in
            
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

func orderByDate(first: Any, second: Any) -> Bool {
    guard let first = first as? [String: Any],
        let second = second as? [String: Any],
        let timestamp1 = first["timestamp"] as? Double,
        let timestamp2 = second["timestamp"] as? Double else {
        return true
    }
    return timestamp1<timestamp2
}
