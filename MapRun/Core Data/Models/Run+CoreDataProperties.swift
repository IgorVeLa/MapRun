//
//  Run+CoreDataProperties.swift
//  MapRun
//
//  Created by Igor L on 28/09/2024.
//
//

import Foundation
import CoreData


extension Run {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Run> {
        return NSFetchRequest<Run>(entityName: "Run")
    }

    @NSManaged public var distance: Double
    @NSManaged public var pace: [Int]?
    @NSManaged public var speed: Double
    @NSManaged public var time: Double
    @NSManaged public var title: String?
    @NSManaged public var dateAdded: Date?
    @NSManaged public var locations: NSSet?

}

// MARK: Generated accessors for locations
extension Run {

    @objc(addLocationsObject:)
    @NSManaged public func addToLocations(_ value: LocationPoint)

    @objc(removeLocationsObject:)
    @NSManaged public func removeFromLocations(_ value: LocationPoint)

    @objc(addLocations:)
    @NSManaged public func addToLocations(_ values: NSSet)

    @objc(removeLocations:)
    @NSManaged public func removeFromLocations(_ values: NSSet)

}

extension Run : Identifiable {
    static func noPendingChangesRequest() -> NSFetchRequest<Run> {
            let request = Run.fetchRequest()
            request.includesPendingChanges = false
            request.sortDescriptors = [NSSortDescriptor(keyPath: \Run.dateAdded, ascending: false)]
        
            return request
        }
}
