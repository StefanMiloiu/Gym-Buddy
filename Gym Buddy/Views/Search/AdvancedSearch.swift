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

    @State private var network = Network()
    @State private var exercisesModel = NetworkExercise()
    
    @Binding var searchText: String
    @Binding var exercises: [Exercise]
    
    @Binding var bodyPartSelected: String
    @Binding var targetSelected: String
    
    @State var intactExercises: [Exercise]  = []
    
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
                                print(newValue)
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
                                print(newValue)
                                bodyPartSelected = newValue
                            }
                        }//: HStack 1.1
                    }//: Section
                    
                    //MARK: - Search Button
                    Button(action: {
                        exercises = exercisesModel.searchAdvanced(bodyPart: bodyPartSelected, target: targetSelected)
                        presentationMode.wrappedValue.dismiss()
                        //hide the view
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
            intactExercises = exercisesModel.fetchExercises()
            if bodyPartSelected == "" {
                bodyPartSelected = "All"
            }
            if targetSelected == "" {
                targetSelected = "All"
            }
        }
    }
}

struct AdvancedSearch_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedSearch(searchText: .constant(""), exercises: .constant([Exercise(bodyPart: "Chest", equipment: "Barbell", gifUrl: "https://v2.exercisedb.io/image/A9daVLayGoP-Nz", id: "1256", name: "Bench Press", target: "Upper Chest")]), bodyPartSelected: .constant("Chest"), targetSelected: .constant("Chest"))
    }
}
