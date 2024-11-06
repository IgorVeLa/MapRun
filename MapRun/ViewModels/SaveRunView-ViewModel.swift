//
//  SaveRunView-ViewModel.swift
//  MapRun
//
//  Created by Igor L on 06/11/2024.
//

import CoreLocation


extension SaveRunView {
    class ViewModel {
        var isShowingPolyline = true
        var runTitle = ""
        
        var run: Run
        var locations: [CLLocation]
        
        init(run: Run, locations: [CLLocation]) {
            self.run = run
            self.locations = locations
        }

        func saveRun(run: Run, locations: [CLLocation]) {
            let context = PersistenceManager.shared.container.viewContext
            
            guard context.hasChanges else { return }
            
            // put Run in context
            run.title = runTitle
            
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
        }
    }
}
