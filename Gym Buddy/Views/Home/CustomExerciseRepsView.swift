//
//  File.swift
//  Gym Buddy
//
//  Created by Stefan Miloiu on 01.05.2024.
//

import Foundation
import SwiftUI

struct CustomExerciseRepsView: View {
    @State var reps: String = ""
    @State var weight: String = ""
    let exercise: Exercise
    
    @Binding var selectedAlert: Alerts?
    @Binding var alert: Bool
    
    var date: Date
    
    private var isToday: Bool {
        return date.stripTime() == Date.now.stripTime()
    }
    var body: some View {
        if isToday {
            HStack {
                TextField("Reps", text: $reps)
                    .keyboardType(.numberPad)
                    .padding(15)
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
                    .padding(.vertical, 10)
                
                TextField("Weight (Kg)", text: $weight)
                    .keyboardType(.decimalPad)
                    .padding(15)
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
                AddRepsButton(exercise: exercise, reps: $reps, weight: $weight, alert: $alert, selectedAlert: $selectedAlert, date: date)
            }
        }
    }
}
