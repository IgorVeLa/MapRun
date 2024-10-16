//
//  MockData.swift
//  MapRun
//
//  Created by Igor L on 02/10/2024.
//

import CoreData
import CoreLocation
import Foundation

extension PersistenceManager {
    static let mockcoords = [
        CLLocationCoordinate2D(latitude: 37.33172861, longitude: -122.03068446),
        CLLocationCoordinate2D(latitude: 37.33158231, longitude: -122.03070604),
        CLLocationCoordinate2D(latitude: 37.33131509, longitude: -122.03073779),
        CLLocationCoordinate2D(latitude: 37.3311133, longitude: -122.03069859),
        CLLocationCoordinate2D(latitude: 37.33080974, longitude: -122.03057107),
        CLLocationCoordinate2D(latitude: 37.33070386, longitude: -122.03044428),
        CLLocationCoordinate2D(latitude: 37.33069778, longitude: -122.03035543),
        CLLocationCoordinate2D(latitude: 37.33068392, longitude: -122.03028038),
        CLLocationCoordinate2D(latitude: 37.33067364, longitude: -122.03006986),
        CLLocationCoordinate2D(latitude: 37.33068129, longitude: -122.02985192),
        CLLocationCoordinate2D(latitude: 37.33069712, longitude: -122.02947821),
        CLLocationCoordinate2D(latitude: 37.33062182, longitude: -122.02898027),
        CLLocationCoordinate2D(latitude: 37.3304198, longitude: -122.02859976),
        CLLocationCoordinate2D(latitude: 37.33029655, longitude: -122.02819114),
        CLLocationCoordinate2D(latitude: 37.33026222, longitude: -122.02773507),
        CLLocationCoordinate2D(latitude: 37.33023066, longitude: -122.02700675),
        CLLocationCoordinate2D(latitude: 37.33019755, longitude: -122.02616308),
        CLLocationCoordinate2D(latitude: 37.33019912, longitude: -122.02535325),
        CLLocationCoordinate2D(latitude: 37.33019883, longitude: -122.02430601),
        CLLocationCoordinate2D(latitude: 37.33019792, longitude: -122.02320222),
        CLLocationCoordinate2D(latitude: 37.33019164, longitude: -122.02286302),
        CLLocationCoordinate2D(latitude: 37.33011274, longitude: -122.02226048),
        CLLocationCoordinate2D(latitude: 37.33008277, longitude: -122.02149879),
        CLLocationCoordinate2D(latitude: 37.33000706, longitude: -122.02074717),
        CLLocationCoordinate2D(latitude: 37.32961455, longitude: -122.01984354),
        CLLocationCoordinate2D(latitude: 37.32870346, longitude: -122.01980704),
        CLLocationCoordinate2D(latitude: 37.32684623, longitude: -122.01973256),
        CLLocationCoordinate2D(latitude: 37.32472922, longitude: -122.02131077),
        CLLocationCoordinate2D(latitude: 37.32473245, longitude: -122.02135132),
        CLLocationCoordinate2D(latitude: 37.32474612, longitude: -122.021639),
        CLLocationCoordinate2D(latitude: 37.32475255, longitude: -122.02191944),
        CLLocationCoordinate2D(latitude: 37.32466, longitude: -122.02305644),
        CLLocationCoordinate2D(latitude: 37.32462792, longitude: -122.02351949),
        CLLocationCoordinate2D(latitude: 37.32461272, longitude: -122.02497776),
        CLLocationCoordinate2D(latitude: 37.32527385, longitude: -122.02507318),
        CLLocationCoordinate2D(latitude: 37.32610125, longitude: -122.02606968),
        CLLocationCoordinate2D(latitude: 37.3262638, longitude: -122.0260956),
        CLLocationCoordinate2D(latitude: 37.32727259, longitude: -122.0268528),
        CLLocationCoordinate2D(latitude: 37.32820836, longitude: -122.02685578),
        CLLocationCoordinate2D(latitude: 37.32878172, longitude: -122.02686242),
        CLLocationCoordinate2D(latitude: 37.32931951, longitude: -122.02686047),
        CLLocationCoordinate2D(latitude: 37.33022055, longitude: -122.02759074),
        CLLocationCoordinate2D(latitude: 37.33053452, longitude: -122.02902979),
        CLLocationCoordinate2D(latitude: 37.33065778, longitude: -122.02954165),
        CLLocationCoordinate2D(latitude: 37.33154229, longitude: -122.03071488),
    ]
    
    static func save(context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    static func getMockRun(context: NSManagedObjectContext) -> Run {
        let mockRun = Run(context: context)
        let locations = toCLLocations(coords: mockcoords)
        let totalTimeInS = 780

        mockRun.distance = measureTotalDistanceInKm(locations: locations)
        mockRun.pace = measurePace(locations: locations,
                                       totalTime: 780)
        mockRun.speed = measureSpeed(locations: locations)
        mockRun.time = Double(totalTimeInS)
        mockRun.title = "Mock Run Title"
        mockRun.dateAdded = Date.now
        createLocationPoints(run: mockRun, context: context)
        
        save(context: context)
        
        return mockRun
    }
    
    static func createMockLocations() -> [CLLocation] {
        return toCLLocations(coords: mockcoords)
    }
    
    static func createLocationPoints(run: Run, context: NSManagedObjectContext) {
        for (index, mockcoord) in mockcoords.enumerated() {
            // create LocationPoint for each CLLocation
            let locationPoint = LocationPoint(context: context)
            locationPoint.orderId = Int64(index)
            locationPoint.latitude = mockcoord.latitude
            locationPoint.longitude = mockcoord.longitude
            // establish relationship
            run.addToLocations(locationPoint)
        }
        
        save(context: context)
    }
}
