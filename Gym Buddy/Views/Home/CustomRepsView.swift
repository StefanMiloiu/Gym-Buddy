//
//  CustomRepsView.swift
//  Gym Buddy
//
//  Created by Stefan Miloiu on 01.05.2024.
//

import Foundation
import SwiftUI


struct SwipeToDeleteModifier: ViewModifier {
    var onDelete: () -> Void // Action to perform when swiped
    
    func body(content: Content) -> some View {
        content
            .contextMenu {
                Button(action: onDelete) {
                    Text("Delete")
                    Image(systemName: "trash")
                }
            }
    }
}

extension View {
    func swipeToDelete(onDelete: @escaping () -> Void) -> some View {
        self.modifier(SwipeToDeleteModifier(onDelete: onDelete))
    }
}

struct CustomRepsView: View {

    let reps: [Reps] // Reps data for the current exercise
    @ObservedObject var repsViewModel = RepsViewModel()
    var body: some View {
        ForEach(reps, id: \.self) { reps in
            HStack {
                Text("\(reps.reps ?? 0) Reps")
                Spacer()
                Text("\(reps.weight.formatted(.number.precision(.fractionLength(1)))) Kg")
            }
            .padding()
            .background(Color(.systemGray5))
            .cornerRadius(10)
        }
    }
}
