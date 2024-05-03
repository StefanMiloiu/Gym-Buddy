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

    @State var compact: Bool = true
    //MARK: - Body
    var body: some View {
        ScrollView {
            VStack {
                HStack{
                    Text("History")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                    
                    Button(action: {
                        withAnimation {
                            compact.toggle()
                        }
                    }, label: {
                        Text(compact ? "Expand" : "Compact")
                            .fontWeight(.medium)
                            .frame(width: 150, height: 35)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .transition(.opacity)
                    })
                }
                
                History(tabSelection: $tabSelection, date: $date, compact: $compact)
            }//:VStack
        }
    }
}

#Preview {
    HistoryView(tabSelection: .constant(1), date: .constant(Date()))
        .environmentObject(ExercisesViewModel())
        .environmentObject(RepsViewModel())
}

struct History: View {
    
    //MARK: - Properties
    @EnvironmentObject var exerciseViewModel: ExercisesViewModel
    @EnvironmentObject var repsViewModel: RepsViewModel
    
    @Binding var tabSelection: Int
    @Binding var date: Date
    
    @Binding var compact: Bool
    
    var body: some View {
        VStack {
            let uniqueDates = Array(Set(exerciseViewModel.exercises.map({ $0.date?.stripTime() ?? Date()})))
            let uniqueSortedDates = uniqueDates.sorted(by: >)
            
            ForEach(uniqueSortedDates, id: \.self) { date in
                Section {
                    Button(action: {
                        self.date = date
                        tabSelection = 0
                    }, label: {
                        if compact {
                            CompactHistoryExerciseCard(date: date)
                                .environmentObject(exerciseViewModel)
                                .environmentObject(repsViewModel)
                                .transition(.opacity)
                            /*.fade(duration: 0.5)*/
                        } else {
                            HistoryExerciseCard(date: date)
                                .environmentObject(exerciseViewModel)
                                .environmentObject(repsViewModel)
                                .transition(.opacity)
                        }
                    })
                    .buttonStyle(.plain)
                    .padding(10)
                } header: {
                    let today = Date.now.stripTime() == date.stripTime()
                    Text("\( today ? "Today" : date.formatted(date: .abbreviated, time: .omitted))")
                        .padding(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, -10)
                        .padding(.top, 10)
                        .fontWeight(.medium)
                        .foregroundStyle(.gray)
                }//:Header
            }//:ForEach
        }
        .onAppear {
            exerciseViewModel.fetchSortedExercises()
        }
    }
}
