//
//  SaveRun.swift
//  MapRun
//
//  Created by Igor L on 15/09/2024.
//

import Foundation
import SwiftUI
import _MapKit_SwiftUI

struct SaveRun: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var context
    @Environment(LocationDataManager.self) var locationDataManager
    
    @State var isShowingPolyline = true
    @State var runTitle = ""
    
    @State var run: Run
    var locations: [CLLocation]
    
    var hours: Int
    var minutes: Int
    var seconds: Int
    
    init(run: Run, locations: [CLLocation]) {
        self.run = run
        self.hours = Int(run.time / 3600)
        self.minutes = Int((run.time / 3600) / 60)
        self.seconds = Int(run.time) % 60
        self.locations = locations
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                TextField("Title", text: $runTitle)
                Image(systemName: "pencil")
            }
            .font(.title)
            
            Text(String(format: "%02d:%02d:%02d", hours, minutes, seconds))
                .font(.title3)
            
            HStack {
                Text(String(format: "%.2f km", run.distance))
                Text(String(format: "%d:%02d /km", run.pace?[0] ?? 0, run.pace?[1] ?? 0))
                Text(String(format: "%.2f m/s", run.speed))
                Spacer()
                Button {
                    isShowingPolyline.toggle()
                    print("isShowingPolyline: \(isShowingPolyline)")
                } label: {
                    Image(systemName: isShowingPolyline ? "flag.fill" : "flag")
                }
            }
            .font(.title3)
            
            Map {
                if isShowingPolyline {
                    locationDataManager.drawRoute(locations: locationDataManager.locations)
                        .stroke(.red, lineWidth: 5)
                }
            }
            
            Button("Save") {
                saveRun(run: run, locations: locations)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .font(.title)
        }
        .padding()
    }
    
    func saveRun(run: Run, locations: [CLLocation]) {
        guard context.hasChanges else { return }
        
        // put Run in context
        run.title = self.runTitle
        
        // create LocationPoint for each CLLocation
        for location in locations {
            let locationPoint = LocationPoint(context: context)
            locationPoint.orderId = Int64(locations.firstIndex(of: location)!)
            locationPoint.latitude = location.coordinate.latitude
            locationPoint.longitude = location.coordinate.longitude
            // establish relationship
            run.addToLocations(locationPoint)
        }
        
        // save to context
        do {
            try context.save()
            print("Run saved to core data")
        } catch {
            print(error.localizedDescription)
        }
        
        dismiss()
    }
}

//#Preview {    
//    let now = Date()
//        
//    let locations = [
//        // New York
//        CLLocationCoordinate2D(latitude: 37.33172861, longitude: -122.03068446),
//        CLLocationCoordinate2D(latitude: 37.33158231, longitude: -122.03070604),
//        CLLocationCoordinate2D(latitude: 37.33131509, longitude: -122.03073779),
//        CLLocationCoordinate2D(latitude: 37.3311133, longitude: -122.03069859),
//        CLLocationCoordinate2D(latitude: 37.33080974, longitude: -122.03057107),
//        CLLocationCoordinate2D(latitude: 37.33070386, longitude: -122.03044428),
//        CLLocationCoordinate2D(latitude: 37.33069778, longitude: -122.03035543),
//        CLLocationCoordinate2D(latitude: 37.33068392, longitude: -122.03028038),
//        CLLocationCoordinate2D(latitude: 37.33067364, longitude: -122.03006986),
//        CLLocationCoordinate2D(latitude: 37.33068129, longitude: -122.02985192),
//        CLLocationCoordinate2D(latitude: 37.33069712, longitude: -122.02947821),
//        CLLocationCoordinate2D(latitude: 37.33062182, longitude: -122.02898027),
//        CLLocationCoordinate2D(latitude: 37.3304198, longitude: -122.02859976),
//        CLLocationCoordinate2D(latitude: 37.33029655, longitude: -122.02819114),
//        CLLocationCoordinate2D(latitude: 37.33026222, longitude: -122.02773507),
//        CLLocationCoordinate2D(latitude: 37.33023066, longitude: -122.02700675),
//        CLLocationCoordinate2D(latitude: 37.33019755, longitude: -122.02616308),
//        CLLocationCoordinate2D(latitude: 37.33019912, longitude: -122.02535325),
//        CLLocationCoordinate2D(latitude: 37.33019883, longitude: -122.02430601),
//        CLLocationCoordinate2D(latitude: 37.33019792, longitude: -122.02320222),
//        CLLocationCoordinate2D(latitude: 37.33019164, longitude: -122.02286302),
//        CLLocationCoordinate2D(latitude: 37.33011274, longitude: -122.02226048),
//        CLLocationCoordinate2D(latitude: 37.33008277, longitude: -122.02149879),
//        CLLocationCoordinate2D(latitude: 37.33000706, longitude: -122.02074717),
//        CLLocationCoordinate2D(latitude: 37.32961455, longitude: -122.01984354),
//        CLLocationCoordinate2D(latitude: 37.32870346, longitude: -122.01980704),
//        CLLocationCoordinate2D(latitude: 37.32684623, longitude: -122.01973256),
//        CLLocationCoordinate2D(latitude: 37.32472922, longitude: -122.02131077),
//        CLLocationCoordinate2D(latitude: 37.32473245, longitude: -122.02135132),
//        CLLocationCoordinate2D(latitude: 37.32474612, longitude: -122.021639),
//        CLLocationCoordinate2D(latitude: 37.32475255, longitude: -122.02191944),
//        CLLocationCoordinate2D(latitude: 37.32466, longitude: -122.02305644),
//        CLLocationCoordinate2D(latitude: 37.32462792, longitude: -122.02351949),
//        CLLocationCoordinate2D(latitude: 37.32461272, longitude: -122.02497776),
//        CLLocationCoordinate2D(latitude: 37.32527385, longitude: -122.02507318),
//        CLLocationCoordinate2D(latitude: 37.32610125, longitude: -122.02606968),
//        CLLocationCoordinate2D(latitude: 37.3262638, longitude: -122.0260956),
//        CLLocationCoordinate2D(latitude: 37.32727259, longitude: -122.0268528),
//        CLLocationCoordinate2D(latitude: 37.32820836, longitude: -122.02685578),
//        CLLocationCoordinate2D(latitude: 37.32878172, longitude: -122.02686242),
//        CLLocationCoordinate2D(latitude: 37.32931951, longitude: -122.02686047),
//        CLLocationCoordinate2D(latitude: 37.33022055, longitude: -122.02759074),
//        CLLocationCoordinate2D(latitude: 37.33053452, longitude: -122.02902979),
//        CLLocationCoordinate2D(latitude: 37.33065778, longitude: -122.02954165),
//        CLLocationCoordinate2D(latitude: 37.33154229, longitude: -122.03071488),
//    ]
//    
//    let mockLocations = [
//        CLLocation(coordinate: locations[0], altitude: 10, horizontalAccuracy: 5, verticalAccuracy: 5, timestamp: now),
//        CLLocation(coordinate: locations[1], altitude: 10, horizontalAccuracy: 5, verticalAccuracy: 5, timestamp: now.addingTimeInterval(10)), // After 10 seconds
//        CLLocation(coordinate: locations[2], altitude: 10, horizontalAccuracy: 5, verticalAccuracy: 5, timestamp: now.addingTimeInterval(20)), // After 20 seconds
//        CLLocation(coordinate: locations[3], altitude: 10, horizontalAccuracy: 5, verticalAccuracy: 5, timestamp: now.addingTimeInterval(30))  // After 30 seconds
//    ]
//    
//    let mockRun = Run(title: "First run",
//                  locations: mockLocations,
//                  time: 2000,
//                  distance: 2.01,
//                  pace: [5, 39],
//                  speed: 2.505,
//                  routeLine: MapPolyline(coordinates: locations, contourStyle: .straight))
//    
//    return SaveRun(run: mockRun)
//}
