//
//  AddWorkout.swift
//  Gym Buddy
//
//  Created by Stefan Miloiu on 28.04.2024.
//

import SwiftUI

struct AddRepsAndWeightButton: View {
    
    var color: Color
    
    var body: some View {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
//                .frame(height: 30)
                .foregroundStyle(color)
    }
}

#Preview {
    AddRepsAndWeightButton(color: Color.gray)
}
