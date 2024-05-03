//
//  CompactHistoryExerciseCard.swift
//  Gym Buddy
//
//  Created by Stefan Miloiu on 03.05.2024.
//

import SwiftUI

struct CompactHistoryExerciseCard: View {
    @EnvironmentObject var exerciseViewModel: ExercisesViewModel
    @EnvironmentObject var repsViewModel: RepsViewModel
    
    let date: Date
    
    var body: some View {
        
        let exercisesByDate = exerciseViewModel.exercises.filter({ $0.date?.stripTime() == date })
        let bodyPartsByExercise = exerciseViewModel.getAllBodyPartsString(exercises: exercisesByDate)
        
        GroupBox("\(date.getCurrentDay(from: date))  -  \(bodyPartsByExercise)") {
            ScrollView (.horizontal) {
                HStack {
                    ForEach(exerciseViewModel.exercises.filter({ $0.date?.stripTime() == date }), id: \.self) { exercise in
                        GroupBox{
                            VStack {
                                AsyncImage(url: URL(string: exercise.gifUrl!)) { image in
                                    image
                                        .resizable()
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 50, height: 50)
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
        }
    }

}

#Preview {
    CompactHistoryExerciseCard(date: Date())
        .environmentObject(ExercisesViewModel())
        .environmentObject(RepsViewModel())
}
