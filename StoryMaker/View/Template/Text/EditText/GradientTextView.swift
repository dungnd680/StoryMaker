//
//  GradientText.swift
//  StoryMaker
//
//  Created by devmacmini on 14/7/25.
//

import SwiftUI

struct GradientTextView: View {
    
    @State private var previousGradient: GradientColor? = nil
    
    @ObservedObject var textBoxViewModel: TextBoxViewModel
    
    @Binding var colorText: TextFill
    @Binding var triggerScroll: Bool
    @Binding var showSubscription: Bool

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(Colors.gradientColors, id: \.colors) { item in
                        Circle()
                            .fill(item.linearGradient)
                            .frame(width: 55, height: 55)
                            .id(item.colors)
                            .overlay {
                                ZStack {
                                    if case .gradient(let selected) = colorText, selected.colors == item.colors {
                                        Circle()
                                            .stroke(Color.red, lineWidth: 2)
                                        Image("Selected Color")
                                    }
                                    
                                    if item.isPremium {
                                        VStack {
                                            HStack {
                                                Spacer()
                                                Image("Premium")
                                            }
                                            Spacer()
                                        }
                                    }
                                }
                            }
                            .onTapGesture {
                                if case .gradient(let selected) = colorText {
                                    previousGradient = selected
                                }
                                if item.isPremium {
                                    showSubscription = true
                                }
                                
                                colorText = .gradient(item)
                                
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    proxy.scrollTo(item.colors, anchor: .center)
                                }
                            }
                    }
                }
                .padding(.horizontal, 26)
                .padding(.bottom, 48)
                .frame(height: 110)
            }
            .onAppear {
                if case .gradient(let selected) = colorText {
                    proxy.scrollTo(selected.colors, anchor: .center)
                }
            }
            .onChange(of: triggerScroll) {
                if case .gradient(let selected) = colorText {
                    proxy.scrollTo(selected.colors, anchor: .center)
                }
            }
            .onChange(of: textBoxViewModel.activeTextBox.id) {
                if case .gradient(let selected) = colorText {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        proxy.scrollTo(selected.colors, anchor: .center)
                    }
                }
            }
        }
        .onChange(of: showSubscription) {
            if !showSubscription {
                if let prev = previousGradient {
                    colorText = .gradient(prev)
                }
            }
        }
    }
}

#Preview {
    GradientTextView(
        textBoxViewModel: TextBoxViewModel(),
        colorText: .constant(.gradient(Colors.gradientColors.first!)),
        triggerScroll: .constant(false),
        showSubscription: .constant(false)
    )
}
