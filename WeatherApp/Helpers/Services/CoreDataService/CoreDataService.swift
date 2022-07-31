//
//  CoreDataService.swift
//  WeatherApp
//
//  Created by Nishant Taneja on 31/07/22.
//

import CoreData

struct CoreDataService {
    static let shared = CoreDataService()
    private init() {}
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WeatherApp")
        container.loadPersistentStores { description, error in
            guard let error = error else { return }
            fatalError("Failed to load the persistent stores from model \"AuditFlo\"")
        }
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
}
