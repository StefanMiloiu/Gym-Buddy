//
//  ExerciseDetailView.swift
//  Gym Buddy
//
//  Created by Stefan Miloiu on 25.04.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct ExerciseDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    var exercise: ExerciseApi
    @State private var exercisesDB = ExercisesDB()
    @State private var alreadyExists = false
    
    @EnvironmentObject var exercisesVm: ExercisesViewModel
    var body: some View {
        VStack{
            Spacer()

            //MARK: - Title
            Text(exercise.name.capitalized)
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            //MARK: - Gif
            AnimatedImage(url: URL(string: exercise.gifUrl)) {
                ProgressView()
            }
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 350, height: 350)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            //MARK: - Target
            Text("\(exercise.bodyPart.capitalized) - Use \(exercise.equipment.capitalized)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
            Button {
                do {
                    try exercisesDB.save(id: exercise.id, name: exercise.name, bodyPart: exercise.bodyPart, equipment: exercise.equipment, target: exercise.target, gifUrl: exercise.gifUrl)
                    exercisesVm.fetchExercisesByDate(for: Date.now)
                } catch {
                    alreadyExists.toggle()
                }
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Add workout")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            .alert(isPresented: $alreadyExists) {
                Alert(title: Text("Could not add"), message: Text("Exercise already exists").font(.headline), dismissButton: .default(Text("OK")))
            }
            Spacer()

        }
        .tint(.blue)
    }
}

#Preview {
    ExerciseDetailView(exercise: ExerciseApi(bodyPart: "Chest", equipment: "Barbell", gifUrl: "https://v2.exercisedb.io/image/A9daVLayGoP-Nz", id: "1256", name: "Bench Press", target: "Chest"))
        .environmentObject(ExercisesViewModel())
}
