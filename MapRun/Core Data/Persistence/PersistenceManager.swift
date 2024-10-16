//
//  PersistenceManager.swift
//  MapRun
//
//  Created by Igor L on 02/10/2024.
//

import CoreData
import Foundation

struct PersistenceManager {
    // singleton
    static let shared = PersistenceManager()
    // preview singleton
    static let preview = PersistenceManager(inMemory: true)
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Run")
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
