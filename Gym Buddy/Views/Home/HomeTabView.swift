//
//  HomeView.swift
//  Gym Buddy
//
//  Created by Stefan Miloiu on 27.04.2024.
//

import SwiftUI


struct HomeTabView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(fetchRequest: Exercise.all())
    private var exercisesDB: FetchedResults<Exercise>
    
    @FetchRequest(fetchRequest: Reps.all())
    private var repsDB: FetchedResults<Reps>
    @State private var isEditing: Bool = false
    @State private var checkAlert: Bool = false
    
    var today: (Exercise) -> Bool = { exercise in
        let date = Date()
        return date.stripTime() == exercise.date?.stripTime()
    }
    
    @State private var selectedExercise: Exercise? = nil
    @State private var repositoryReps = RepsDB()
    @State private var repositoryExercises = ExercisesDB()
    
    private func filtereReps(exercise: Exercise) -> [Reps] {
        repsDB.filter { $0.exerciseId == exercise.id }
    }
    
    private func sortedReps(exercise: Exercise) -> [Reps] {
        filtereReps(exercise: exercise).sorted { $0.exerciseDate! < $1.exerciseDate!}
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        isEditing = false
    }
    
    var body: some View {
        NavigationStack{
            ScrollView {
                ForEach(exercisesDB.filter { today($0) }.sorted(by: { $0.date! < $1.date!})) { exercise in
                    VStack(alignment: .leading){
                        Section(header: Text("Exercise \(exercisesDB.firstIndex(of: exercise).map { String($0 + 1) } ?? "")")) {
                            VStack {
                                ZStack(alignment: .topLeading) {
                                    CustomExerciseHomeView(exercise: exercise)
                                    Button(action: {
                                        self.selectedExercise = exercise
                                        checkAlert = true
                                    }) {
                                        Image(systemName: "trash.slash.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundStyle(.gray, .red.opacity(0.7))
                                            .frame(width: 25, height: 25)
                                            .padding(10)
                                    }
                                }
                                ForEach(sortedReps(exercise: exercise).sorted(by: {$0.exerciseDate! < $1.exerciseDate! })) { rep in
                                    CustomRepsView(reps: rep)
                                }
                                HStack{
                                    CustomExerciseRepsView(exercise: exercise)
                                }
                            }
                        }
                    }
                    .alert(isPresented: $checkAlert) {
                        Alert(title: Text("Are you sure you want to delete this exercise?"), primaryButton: .destructive(Text("Delete")) {
                            if let exercise = self.selectedExercise {
                                repositoryExercises.deleteExerciseByIdAndDate(id: exercise.id!, date: exercise.date!)
                            }
                        }, secondaryButton: .cancel())
                    }
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("Home")
            .padding(.horizontal)
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
}

struct CustomExerciseRepsView: View {
    @State var reps: String = ""
    @State var weight: String = ""
    
    let exercise: Exercise
    
    var body: some View {
        HStack {
            TextField("Reps", text: $reps)
                .keyboardType(.numberPad)
                .padding(15)
                .background(Color(.systemGray5))
                .cornerRadius(10)
                .padding(.vertical, 10)
            
            TextField("Weight (Kg)", text: $weight)
                .keyboardType(.decimalPad)
                .padding(15)
                .background(Color(.systemGray5))
                .cornerRadius(10)
            AddRepsButton(exercise: exercise, reps: $reps, weight: $weight)
        }
    }
}

struct AddRepsButton: View {
    @State private var repsDB = RepsDB()
    let exercise: Exercise
    @Binding var reps: String
    @Binding var weight: String
    @State private var alert: Bool = false
    var body: some View {
        Button(action: {
            if reps.isEmpty || weight.isEmpty {
                alert = true
            } else {
                reps = reps.replacingOccurrences(of: ",", with: ".")
                weight = weight.replacingOccurrences(of: ",", with: ".")
                repsDB.save(exerciseId: exercise.id!, repetari: Int(reps) ?? 0, weight: Double(weight) ?? 0)
                reps = ""
                weight = ""
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
            .alert(isPresented: $alert) {
                Alert(title: Text("Empty fields!"), message: Text("Please fill in all the fields"), dismissButton: .default(Text("OK")))
            }
            .background(Color.blue)
            .cornerRadius(20)
        }
    }
}

struct CustomRepsView: View {
    
    let reps: Reps
    
    var body: some View {
        HStack {
            Text("\(reps.reps ?? 0) Reps")
            Spacer()
            Text("\(reps.weight.formatted(.number.precision(.fractionLength(1)))) Kg")
        }
        .padding()
        .background(Color(.systemGray5))
        .cornerRadius(10)
    }
}

#Preview {
    HomeTabView()
        .environment(\.managedObjectContext, CoreDataProvider.shared.viewContext)
}
