//
//  HistoryView.swift
//  MapRun
//
//  Created by Igor L on 27/09/2024.
//

import Foundation
import _MapKit_SwiftUI
import SwiftUI

struct HistoryView: View {
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(
            entity: Run.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Run.title, ascending: false)]
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
                    Text(String(format: "%02d:%02d:%02d", Int(run.time / 3600), Int((run.time / 3600) / 60), Int(run.time) % 60))
                    Text(String(format: "%d:%02d /km", run.pace?[0] ?? "err", run.pace?[1] ?? "err"))
                }
                .padding(.horizontal)
                
            }
        }
        .onAppear {
            print(runs)
        }
    }
    
    func createRoute(run: Run) -> MapPolyline {
        var coords = [CLLocationCoordinate2D]()
        for location in run.locations! as! Set<LocationPoint> {
            coords.append(location.cllocationcoord())
        }
        
        return MapPolyline(coordinates: coords)
    }
}

//#Preview {
//    HistoryView()
//}
