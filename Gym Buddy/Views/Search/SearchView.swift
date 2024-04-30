//
//  HomeView.swift
//  Gym Buddy
//
//  Created by Stefan Miloiu on 25.04.2024.
//

import Foundation
import SwiftUI

struct SearchView: View {
    @Binding var searchText: String
    
    /*
     Networking...
     @State private var networkEx = NetworkExercise()
     */
    
    @Binding var exercises: [ExerciseApi]
    var body: some View {
        VStack{
            List{
                ForEach(exercises, id: \.self) {exercise in
                        CustomExerciseView(exercise: exercise)
                            .background(
                                NavigationLink(
                                    destination: ExerciseDetailView(exercise: exercise),
                                    label: {
                                        EmptyView()
                                    })
                                .opacity(0)
                            )
                }//:ForEach
                .background(Color.clear)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
            }//:List
            .background(Color.clear)
            .listStyle(.insetGrouped)
            .listRowSpacing(10)
        }//VStack
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(searchText: .constant(""), exercises: .constant([ExerciseApi(bodyPart: "upper legs", equipment: "body weight", gifUrl: "https://v2.exercisedb.io/image/NnZC1Wzq6EscDG", id: "3562", name: "world greatest stretch", target: "hamstrings")]))
    }
}
