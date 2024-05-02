//
//  HistoryView.swift
//  Gym Buddy
//
//  Created by Stefan Miloiu on 02.05.2024.
//

import SwiftUI

struct HistoryView: View {
    
    //MARK: - Properties
    @EnvironmentObject var exerciseViewModel: ExercisesViewModel
    @EnvironmentObject var repsViewModel: RepsViewModel
    
    @Binding var tabSelection: Int
    @Binding var date: Date

    //MARK: - Body
    var body: some View {
        ScrollView {
            VStack {
                
                Text("History")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                ExtractedView(tabSelection: $tabSelection, date: $date)
            }//:VStack
        }
        .onAppear {
            exerciseViewModel.fetchReversSortedExercises()
        }
    }
}

#Preview {
    HistoryView(tabSelection: .constant(1), date: .constant(Date()))
        .environmentObject(ExercisesViewModel())
        .environmentObject(RepsViewModel())
}

struct ExtractedView: View {
    
    //MARK: - Properties
    @EnvironmentObject var exerciseViewModel: ExercisesViewModel
    @EnvironmentObject var repsViewModel: RepsViewModel
    
    @Binding var tabSelection: Int
    @Binding var date: Date
    
    var body: some View {
        VStack {
            let uniqueDates = Array(Set(exerciseViewModel.exercises.map({ $0.date!.stripTime()})))
            let uniqueSortedDates = uniqueDates.sorted(by: >)
            
            ForEach(uniqueSortedDates, id: \.self) { date in
                Section {
                    let exercisesByDate = exerciseViewModel.exercises.filter({ $0.date?.stripTime() == date })
                    let bodyPartsByExercise = exerciseViewModel.getAllBodyPartsString(exercises: exercisesByDate)
                    
                    Button(action: {
                        print(date)
                        self.date = date
                        tabSelection = 0
                    }, label: {
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
                                ImportFromHistoryButton(exercises: exercises)
                                    .environmentObject(exerciseViewModel)
                                    .environmentObject(repsViewModel)
                            }//:HStack
                        }
                    })
                    .buttonStyle(.plain)
                    .padding(10)
                } header: {
                    Text("\(date.formatted(date: .abbreviated, time: .omitted))")
                        .padding(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, -10)
                        .padding(.top, 10)
                        .fontWeight(.medium)
                        .foregroundStyle(.gray)
                    
                }//:Header
            }
        }
    }
}
