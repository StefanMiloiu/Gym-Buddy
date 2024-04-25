//
//  Gym_BuddyApp.swift
//  Gym Buddy
//
//  Created by Stefan Miloiu on 25.04.2024.
//

import SwiftUI

@main
struct Gym_BuddyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
