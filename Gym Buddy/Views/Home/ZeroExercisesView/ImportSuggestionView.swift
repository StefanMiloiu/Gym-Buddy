//
//  ImportSuggestionView.swift
//  Gym Buddy
//
//  Created by Stefan Miloiu on 03.05.2024.
//

import SwiftUI

struct ImportSuggestionView: View {
    
    @Binding var selectedTab: Int
    
    var body: some View {
        Text("See your old training plans and import them today.")
            .frame(width: 300, height: 50)
            .multilineTextAlignment(.center)
        Button {
            selectedTab = 2
        } label: {
            Text("See history")
                .frame(width: 200, height: 50)
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding(.top, -5)
    }
}

#Preview {
    ImportSuggestionView(selectedTab: .constant(0))
}

