//
//  GradientText.swift
//  StoryMaker
//
//  Created by devmacmini on 14/7/25.
//

import SwiftUI

struct GradientTextView: View {
    
    @State private var previousGradient: GradientColor? = nil
    
    @Binding var gradient: GradientColor?
    @Binding var showSubscription: Bool
    @Binding var activeColorType: ColorType

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(Colors.gradientColors, id: \.colors) { item in
                    Circle()
                        .fill(item.linearGradient)
                        .frame(width: 55, height: 55)
                        .overlay(
                            Circle()
                                .stroke(
                                    gradient?.colors == item.colors && activeColorType == .gradient ? Color.red : .clear,
                                    lineWidth: 2
                                )
                        )
                        .overlay(
                            gradient?.colors == item.colors && activeColorType == .gradient ? Image("Selected Color") : nil
                        )
                        .overlay(
                            item.isPremium ? Image("Premium") : nil,
                            alignment: .topTrailing
                        )
                        .onTapGesture {
                            previousGradient = gradient
                            if item.isPremium {
                                showSubscription = true
                            }
                            gradient = item
                            activeColorType = .gradient
                        }
                }
            }
            .padding(.horizontal, 26)
            .padding(.bottom, 20)
            .padding(.top, 1)
        }
        .frame(height: 150)
        .onChange(of: showSubscription) {
            if !showSubscription {
                gradient = previousGradient
//                viewModel.selectedFont = CFont.fonts.first { $0.iosFamily == previousFont } ?? CFont.fonts[0]
            }
        }
    }
}

//#Preview {
//    GradientTextView(gradient: .constant(Colors.gradientColors[0]))
//}
