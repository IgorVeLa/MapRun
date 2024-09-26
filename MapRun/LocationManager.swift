//
//  LocationManager.swift
//  MapRun
//
//  Created by Igor L on 12/06/2024.
//

import Foundation
import CoreLocation

@Observable
class LocationDataManager: NSObject, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var authorisationStatus: CLAuthorizationStatus?
    
    override init() {
        super.init()
        // object that receives updates relating to location data
        locationManager.delegate = self
    }
    
    // handler for user authorisation for access to location data
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        // location services are available
        case .authorizedWhenInUse:
            authorisationStatus = .authorizedWhenInUse
            manager.requestLocation()
            break
        // location services are unavailable
        case .restricted:
            authorisationStatus = .restricted
            break
        case .denied:
            authorisationStatus = .denied
            break
        // location services are unknown
        case .notDetermined:
            break
        
        default:
            break
        }
    }
    
    // handler to inform delegate new location data is available
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Insert code to handle location updates
    }
    
    // handler for failures to retrieve location data
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
}
