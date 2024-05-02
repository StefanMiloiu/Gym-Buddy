//
//  SuggestionsView.swift
//  Gym Buddy
//
//  Created by Stefan Miloiu on 01.05.2024.
//

import SwiftUI

struct SuggestionsView: View {
    
    @State var localFetch = LocalFetch()
    
    func randomExercises() -> [ExerciseApi] {
        let exercises = localFetch.fetchExercises()
        let random = exercises.shuffled()
        return Array(random.prefix(10))
    }
    
    var body: some View {
        NavigationStack {
            GroupBox(label: Label("Suggestions", systemImage: "flame.fill")) {
            ScrollView(.horizontal) {
                    HStack{
                        ForEach(randomExercises(), id: \.self) { exercise in
                            NavigationLink(destination: ExerciseDetailView(exercise: exercise)) {
                                CustomExerciseView(exercise: exercise)
                            }
                        }
                    }
                }
            }
        }
        .tint(.gray)
    }
}

#Preview {
    SuggestionsView()
        .environmentObject(ExercisesViewModel())
}
