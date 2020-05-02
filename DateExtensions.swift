//
//  DateExtensions.swift
//  Health
//
//  Created by Kimmo Kärkkäinen on 5/1/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
}

