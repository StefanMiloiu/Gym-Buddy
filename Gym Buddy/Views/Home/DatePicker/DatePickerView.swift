//
//  DatePickerView.swift
//  Gym Buddy
//
//  Created by Stefan Miloiu on 01.05.2024.
//

import Foundation
import SwiftUI

struct DatePickerView: View {
    @EnvironmentObject var exerciseViewModel: ExercisesViewModel
    @EnvironmentObject var repsViewModel: RepsViewModel

    @Binding var date: Date
    @Binding var isActive: Bool

    var body: some View {
        Form {
            DatePicker("Select a date", selection: $date,in: ...Date(), displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
                .onChange(of: date) { newDate in
                    date = newDate
                    exerciseViewModel.fetchExercisesByDate(for: newDate)
                    repsViewModel.fetchRepsByDate(for: newDate)
                    isActive = false
                }
                .onAppear {
                        
                }
            Section {
                Button(action: {
                    isActive = false
                }, label: {
                    Label("Go Back", systemImage: "arrow.circlepath")
                        .foregroundColor(.accentColor)
                        .frame(maxWidth: .infinity, alignment: .center) // Center the label horizontally
                })
                Text("This app was made by Stefan Miloiu and has no commercial purpose. It is made to help you keep track of your exercises and reps and also improve my Swift skills. Enjoy!")
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.gray.opacity(0.7))
            }
            .listRowSeparator(.hidden)
        }
    }
}
