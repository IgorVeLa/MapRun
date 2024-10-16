//
//  SaveRun.swift
//  MapRun
//
//  Created by Igor L on 15/09/2024.
//

import Foundation
import SwiftUI
import _MapKit_SwiftUI

struct SaveRunView: View {
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
        self.minutes = Int(run.time / 60) % 60
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
                    locationDataManager.drawRoute(locations: locations)
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

#Preview {
    let context = PersistenceManager.preview.container.viewContext
    let run = PersistenceManager.getMockRun(context: context)
    PersistenceManager.createLocationPoints(run: run, context: context)
    let locations = PersistenceManager.createMockLocations()

    return SaveRunView(run: run, locations: locations)
        .environment(LocationDataManager.shared)
        .environment(\.managedObjectContext, context)
}
