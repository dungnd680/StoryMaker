//
//  BrightnessView.swift
//  StoryMaker
//
//  Created by devmacmini on 10/7/25.
//


import SwiftUI

struct BrightnessView: View {
    
    @Binding var lightness: Double
    @Binding var saturation: Double
    @Binding var blur: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Lightness")
                .font(.caption)
            HStack {
                Slider(value: $lightness, in: -100...100, step: 1)
                    .tint(.customRed)
                Text(String(format: "%.0f", lightness))
                    .frame(width: 32)
            }
            .font(.subheadline)

            Text("Saturation")
                .font(.caption)
            HStack {
                Slider(value: $saturation, in: -100...100, step: 1)
                    .tint(.customRed)
                Text(String(format: "%.0f", saturation))
                    .frame(width: 32)
            }
            .font(.subheadline)

            Text("Blur")
                .font(.caption)
            HStack {
                Slider(value: $blur, in: 0...100, step: 1)
                    .tint(.customRed)
                Text(String(format: "%.0f", blur))
                    .frame(width: 32)
            }
            .font(.subheadline)
        }
        .padding(.leading, 26)
        .padding(.trailing)
        .padding(.bottom)
        .frame(height: 200)
    }
}
