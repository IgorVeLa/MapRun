//
//  LocationPoint+CoreDataProperties.swift
//  MapRun
//
//  Created by Igor L on 28/09/2024.
//
//

import Foundation
import CoreData
import CoreLocation

extension LocationPoint {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationPoint> {
        return NSFetchRequest<LocationPoint>(entityName: "LocationPoint")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var orderId: Int64
    @NSManaged public var run: Run?

    func initFromLocation(location: CLLocation) {
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
    }
}

extension LocationPoint : Identifiable, Comparable {
    func cllocation() -> CLLocation {
        return CLLocation(
            latitude: self.latitude,
            longitude: self.longitude)
    }
    
    func cllocationcoord() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: self.latitude,
            longitude: self.longitude)
    }
    
    public static func <(lhs: LocationPoint, rhs: LocationPoint) -> Bool {
        return lhs.orderId < rhs.orderId
    }
}
