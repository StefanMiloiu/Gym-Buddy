//
//  SearchView.swift
//  Gym Buddy
//
//  Created by Stefan Miloiu on 27.04.2024.
//

import SwiftUI

struct SearchTabView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var items: FetchedResults<Exercise>
    /*
     Networking...
     private var network = Network()
     private var exercisesModel = NetworkExercise()
     */
    @State var exercises: [ExerciseApi] = []
    @State var searchText = ""
    @State var bodyPartSelected = ""
    @State var targetSelected = ""
    @State var equipmentSelected = ""
    
    private var filterApplied: Bool {
        return !bodyPartSelected.isEmpty || !targetSelected.isEmpty
    }
    
    var body: some View {
        NavigationView {
            if exercises.isEmpty && !searchText.isEmpty{
                EmptySearchView()
            } else {
                SearchView(searchText: $searchText, exercises: $exercises)
                    .navigationTitle("Exercises")
                    .toolbar{
                        ToolbarItem(placement: .primaryAction) {
                            NavigationLink(
                                destination: AdvancedSearch(searchText: $searchText, exercises: $exercises, bodyPartSelected: $bodyPartSelected, targetSelected: $targetSelected, equipmenSelected: $equipmentSelected)
                                    .navigationTitle(Text("Advanced Search"))
                                ,label: {
                                    Image(systemName: "gearshape.2")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundStyle(filterApplied ? .blue : .gray)
                                        .padding(7)
                                        .cornerRadius(8)
                                    Text("Filter")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundStyle(filterApplied ? .blue : .gray)
                                })
                        }//: ToolbarItem
                    }//: Toolbar
            }
        }//: NavigationView
        .onChange(of: searchText) { value in
            if searchText.isEmpty {
                exercises = LocalFetch.shared.fetchExercises()
            }
        }
        .onAppear {
            exercises = LocalFetch.shared.fetchExercises()
        }
        .searchable(text: $searchText)
        .autocorrectionDisabled()
        .textInputAutocapitalization(.words)
        .onSubmit(of: .search) {
            exercises = LocalFetch.shared.searchExercises(searchText: searchText)
            /*
             Networking...
             exercises = exercisesModel.searchExercises(searchText: searchText)
             */
        }
    }
}

#Preview {
    SearchTabView()
}
