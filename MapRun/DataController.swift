//
//  DataController.swift
//  MapRun
//
//  Created by Igor L on 24/09/2024.
//

import CoreData
import Foundation

@Observable
class DataController {
    let container = NSPersistentContainer(name: "Run")
    
    init() {
        // load actual data from store
        container.loadPersistentStores { description, error in
            // error handling e.g corrupted data
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
