//
//  ExerciseDetailView.swift
//  Gym Buddy
//
//  Created by Stefan Miloiu on 25.04.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct ExerciseDetailView: View {
    var exercise: Exercise
    var body: some View {
        VStack{
            //MARK: - Title
            Text(exercise.name.capitalized)
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            //MARK: - Gif
            AnimatedImage(url: URL(string: exercise.gifUrl)) {
                ProgressView()
            }
            .resizable()
            .aspectRatio(contentMode: .fit)
            
            //MARK: - Target
            Text("\(exercise.bodyPart.capitalized) - Use \(exercise.equipment.capitalized)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
            Button {
                print("Add workout")
            } label: {
                Text("Add workout")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)
            }
        }
        .tint(.blue)
    }
}

#Preview {
    ExerciseDetailView(exercise: Exercise(bodyPart: "Chest", equipment: "Barbell", gifUrl: "https://v2.exercisedb.io/image/A9daVLayGoP-Nz", id: "1256", name: "Bench Press", target: "Chest"))
}
