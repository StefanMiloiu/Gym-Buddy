//
//  Utils.swift
//  Gym Buddy
//
//  Created by Stefan Miloiu on 27.04.2024.
//

import Foundation

class Utils{
    
    static func encodeExercises(from exercises: [ExerciseApi]) {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(exercises)
            // Convert JSON data to string
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
            } else {
                print("Failed to convert JSON data to string.")
            }
        } catch {
            print("Error encoding JSON: \(error)")
        }
    }
}
