//
//  SizeTextView.swift
//  StoryMaker
//
//  Created by devmacmini on 10/7/25.
//

import SwiftUI

struct SizeTextView: View {
    @Binding var sizeText: CGFloat
    @Binding var lineHeight: CGFloat
    @Binding var letterSpacing: CGFloat

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SlidersView(value: $sizeText, label: "Size", range: 30...500)
            SlidersView(value: $lineHeight, label: "Line Height", range: 0...100)
            SlidersView(value: $letterSpacing, label: "Letter Spacing", range: 0...100)
        }
        .padding(.leading, 26)
        .padding(.trailing)
        .padding(.bottom)
        .frame(height: 200)
    }
}

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
                    .tint(.backgroundColor2)
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
