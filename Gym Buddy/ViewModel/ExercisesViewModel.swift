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
    
    func fetchSortedExercises() {
        self.fetchExercises()
        exercises = exercises.sorted(by: { $0.date! < $1.date! })
    }
    
    func fetchExercisesByDate(for date: Date) {
        self.fetchSortedExercises()
        exercises = exercises.filter({ $0.date!.stripTime() == date.stripTime() })
    }
    
    func deleteExerciseById(id: String, date: Date) {
        exerciseRepository.deleteExerciseByIdAndDate(id: id, date: date)
        fetchExercises()
    }
    
}
