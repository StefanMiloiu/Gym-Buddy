//
//  ExercisesDB.swift
//  Gym Buddy
//
//  Created by Stefan Miloiu on 28.04.2024.
//

import Foundation
import CoreData

class ExercisesDB {
    
    private let repsDB = RepsDB()
    
    func save(id: String, name: String, bodyPart: String, equipment: String, target: String, gifUrl: String) throws {
        let date = Date.now
        let ex = self.findExercisesById(id: id)
        if !ex.isEmpty {
            if ex.filter({$0.date?.stripTime() == date.stripTime()}).count > 0 {
                throw NSError(domain: "Exercise already exists", code: 1, userInfo: nil)
            }
        }
        let exercise = Exercise(context: CoreDataProvider.shared.viewContext)
        exercise.id = id
        exercise.name = name
        exercise.bodyPart = bodyPart
        exercise.equipment = equipment
        exercise.target = target
        exercise.gifUrl = gifUrl
        exercise.date = date
        do {
            try exercise.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    func fetchExercises() -> [Exercise] {
        let request: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        do {
            return try CoreDataProvider.shared.viewContext.fetch(request)
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    func deleteExerciseById(id: String) {
        let request: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        do {
            let exercise = try CoreDataProvider.shared.viewContext.fetch(request).first
            if let exercise = exercise {
                CoreDataProvider.shared.viewContext.delete(exercise)
            }
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func deleteExerciseByIdAndDate(id: String, date: Date) {
        let request: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@ AND date == %@", id, date as NSDate)
        do {
            let exercise = try CoreDataProvider.shared.viewContext.fetch(request).first
            if let exercise = exercise {
                CoreDataProvider.shared.viewContext.delete(exercise)
                repsDB.deleteRepsByIdAndDate(id: id, date: date)
                try CoreDataProvider.shared.viewContext.save()
            }
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func deleteHistoryExercises(exercises: [Exercise]) {
        for exercise in exercises {
            CoreDataProvider.shared.viewContext.delete(exercise)
            repsDB.deleteRepsByIdAndDate(id: exercise.id!, date: exercise.date!)
        }
        do {
            try CoreDataProvider.shared.viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func findExerciseById(id: String) -> Exercise? {
        let request: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        do {
            return try CoreDataProvider.shared.viewContext.fetch(request).first
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func findExercisesById(id: String) -> [Exercise] {
        let request: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        do {
            return try CoreDataProvider.shared.viewContext.fetch(request)
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func findExerciseByIdAndDate(id: String, date: Date) -> Exercise? {
        let request: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@ AND date == %@", id, date as NSDate)
        do {
            return try CoreDataProvider.shared.viewContext.fetch(request).first
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func deleteExercise(exercise: Exercise) {
        CoreDataProvider.shared.viewContext.delete(exercise)
        do {
            repsDB.deleteRepsByIdAndDate(id: exercise.id!, date: exercise.date!)
            try CoreDataProvider.shared.viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
