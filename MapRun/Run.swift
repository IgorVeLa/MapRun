//
//  Run.swift
//  MapRun
//
//  Created by Igor L on 11/09/2024.
//

import Foundation
import CoreLocation
import _MapKit_SwiftUI

class Run {
    var title: String
    var locations: [CLLocation]
    var time: Double
    var distance: Double
    var pace: [Int]
    var speed: Double
    var routeLine: MapPolyline
    
    init(title: String, locations: [CLLocation], time: Double, distance: Double, pace: [Int], speed: Double, routeLine: MapPolyline) {
        self.title = title
        self.locations = locations
        self.time = time
        self.distance = distance
        self.pace = pace
        self.speed = speed
        self.routeLine = routeLine
    }
}
