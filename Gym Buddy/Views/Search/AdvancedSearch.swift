//
//  AdvancedSearch.swift
//  Gym Buddy
//
//  Created by Stefan Miloiu on 25.04.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct AdvancedSearch: View {
    @Environment(\.presentationMode) var presentationMode
    
    /*
     Networking...
     @State private var network = Network()
     @State private var exercisesModel = NetworkExercise()
     */
    
    @Binding var searchText: String
    @Binding var exercises: [ExerciseApi]
    
    @Binding var bodyPartSelected: String
    @Binding var targetSelected: String
    @Binding var equipmenSelected: String
    
    @State var intactExercises: [ExerciseApi]  = []
    
    var body: some View {
        VStack{
            HStack{
                List{
                    
                    //MARK: - Body Part Section
                    Section{
                        HStack{
                            Picker(selection: $bodyPartSelected, label: Text("Body Part")) {
                                Text("All").tag("")
                                ForEach(Array(Set(intactExercises.map { $0.bodyPart})).sorted(), id: \.self) {
                                    Text($0.capitalized)
                                        .tag($0)
                                }
                            }//: Picker
                            .pickerStyle(.automatic)
                            .onChange(of: bodyPartSelected) { newValue in
                                bodyPartSelected = newValue
                            }
                        }//: HStack 1.0
                        
                        //MARK: - Target Section
                        HStack{
                            Picker(selection: $targetSelected, label: Text("Target")) {
                                Text("All").tag("")
                                ForEach(Array(Set(intactExercises.filter {$0.bodyPart == bodyPartSelected} .map { $0.target})).sorted(), id: \.self) {
                                    Text($0.capitalized)
                                        .tag($0)
                                }
                            }//: Picker
                            .pickerStyle(.automatic)
                            .onChange(of: bodyPartSelected) { newValue in
                                bodyPartSelected = newValue
                            }
                        }//: HStack 1.1
                    }//: Section
                    
                    Section {
                        Picker(selection: $equipmenSelected, label: Text("Equipment")) {
                            Text("Any").tag("")
                            ForEach(Array(Set(intactExercises.filter {$0.bodyPart == bodyPartSelected} .map { $0.equipment})).sorted(), id: \.self) {
                                Text($0.capitalized)
                                    .tag($0)
                            }
                        }//: Picker
                    }
                    
                    //MARK: - Search Button
                    Button(action: {
                        exercises = LocalFetch.shared.searchAdvanced(bodyPart: bodyPartSelected, target: targetSelected, equipmenet: equipmenSelected)
                        /*
                         Networking...
                         exercises =exercisesModel.searchAdvanced(bodyPart: bodyPartSelected, target: targetSelected)
                         */
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        HStack{
                            Spacer()
                            Text("Search")
                            Spacer()
                        }
                    })
                    
                }//: List
            }//: HStack
        }//: VStack
        .onAppear {
            /*
             Networking...
             intactExercises = exercisesModel.fetchExercises()
             */
            intactExercises = LocalFetch.shared.fetchExercises()
        }
    }
}

struct AdvancedSearch_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedSearch(searchText: .constant(""), exercises: .constant([ExerciseApi(bodyPart: "Chest", equipment: "Barbell", gifUrl: "https://v2.exercisedb.io/image/A9daVLayGoP-Nz", id: "1256", name: "Bench Press", target: "Upper Chest")]), bodyPartSelected: .constant("Chest"), targetSelected: .constant("Chest"), equipmenSelected: .constant("Barbell"))
    }
}
