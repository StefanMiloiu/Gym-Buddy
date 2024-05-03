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
    
    @State var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeTabView(date: $date, selectedTab: $selectedTab)
                .tabItem {
                    if date.stripTime() == Date.now.stripTime(){
                        Label("Home", systemImage: "house")
                    } else {
                        Label("Old workout", systemImage: "viewfinder")
                    }
                }
                .tag(0)
                .environmentObject(exercisesViewModel)
                .environmentObject(repsViewModel)
            if date.stripTime() == Date.now.stripTime(){
                SearchTabView()
                    .environmentObject(exercisesViewModel)
                    .environmentObject(repsViewModel)
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                    .tag(1)
            }
            HistoryView(tabSelection: $selectedTab, date: $date)
                .environmentObject(exercisesViewModel)
                .environmentObject(repsViewModel)
                .tabItem {
                    Label("History", systemImage: "clock")
                }
                .tag(2)
        }
    }
}

#Preview {
    MainView()
        .environment(\.managedObjectContext, CoreDataProvider.shared.viewContext)
}
