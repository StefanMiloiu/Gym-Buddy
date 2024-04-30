//
//  CoreDataModel.swift
//  Gym Buddy
//
//  Created by Stefan Miloiu on 28.04.2024.
//

import Foundation
import CoreData

//MARK: - Model protocol
protocol Model {
    
}

//MARK: - Model extension
extension Model where Self: NSManagedObject {
    
    //Save
    func save() throws{
        try CoreDataProvider.shared.viewContext.save()
    }
    
    //Delete
    func delete() throws {
        CoreDataProvider.shared.viewContext.delete(self)
        try CoreDataProvider.shared.viewContext.save()
    }
    
    //All
    static func all() -> NSFetchRequest<Self> {
        let request = NSFetchRequest<Self>(entityName: String(describing: self))
        request.sortDescriptors = []
        return request
    }
}

extension Exercise: Model{ }
extension Reps: Model{ }
