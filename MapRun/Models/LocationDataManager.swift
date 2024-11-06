//
//  LocationManager.swift
//  MapRun
//
//  Created by Igor L on 12/06/2024.
//

import CoreLocation
import Foundation
import _MapKit_SwiftUI
import SwiftUI

@Observable
class LocationDataManager: NSObject, CLLocationManagerDelegate {
    // singleton
    static let shared = LocationDataManager()
    
    var locationManager = CLLocationManager()
    var authorisationStatus: CLAuthorizationStatus?
    
    // add binding to isShowingLocationAlert for alert modifier
    var isShowingLocationDeniedAlert = false
    var isShowingLocationInUseAlert = false
    var locationDeniedAlertBinding: Binding<Bool> {
        Binding(
            get: { self.isShowingLocationDeniedAlert },
            set: { self.isShowingLocationDeniedAlert = $0 }
        )
    }
    var locationInUseAlertBinding: Binding<Bool> {
        Binding(
            get: { self.isShowingLocationInUseAlert },
            set: { self.isShowingLocationInUseAlert = $0 }
        )
    }

    var locationServicesAvailability = false
    
    var locations: [CLLocation] = []
    var currentDist = 0.0
    var currentSpeed = 0.0
    var currentPace = [0, 0]
    
    override init() {
        super.init()
        // object that receives updates relating to location data
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        // reduce load on main thread to keep stopwatch UI updated accurately
        locationManager.distanceFilter = 3
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }
    
    func requestPermission() {
        locationManager.requestAlwaysAuthorization()
    }
    
    // handler for user authorisation for access to location data
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            // location services are available
            case .authorizedAlways:
                authorisationStatus = .authorizedAlways
                print("location services authorised always")
                locationServicesAvailability = true
                //locationManager.requestLocation()
                break
            // location services when in use
            case .authorizedWhenInUse:
                authorisationStatus = .authorizedWhenInUse
                print("location services authorised when in use")
                locationServicesAvailability = true
                // inform user
                isShowingLocationInUseAlert.toggle()
            // location services are unavailable
            case .restricted:
                authorisationStatus = .restricted
                print("location services restricted")
                locationServicesAvailability = false
                locationManager.requestLocation()
                break
            case .denied:
                authorisationStatus = .denied
                print("location services denied")
                locationServicesAvailability = false
                // inform user
                isShowingLocationDeniedAlert.toggle()
                break
            // location services are unknown
            case .notDetermined:
                authorisationStatus = .notDetermined
                locationServicesAvailability = false
            print("location services not determined")
                locationManager.requestLocation()
                locationServicesAvailability = false
                break
            default:
                break
        }
    }

    
    func startTrack() {
        // clear locations
        locations = []
        // start tracking user locations
        locationManager.startUpdatingLocation()
        print("Tracking user locations")
    }
        
    func stopTrack() {
        // stop tracking user locations
        locationManager.stopUpdatingLocation()
        print("Stopped tracking user locations")
    }

    // handler for location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard locations.last != nil else {
            print("No locations found")
            return
        }
        currentDist = measureTotalDistanceInKm(locations: self.locations)
        currentSpeed = measureSpeed(locations: self.locations)
        currentPace = measurePace(locations: self.locations, totalTime: TimeManager.shared.totalTimeInS)
        
        // add locations from delegate to class
        self.locations.append(contentsOf: locations)
    }
    
    // handler for failures to retrieve location data
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
}

// methods for calculating statistics
extension LocationDataManager {
    // draw route
    func drawRoute(locations: [CLLocation]) -> MapPolyline {
        guard locations.last != nil else {
            print("No locations found")
            return MapPolyline(coordinates: [])
        }
        // convert to CLLocationCoordinate2D
        let coordinates = toCLLCoordinates(locations: locations)
        
        // create MapPolyLine
        let routeLine = MapPolyline(coordinates: coordinates, contourStyle: .straight)
        return routeLine
    }
    
    func measureTotalDistanceInKm(locations: [CLLocation]) -> Double {
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
    
    func measureSpeed(locations: [CLLocation]) -> Double {
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
    
    func measurePace(locations: [CLLocation], totalTime: Double) -> [Int] {
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
    
    func toCLLCoordinates(locations: [CLLocation]) -> [CLLocationCoordinate2D] {
        var coordinates = [CLLocationCoordinate2D]()
        
        for location in locations {
            //print(location)
            coordinates.append(location.coordinate)
        }
        
        return coordinates
    }
    
    func toCLLocations(coords: [CLLocationCoordinate2D]) -> [CLLocation] {
        var locations = [CLLocation]()
        
        for coord in coords {
            //print(location)
            locations.append(CLLocation(latitude: coord.latitude, longitude: coord.longitude))
        }
        
        return locations
    }
}
