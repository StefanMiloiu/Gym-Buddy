//
//  RepsViewModel.swift
//  Gym Buddy
//
//  Created by Stefan Miloiu on 29.04.2024.
//

import Foundation
import CoreData

class RepsViewModel: ObservableObject {
    
    private let repsRepository = RepsDB()
    @Published var reps = [Reps]()
    init() {
        fetchReps()
    }
    
    private func fetchReps() {
        reps = repsRepository.fetchReps()
    }
    
    func fetchSortedReps() {
        fetchReps()
        reps = reps.sorted(by: { $0.exerciseDate! < $1.exerciseDate! })
    }
    
    func fetchRepsByDate(for date: Date) {
        fetchSortedReps()
        reps = reps.filter({ $0.exerciseDate!.stripTime() == date.stripTime() })
    }
    
    func fetchRepsById(where id: String) {
        fetchSortedReps()
        reps = reps.filter({ $0.exerciseId == id })
    }
    
    func fetchRepsByExercise(for exercise: Exercise) {
        fetchSortedReps()
        reps = reps.filter({ $0.exerciseId == exercise.id && $0.exerciseDate!.stripTime() == exercise.date!.stripTime() })
    }
    
    func deleteRepsByIdAndDate(id: String, date: Date) {
        repsRepository.deleteRepsByIdAndDate(id: id, date: date)
        fetchSortedReps()
    }
}
