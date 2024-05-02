//
//  ExercisesViewModel.swift
//  Gym Buddy
//
//  Created by Stefan Miloiu on 29.04.2024.
//

import Foundation
import CoreData

class ExercisesViewModel: ObservableObject {
    
    private let exerciseRepository = ExercisesDB()
    @Published var exercises = [Exercise]()
    
    init() {
        fetchExercises()
    }
    
    private func fetchExercises() {
        exercises = exerciseRepository.fetchExercises()
    }
    
    private func fetchTodaysSortedExercises() {
        fetchSortedExercises()
        exercises = exercises.filter({ $0.date!.stripTime() == Date().stripTime() })
    }
    
    func fetchSortedExercises() {
        self.fetchExercises()
        exercises = exercises.sorted(by: { $0.date! < $1.date! })
    }
    
    func fetchExercisesByDate(for date: Date) {
        self.fetchSortedExercises()
        exercises = exercises.filter({ $0.date!.stripTime() == date.stripTime() })
    }
    
    func deleteExerciseById(exercise: Exercise) {
        let date = exercise.date!
        exerciseRepository.deleteExercise(exercise: exercise)
        fetchExercisesByDate(for: date)
    }
    
    func deleteExercisesFromHistory(exercises: [Exercise]) {
        exerciseRepository.deleteHistoryExercises(exercises: exercises)
        fetchReversSortedExercises()
    }
    
    func getAllBodyParts(exercises: [Exercise]) -> [String] {
        return Array(Set(exercises.map({ $0.bodyPart! })))
    }
    
    func getAllBodyPartsString(exercises: [Exercise]) -> String {
        let bodyParts = getAllBodyParts(exercises: exercises)
        let distinctBodyParts = Set(bodyParts)
        return distinctBodyParts.joined(separator: ", ").capitalized
    }
    
    func fetchReversSortedExercises() {
        self.fetchExercises()
        exercises = exercises.sorted(by: { $0.date! > $1.date! })
    }
    
    func importFromHistory(exercises: [Exercise]) {
        do {
            for ex in exercises {
                try exerciseRepository.save(id: ex.id!, name: ex.name!, bodyPart: ex.bodyPart!, equipment: ex.equipment!, target: ex.target!, gifUrl: ex.gifUrl!)
            }
        } catch let err {
            print(err.localizedDescription)
        }
        fetchSortedExercises()
    }

}
