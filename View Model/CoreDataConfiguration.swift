//
//  CoreDataConfiguration.swift
//  NewsCart
//
//  Created by UdayKiran Naik on 16/08/23.
//

import Foundation
import CoreData
class CoreDataConfiguration{
    static let shared = CoreDataConfiguration()
    // MARK: - Core Data stack
        lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NewsCart")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
