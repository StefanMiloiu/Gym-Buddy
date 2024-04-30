//
//  CoreDataProvider.swift
//  Gym Buddy
//
//  Created by Stefan Miloiu on 26.04.2024.
import Foundation
import CoreData

//MARK: - CoreDataProvider
class CoreDataProvider {
    
    //MARK: - Properties
    // Singleton instance of the CoreDataProvider.
    static let shared = CoreDataProvider()
    let persistenceContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        persistenceContainer.viewContext
    }
    
    //MARK: - Initializer
    // Private initializer to prevent multiple instances of CoreDataProvider.
    private init() {
        persistenceContainer = NSPersistentContainer(name: "Gym_Buddy")
        let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Gym_Buddy.sqlite") ?? URL(fileURLWithPath: "")
        let storeDescriptor = NSPersistentStoreDescription(url: storeURL)
        storeDescriptor.type = NSSQLiteStoreType
        persistenceContainer.persistentStoreDescriptions = [storeDescriptor]
        
        persistenceContainer.loadPersistentStores { storeDescription, error in
            if let error = error {
                print("Fatal error loading store: \(error.localizedDescription)")
            }
        }
        persistenceContainer.viewContext.automaticallyMergesChangesFromParent = true
    }

    //MARK: - Methods
    // Delete then save the context.
    static func deleteAllReps() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Reps")
        fetchRequest.returnsObjectsAsFaults = false
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try CoreDataProvider.shared.viewContext.execute(deleteRequest)
            try CoreDataProvider.shared.viewContext.save()
        } catch let error {
            print("Detele all data in Exercise error :", error)
        }
    }
    
    static func deleteAll() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercise")
        fetchRequest.returnsObjectsAsFaults = false
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try CoreDataProvider.shared.viewContext.execute(deleteRequest)
            try CoreDataProvider.shared.viewContext.save()
        } catch let error {
            print("Detele all data in Exercise error :", error)
        }
    }
    
}

//MARK: - URL Extension
// Extension to create a URL for the shared file container. (Capabilities -> App Groups (used for widgets))
public extension URL {
    static func storeURl(for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Shared file container could not be created.")
        }
        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}
