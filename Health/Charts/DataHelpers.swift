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
