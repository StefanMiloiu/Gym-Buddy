//
//  LocalFetch.swift
//  Gym Buddy
//
//  Created by Stefan Miloiu on 27.04.2024.
//

import Foundation
import SwiftUI

class LocalFetch {
    
    static let shared = LocalFetch()
    private var exercises: [ExerciseApi] = []
    
    init() {
        self.exercises = fetchExercises()
    }
    
    func fetchExercises() -> [ExerciseApi] {
        let url = Bundle.main.url(forResource: "Data", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let exercises = try! JSONDecoder().decode([ExerciseApi].self, from: data)
        return exercises
    }
    
    func fetchBodyParts() -> [String] {
        let data = self.exercises
        let bodyParts = Array(Set(data.map { $0.bodyPart }))
        return bodyParts
    }
    
    func fetchEquipment() -> [String] {
        let data = self.exercises
        let equipment = Array(Set(data.map { $0.equipment }))
        return equipment
    }
    
    func searchExercises(searchText: String) -> [ExerciseApi] {
        let data = self.exercises
        return data.filter({ searchText.isEmpty ? true : $0.name.lowercased().contains(searchText.lowercased())
                            || $0.bodyPart.lowercased().contains(searchText.lowercased())
            || $0.target.lowercased().contains(searchText.lowercased())
        })
    }
    
    func searchAdvanced(bodyPart: String, target: String, equipmenet: String) -> [ExerciseApi] {
        let data = self.exercises
        print(equipmenet)
        return data.filter({ bodyPart.isEmpty ? true : $0.bodyPart.lowercased().contains(bodyPart.lowercased())
            && target.isEmpty ? true : $0.target.lowercased().contains(target.lowercased())
            && equipmenet.isEmpty ? true : $0.equipment.lowercased().contains(equipmenet.lowercased())
        })
    }
}
