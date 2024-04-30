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
    
    var body: some View {
        TabView {
            HomeTabView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            SearchTabView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
        }
    }
}

#Preview {
    MainView()
        .environment(\.managedObjectContext, CoreDataProvider.shared.viewContext)
}
