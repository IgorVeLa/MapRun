//
//  MapRunApp.swift
//  MapRun
//
//  Created by Igor L on 09/06/2024.
//

import SwiftUI

@main
struct MapRunApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, PersistenceManager.shared.container.viewContext)
                .environment(LocationDataManager.shared)
        }
    }
}
