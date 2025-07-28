//
//  SlidersView.swift
//  StoryMaker
//
//  Created by devmacmini on 16/7/25.
//


import SwiftUI

struct SlidersView: View {
    
    @State private var animatedValue: CGFloat = 0
    
    @Binding var value: CGFloat
    
    var label: String
    var range: ClosedRange<CGFloat>
    var step: CGFloat = 1

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(label)
                .font(.caption)
            HStack {
                Slider(value: $animatedValue, in: range, step: step)
                    .tint(.customRed)
                Text(String(format: "%.0f", value))
                    .frame(width: 29)
            }
            .font(.subheadline)
        }
        .onAppear {
            animatedValue = value
        }
        .onChange(of: value) {
            withAnimation(.easeInOut(duration: 0.2)) {
                animatedValue = value
            }
        }
        .onChange(of: animatedValue) {
            if abs(animatedValue - value) > 0.5 {
                value = animatedValue
            }
        }
    }
}
