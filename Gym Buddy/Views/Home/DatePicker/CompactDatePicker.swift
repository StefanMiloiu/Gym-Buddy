//
//  CompactDatePicker.swift
//  Gym Buddy
//
//  Created by Stefan Miloiu on 01.05.2024.
//

import Foundation
import SwiftUI


struct CompactDatePicker: View {
    var body: some View {
        Image(systemName: "calendar.badge.clock")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30)
            .foregroundColor(.accentColor)
    }
}

