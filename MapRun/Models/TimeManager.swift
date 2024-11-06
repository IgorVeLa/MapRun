//
//  TimeManager.swift
//  MapRun
//
//  Created by Igor L on 30/10/2024.
//

import Foundation

@Observable
class TimeManager {
    static let shared = TimeManager()
    
    var totalTimeInS: Double = 0.0
    
    var hoursUnit: Int {
        return Int(totalTimeInS / 3600)
    }
    
    var minutesUnit: Int {
        return Int(totalTimeInS / 60) % 60
    }
    
    var secondsUnit: Int {
        return Int(totalTimeInS) % 60
    }
    
    var formattedUnits: String {
        return String(format: "%02d:%02d:%02d", hoursUnit, minutesUnit, secondsUnit)
    }
}
