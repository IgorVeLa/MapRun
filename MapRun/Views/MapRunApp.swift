//
//  MapRunApp.swift
//  MapRun
//
//  Created by Igor L on 09/06/2024.
//

import SwiftUI

@main
struct MapRunApp: App {
    @State var locationDataManager = LocationDataManager()
    @State var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environment(locationDataManager)
        }
    }
}
