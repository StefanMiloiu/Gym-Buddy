//
//  AddRepsButton.swift
//  Gym Buddy
//
//  Created by Stefan Miloiu on 01.05.2024.
//

import Foundation
import SwiftUI

struct AddRepsButton: View {
    
    @EnvironmentObject var repsViewModel: RepsViewModel
    
    @State private var repsDB = RepsDB()
    let exercise: Exercise
    @Binding var reps: String
    @Binding var weight: String
    @Binding var alert: Bool
    @Binding var selectedAlert: Alerts?
    
    var date: Date
    private var isToday: Bool {
        return date.stripTime() == Date.now.stripTime()
    }

    var body: some View {
        Button(action: {
            if isToday {
                if reps.isEmpty || weight.isEmpty {
                    self.selectedAlert = .addEmptyReps
                    alert = true
                } else {
                    reps = reps.replacingOccurrences(of: ",", with: ".")
                    weight = weight.replacingOccurrences(of: ",", with: ".")
                    repsDB.save(exerciseId: exercise.id!, repetari: Int(reps) ?? 0, weight: Double(weight) ?? 0, exerciseDate: exercise.date!)
                    reps = ""
                    weight = ""
                    repsViewModel.fetchRepsByDate(for: Date.now)
                }
            }
        }) {
            HStack{
                Text("Add")
                    .padding()
                    .foregroundColor(.white)
                    .padding(.trailing, -15)
                Image(systemName: "plus")
                    .foregroundColor(.white)
                    .padding(.trailing)
            }

            .background(isToday ? Color.blue : Color.gray)
            .cornerRadius(20)
        }
    }
}
