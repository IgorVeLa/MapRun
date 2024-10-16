//
//  HistoryView.swift
//  MapRun
//
//  Created by Igor L on 27/09/2024.
//

import CoreData
import Foundation
import _MapKit_SwiftUI
import SwiftUI

struct HistoryView: View {
    @Environment(\.managedObjectContext) var context

    @FetchRequest(
            fetchRequest: Run.noPendingChangesRequest()
        ) var runs: FetchedResults<Run>
    
    var body: some View {
        List(runs, id: \.self) { run in
            HStack {
                Text(run.title ?? "err")
                
                Spacer()
                
                Map {
                    createRoute(run: run)
                        .stroke(.red, lineWidth: 5)
                }
                    .padding(.horizontal)
                
                Spacer()
                
                VStack {
                    Text(String(format: "%.2f km", run.distance))
                    Text(String(format: "%02d:%02d:%02d", Int(run.time / 3600), Int(run.time / 60) % 60, Int(run.time) % 60))
                    Text(String(format: "%d:%02d /km", run.pace?[0] ?? "err", run.pace?[1] ?? "err"))
                }
                .padding(.horizontal)
            }
        }
    }
    
    func createRoute(run: Run) -> MapPolyline {
        var coords = [CLLocationCoordinate2D]()
        
        let locationsArr = run.locations!.allObjects as! [LocationPoint]
        
        for location in locationsArr.sorted() {
            coords.append(location.cllocationcoord())
        }
        
        return MapPolyline(coordinates: coords)
    }
}

#Preview {
    let context = PersistenceManager.preview.container.viewContext
    let run = PersistenceManager.getMockRun(context: context)
    
    return HistoryView()
        .environment(\.managedObjectContext, context)
}
