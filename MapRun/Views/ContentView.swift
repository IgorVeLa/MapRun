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
    }
}

#Preview {
    ContentView()
        .environment(LocationDataManager())
}
