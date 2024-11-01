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
            VStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text((run.dateAdded?.formatted(date: .abbreviated, time: .omitted) ?? ""))
                        
                        Spacer()
                        
                        Text((run.dateAdded?.formatted(date: .omitted, time: .shortened)) ?? "")
                    }
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.top)
                    
                    Text(run.title ?? "err")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                
                Map {
                    createRoute(run: run)
                        .stroke(.red, lineWidth: 5)
                }
                .frame(maxWidth: .infinity, minHeight: 300)
                
                VStack {
                    // frames are to ensure the symbols are aligned by taking equal space of the parent HStack container
                    HStack {
                        Image(systemName: "point.bottomleft.filled.forward.to.point.topright.scurvepath")
                            .frame(maxWidth: .infinity)
                        Image(systemName: "clock.fill")
                            .frame(maxWidth: .infinity)
                        Image(systemName: "figure.run")
                            .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity)
                    .font(.headline)
                    .padding(.top, 2)
                    
                    HStack {
                        Text(String(format: "%.2f km", run.distance))
                            .frame(maxWidth: .infinity)
                        Text(String(format: "%02d:%02d:%02d", Int(run.time / 3600), Int(run.time / 60) % 60, Int(run.time) % 60))
                            .frame(maxWidth: .infinity)
                        Text(String(format: "%d:%02d /km", run.pace?[0] ?? "err", run.pace?[1] ?? "err"))
                            .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.bottom)
            }
        }
        .overlay {
            if runs.isEmpty {
                ContentUnavailableView("No runs completed", systemImage: "text.page.slash.fill", description: Text("Tap the run icon and begin!"))
                    .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.7))
                        )
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
    _ = PersistenceManager.getMockRun(context: context)
    _ = PersistenceManager.getMockRun(context: context)
    
    return HistoryView()
        .environment(\.managedObjectContext, context)
}
