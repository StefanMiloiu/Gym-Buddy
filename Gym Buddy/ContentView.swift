//
//  ContentView.swift
//  Gym Buddy
//
//  Created by Stefan Miloiu on 25.04.2024.
//
import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    private var network = Network()
    private var exercisesModel = NetworkExercise()
    
    @State var exercises: [Exercise] = []
    @State var searchText = ""
    @State var bodyPartSelected = ""
    @State var targetSelected = ""
    
    private var filterApplied: Bool {
        return !bodyPartSelected.isEmpty || !targetSelected.isEmpty
    }
    
    var body: some View {
        NavigationView {
            SearchView(searchText: $searchText, exercises: $exercises)
                .navigationTitle("Exercises")
                .toolbar{
                    ToolbarItem(placement: .primaryAction) {
                        NavigationLink(
                            destination: AdvancedSearch(searchText: $searchText, exercises: $exercises, bodyPartSelected: $bodyPartSelected, targetSelected: $targetSelected)
                                .navigationTitle(Text("Advanced Search"))
                            ,label: {
                                Image(systemName: "gearshape.2")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundStyle(filterApplied ? .red : .gray)
                                    .padding(7)
                                    .cornerRadius(8)
                                Text("Filter")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundStyle(filterApplied ? .red : .gray)
                            })
                    }
                }
        }//: NavigationView
        .onAppear {
            exercises = exercisesModel.fetchExercises()
        }
        .tint(.black)
        .searchable(text: $searchText)
        .autocorrectionDisabled()
        .textInputAutocapitalization(.words)
        .onSubmit(of: .search) {
            exercises = exercisesModel.searchExercises(searchText: searchText)

        }
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
