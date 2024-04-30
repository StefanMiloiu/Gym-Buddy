//
//  SwiftUIView.swift
//  Gym Buddy
//
//  Created by Stefan Miloiu on 25.04.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct CustomExerciseView: View {
    //MARK: - Properties
    let exercise: ExerciseApi
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 150)
                .foregroundColor(.gray.opacity(0.1))
            VStack{
                Text(exercise.name.capitalized)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                HStack{
                    VStack{
                        Text("Perfect exercise for \(exercise.bodyPart.capitalized)")
                            .multilineTextAlignment(.center)
                        Text("Targeting especially \(exercise.target.capitalized)")
                            .multilineTextAlignment(.center)
                        Text("Equipment needed: \(exercise.equipment.capitalized)")
                            .multilineTextAlignment(.center)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }//: VStack
                    AsyncImage(url: URL(string: exercise.gifUrl)) { image in
                        image
                            .resizable()
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 90, height: 90)
                }//: HStack
            }//: VStack
        }//: ZStack
    }
}

struct CustomExerciseHomeView: View {
    //MARK: - Properties
    let exercise: Exercise
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 150)
                .foregroundColor(.gray.opacity(0.1))
            VStack{
                Text(exercise.name!.capitalized)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                HStack{
                    VStack{
                        Text("Perfect exercise for \(exercise.bodyPart!.capitalized)")
                            .multilineTextAlignment(.center)
                        Text("Targeting especially \(exercise.target!.capitalized)")
                            .multilineTextAlignment(.center)
                        Text("Equipment needed: \(exercise.equipment!.capitalized)")
                            .multilineTextAlignment(.center)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }//: VStack
                    AsyncImage(url: URL(string: exercise.gifUrl!)) { image in
                        image
                            .resizable()
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 90, height: 90)
                }//: HStack
            }//: VStack
        }//: ZStack
    }
}

#Preview {
    CustomExerciseView(exercise: ExerciseApi(bodyPart: "upper legs", equipment: "body weight", gifUrl: "https://v2.exercisedb.io/image/NnZC1Wzq6EscDG", id: "1256", name: "world greatest stretch", target: "hamstrings"))
}
