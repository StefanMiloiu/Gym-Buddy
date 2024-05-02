//
//  MainView.swift
//  Gym Buddy
//
//  Created by Stefan Miloiu on 27.04.2024.
//
 
import SwiftUI

struct MainView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var searchText = ""
    @State private var exercises: [ExerciseApi] = []
    @State var date: Date = Date.now
    
    @EnvironmentObject var exercisesViewModel: ExercisesViewModel
    @EnvironmentObject var repsViewModel: RepsViewModel
    
    var body: some View {
        TabView {
            HomeTabView(date: $date)
                .tabItem {
                    if date.stripTime() == Date.now.stripTime(){
                        Label("Home", systemImage: "house")
                    } else {
                        Label("Old workout", systemImage: "viewfinder")
                    }
                }
                .environmentObject(exercisesViewModel)
                .environmentObject(repsViewModel)
            if date.stripTime() == Date.now.stripTime(){
                SearchTabView()
                    .environmentObject(exercisesViewModel)
                    .environmentObject(repsViewModel)
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
            }
        }
    }
}

#Preview {
    MainView()
        .environment(\.managedObjectContext, CoreDataProvider.shared.viewContext)
}
