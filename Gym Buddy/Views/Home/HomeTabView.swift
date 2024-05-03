//
//  HomeView.swift
//  Gym Buddy
//
//  Created by Stefan Miloiu on 27.04.2024.
//

import SwiftUI

enum Alerts {
    case deleteExercise, addEmptyReps
}

struct HomeTabView: View {
    
    @State var selectedAlert: Alerts?
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(fetchRequest: Exercise.all())
    private var exercisesDB: FetchedResults<Exercise>
    
    @FetchRequest(fetchRequest: Reps.all())
    private var repsDB: FetchedResults<Reps>
    @State private var isEditing: Bool = false
    @State var alert: Bool = false
    
    var today: (Exercise) -> Bool = { exercise in
        let date = Date()
        return date.stripTime() == exercise.date?.stripTime()
    }
    
    @State private var selectedExercise: Exercise? = nil
    @State private var repositoryReps = RepsDB()
    @State private var repositoryExercises = ExercisesDB()
    
    @Binding var date: Date
    @State var datePickerIsActive = false
    
    @EnvironmentObject var exerciseViewModel: ExercisesViewModel
    @EnvironmentObject var repsViewModel: RepsViewModel
    
    @Binding var selectedTab: Int
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        isEditing = false
    }
    
    private var isToday: Bool {
        return date.stripTime() == Date.now.stripTime()
    }
    
    var body: some View {
        NavigationStack{
            if exerciseViewModel.exercises.isEmpty {
                SuggestionsView()
                    .scrollIndicators(.never)
                    .navigationTitle("Home")
                    .padding(.horizontal)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                datePickerIsActive = true
                            }, label: {
                                CompactDatePicker()
                            })
                        }
                    }
                HStack{
                    Text("No exercises this day.\n Here are some suggestions  \(Image(systemName: "arrow.turn.right.up").resizable())")
                        .font(.title2)
                        .bold()
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                ImportSuggestionView(selectedTab: $selectedTab)
                    .padding(.top)
                    .padding(.horizontal)
                
                Spacer()
            } else {
                ScrollView {
                    ForEach(Array(exerciseViewModel.exercises.enumerated()), id: \.offset) { index, exercise in
                        VStack(alignment: .leading){
                            Section(header: Text("Exercise \(index + 1)")) {
                                VStack {
                                    ZStack(alignment: .bottomTrailing) {
                                        CustomExerciseHomeView(exercise: exercise)
                                        Button(action: {
                                            if isToday{
                                                self.selectedExercise = exercise
                                                self.selectedAlert = .deleteExercise
                                                alert = true
                                            }
                                        }) {
                                            Image(systemName: "trash.slash.fill")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .foregroundStyle(isToday ?.gray : .clear, isToday ? .red.opacity(0.7) : .clear)
                                                .frame(width: 25, height: 25)
                                        }
                                    }
                                    CustomRepsView(reps: repsViewModel.reps.filter { $0.exerciseId == exercise.id })
                                        .environmentObject(repsViewModel)// Pass repsViewModel here
                                        CustomExerciseRepsView(exercise: exercise,
                                                               selectedAlert: $selectedAlert, alert: $alert, date: date)
                                    .environmentObject(repsViewModel) // Pass repsViewModel here
                                }
                            }
                        }
                    }
                    .alert(isPresented: $alert) {
                        switch selectedAlert {
                        case .deleteExercise:
                            return Alert(title: Text("Are you sure you want to delete this exercise?"), primaryButton: .destructive(Text("Delete")) {
                                if let exercise = self.selectedExercise {
                                    exerciseViewModel.deleteExerciseById(exercise: exercise)
                                }
                            }, secondaryButton: .cancel())
                        default:
                            return Alert(title: Text("Empty fields!"),
                                         message: Text("Please fill in all the fields")
                                        .fontWeight(.bold), dismissButton: .default(Text("OK")))
                        }
                    }
                    .padding(.bottom, 30)
                }
                .scrollIndicators(.never)
                .navigationTitle("Home")
                .padding(.horizontal)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            datePickerIsActive = true
                        }, label: {
                            CompactDatePicker()
                        })
                    }
                }
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
        .onAppear {
            exerciseViewModel.fetchExercisesByDate(for: date)
            repsViewModel.fetchRepsByDate(for: date)
        }
        .sheet(isPresented: $datePickerIsActive) {
            DatePickerView(date: $date, isActive: $datePickerIsActive)
                .environmentObject(exerciseViewModel)
                .environmentObject(repsViewModel)
                .presentationCompactAdaptation(horizontal: .fullScreenCover, vertical: .popover)
                .presentationDragIndicator(.visible)
        }
    }
}


#Preview {
    HomeTabView(date: .constant(Date.now), selectedTab: .constant(0))
        .environment(\.managedObjectContext, CoreDataProvider.shared.viewContext)
        .environmentObject(ExercisesViewModel())
        .environmentObject(RepsViewModel())
}
