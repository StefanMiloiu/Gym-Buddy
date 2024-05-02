//
//  ImportFromHistoryButton.swift
//  Gym Buddy
//
//  Created by Stefan Miloiu on 02.05.2024.
//

import SwiftUI


struct ImportFromHistoryButton: View {
    
    @EnvironmentObject var exerciseViewModel: ExercisesViewModel
    @EnvironmentObject var repsViewModel: RepsViewModel
    
    let exercises: [Exercise]
    
    var body: some View {
        Button {
            exerciseViewModel.importFromHistory(exercises: exercises)
        } label: {
            Text("Import")
                .fontWeight(.medium)
                .frame(width: 110, height: 35)
                .background(Color.black)
                .tint(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding(.horizontal, 10)
    }
}

#Preview {
    ImportFromHistoryButton(exercises: [])
        .environmentObject(ExercisesViewModel())
        .environmentObject(RepsViewModel())
}
