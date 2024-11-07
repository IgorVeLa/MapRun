//
//  ContentView.swift
//  MapRun
//
//  Created by Igor L on 09/06/2024.
//

import SwiftUI
import MapKit
import CoreLocation

struct ContentView: View {
    @Environment(LocationDataManager.self) var locationDataManager
    
    var body: some View {
        TabView {
            RunningView()
                .tabItem {
                    Image(systemName: "figure.run.circle.fill")
                    Text("Run")
                }
            
            HistoryView()
                .tabItem {
                    Image(systemName: "list.bullet.clipboard.fill")
                    Text("Stats")
                }
        }
        .onAppear {
            locationDataManager.requestPermission()
        }
        .alert("Location services are turned off", isPresented: locationDataManager.locationDeniedAlertBinding) {
            Button("OK") {}
        } message: {
            Text("Please manually turn them on by going to Settings > Privacy > Location Services > MapRun > Always")
        }
        .alert("WARNING", isPresented: locationDataManager.locationInUseAlertBinding) {
            Button("OK") {}
        } message: {
            Text("Not allowing location services to be on always may lead to inaccurate tracking. \n\n Please manually turn them on by going to Settings > Privacy > Location Services > MapRun > Always")
        }
    }
}

#Preview {
    let context = PersistenceManager.preview.container.viewContext
    
    return ContentView()
        .environment(\.managedObjectContext, context)
        .environment(LocationDataManager())
        .environment(TimeManager())
}
