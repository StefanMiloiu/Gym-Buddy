//
//  ContentView.swift
//  Gym Buddy
//
//  Created by Stefan Miloiu on 25.04.2024.
//
import SwiftUI
import CoreData

struct ContentView: View {
    
    var body: some View {
        MainView()
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, CoreDataProvider.shared.viewContext)
//        .onAppear {
//            print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
//        }
}
