//
//  RepsDB.swift
//  Gym Buddy
//
//  Created by Stefan Miloiu on 28.04.2024.
//

import Foundation
import CoreData

class RepsDB {
    
    func save(exerciseId: String, repetari: Int, weight: Double, exerciseDate: Date) {
        let reps = Reps(context: CoreDataProvider.shared.viewContext)
        reps.exerciseId = exerciseId
        reps.exerciseDate = exerciseDate
        reps.reps = NSDecimalNumber(value: repetari)
        reps.weight = weight
        do {
            try reps.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func fetchReps() -> [Reps] {
        let request: NSFetchRequest<Reps> = Reps.fetchRequest()
        do {
            return try CoreDataProvider.shared.viewContext.fetch(request)
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func deleteRepsById(id: String){
        let request: NSFetchRequest<Reps> = Reps.fetchRequest()
        request.predicate = NSPredicate(format: "exerciseId == %@", id)
        do {
            let reps = try CoreDataProvider.shared.viewContext.fetch(request).first
            if let reps {
                CoreDataProvider.shared.viewContext.delete(reps)
            }
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func deleteRepsByIdAndDate(id: String, date: Date) {
        let request: NSFetchRequest<NSFetchRequestResult> = Reps.fetchRequest()
        
        request.predicate = NSPredicate(format: "exerciseId == %@ AND exerciseDate == %@", id, date as NSDate)
        request.returnsObjectsAsFaults = false
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            let reps = try CoreDataProvider.shared.viewContext.fetch(request).first
            if reps != nil {
                try CoreDataProvider.shared.viewContext.execute(deleteRequest)
                try CoreDataProvider.shared.viewContext.save()
            }
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func findRepsById(id: String) -> Reps? {
        let request: NSFetchRequest<Reps> = Reps.fetchRequest()
        request.predicate = NSPredicate(format: "exerciseId == %@", id)
        do {
            return try CoreDataProvider.shared.viewContext.fetch(request).first
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func findRepsByIdAndDate(id: String, date: Date) -> [Reps] {
        let request: NSFetchRequest<Reps> = Reps.fetchRequest()
        print(id)
        print(date)
        request.predicate = NSPredicate(format: "exerciseId == %@ AND exerciseDate == %@", id, date as NSDate)
        do {
            print(try CoreDataProvider.shared.viewContext.fetch(request))
            return try CoreDataProvider.shared.viewContext.fetch(request).sorted(by: { $0.exerciseDate! < $1.exerciseDate! })
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
}
