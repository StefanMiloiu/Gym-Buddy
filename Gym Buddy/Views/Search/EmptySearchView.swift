//
//  EmptySearchView.swift
//  Gym Buddy
//
//  Created by Stefan Miloiu on 28.04.2024.
//

import SwiftUI

struct EmptySearchView: View {
    @State var degreesRotating = 0.0

    var body: some View {
        VStack{
            Spacer()
            Text("There is no exercise with that name")
                .font(.title)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            Spacer()
            RotatingImage(imageName: "exclamationmark.arrow.triangle.2.circlepath")
            Spacer()
        }//:VStack
    }
}

struct RotatingImage : View {
    @State var degreesRotating: Double = 0.0
    var imageName: String
    var body: some View {
        Image(systemName: imageName)
            .resizable()
            .scaledToFit()
            .foregroundColor(.gray)
            .frame(width: 80, height: 80)
            .rotationEffect(.degrees(degreesRotating))
            .onAppear {
                withAnimation(.linear(duration: 1)
                              .speed(0.1).repeatForever(autoreverses: false)) {
                                  degreesRotating = 360.0
                              }
                      }
    }
}

#Preview {
    EmptySearchView()
}
