//
//  HistoryExerciseCard.swift
//  Gym Buddy
//
//  Created by Stefan Miloiu on 03.05.2024.
//

import SwiftUI

struct HistoryExerciseCard: View {
    
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
                                Text("\(exercise.name!.capitalized)")
                                    .font(.title3)
                                    .padding(.top)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 120, height: 80)
                                
                                AsyncImage(url: URL(string: exercise.gifUrl!)) { image in
                                    image
                                        .resizable()
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 90, height: 90)
                            }
                            .padding(10)
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
            
            //MARK: - Import/Remove Buttons
            let exercises = exerciseViewModel.exercises.filter({ $0.date?.stripTime() == date })
            HStack{
                RemoveFromHistoryButton(exercises: exercises)
                    .environmentObject(exerciseViewModel)
                    .environmentObject(repsViewModel)
                Spacer()
                if date.stripTime() != Date.now.stripTime() {
                    ImportFromHistoryButton(exercises: exercises)
                        .environmentObject(exerciseViewModel)
                        .environmentObject(repsViewModel)
                }
            }//:HStack
        }
    }
}

#Preview {
    HistoryExerciseCard(date: Date())
        .environmentObject(ExercisesViewModel())
        .environmentObject(RepsViewModel())
}
