//
//  RemoveFromHistoryButton.swift
//  Gym Buddy
//
//  Created by Stefan Miloiu on 02.05.2024.
//

import SwiftUI

struct RemoveFromHistoryButton: View {
    
    @EnvironmentObject var exerciseViewModel: ExercisesViewModel
    @EnvironmentObject var repsViewModel: RepsViewModel
    
    let exercises: [Exercise]
    
    var body: some View {
        Button {
            exerciseViewModel.deleteExercisesFromHistory(exercises: exercises)
        } label: {
            Text("Remove")
                .fontWeight(.medium)
                .frame(width: 110, height: 35)
                .background(Color.red)
                .tint(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding(.horizontal, 10)
    }
}

#Preview {
    RemoveFromHistoryButton(exercises: [])
        .environmentObject(ExercisesViewModel())
        .environmentObject(RepsViewModel())
}
