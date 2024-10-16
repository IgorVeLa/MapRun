//
//  Methods.swift
//  MapRun
//
//  Created by Igor L on 15/10/2024.
//

import CoreLocation
import Foundation

extension PersistenceManager {
    static func toCLLCoordinates(locations: [CLLocation]) -> [CLLocationCoordinate2D] {
        var coordinates = [CLLocationCoordinate2D]()
        
        for location in locations {
            //print(location)
            coordinates.append(location.coordinate)
        }
        
        return coordinates
    }
    
    static func toCLLocations(coords: [CLLocationCoordinate2D]) -> [CLLocation] {
        var locations = [CLLocation]()
        
        for coord in coords {
            locations.append(CLLocation(latitude: coord.latitude, longitude: coord.longitude))
        }
        
        return locations
    }
    
    static func measureTotalDistanceInKm(locations: [CLLocation]) -> Double {
        guard locations.count > 1 else {
            print("No locations found or only 1 location was given")
            return 0.0
        }
        
        var totalDistance = 0.0
        
        for locationIndex in 1..<locations.count { // Start from index 1 to avoid out-of-bound issues
            let previousLocation = locations[locationIndex - 1]
            let currentLocation = locations[locationIndex]
            
            totalDistance += currentLocation.distance(from: previousLocation)
        }
        
        totalDistance = totalDistance / 1000
        
        return totalDistance
    }
    
    static func measureSpeed(locations: [CLLocation]) -> Double {
        guard locations.last != nil else {
            print("No locations found")
            return 0.0
        }
        
        var totalSpeed = 0.0
        
        locations.forEach { location in
            let speed = location.speed
            totalSpeed += speed
        }
        
        let avgSpeedMps = totalSpeed / Double(locations.count)
        
        return avgSpeedMps
    }
    
    static func measurePace(locations: [CLLocation], totalTime: Double) -> [Int] {
        guard locations.last != nil else {
            print("No locations found")
            return [0, 0]
        }
        
        let totalDistance = measureTotalDistanceInKm(locations: locations)
        
        guard totalTime > 0 && totalDistance > 0 else {
            print("Error: Time or Distance is zero")
            return [0, 0]
        }
        
        let totalTimeInMins = totalTime / 60
        // Calculate pace: time per distance (minutes per kilometer)
        let paceInMins = totalTimeInMins / totalDistance

        // Convert pace to minutes and seconds
        let minutes = Int(paceInMins)
        let seconds = Int((paceInMins - Double(minutes)) * 60)
        
        return [minutes, seconds]
    }
}
