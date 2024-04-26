//
//  NetworkExercise.swift
//  Gym Buddy
//
//  Created by Stefan Miloiu on 25.04.2024.
//

import Foundation

class NetworkExercise: Network {
    
    func fetchBodyParts() -> [String] {
        let data = decodeData()
        let bodyParts = Array(Set(data.map { $0.bodyPart }))
        return bodyParts
    }
    
    func fetchEquipment() -> [String] {
        let data = decodeData()
        let equipment = Array(Set(data.map { $0.equipment }))
        return equipment
    }
    
    func fetchExercises() -> [Exercise] {
        return decodeData()
    }
    
    func searchExercises(searchText: String) -> [Exercise] {
        let data = decodeData()
        return data.filter({ searchText.isEmpty ? true : $0.name.lowercased().contains(searchText.lowercased())
                            || $0.bodyPart.lowercased().contains(searchText.lowercased())
            || $0.target.lowercased().contains(searchText.lowercased())
        })
    }
    
    func searchAdvanced(bodyPart: String, target: String) -> [Exercise] {
        let data = decodeData()
        return data.filter({ bodyPart.isEmpty ? true : $0.bodyPart.lowercased().contains(bodyPart.lowercased())
            && target.isEmpty ? true : $0.target.lowercased().contains(target.lowercased())
        })
    }
    
}
