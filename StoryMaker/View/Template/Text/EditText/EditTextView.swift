//
//  EditTextView.swift
//  StoryMaker
//
//  Created by devmacmini on 8/7/25.
//

import SwiftUI

enum EditTextTab: String, CaseIterable, Equatable, Hashable {
    case size, font, color, gradient, align, shadow, background
}

struct EditTextView: View {
    
    @StateObject var fontViewModel = FontPickerViewModel()
    
    @ObservedObject var textBoxViewModel: TextBoxViewModel
    @ObservedObject var textBoxModel: TextBoxModel
    
    @Binding var isVisible: Bool
    @Binding var isEditing: Bool
    @Binding var selectedTab: EditTextTab
    @Binding var showSubscription: Bool
    @Binding var showToolText: Bool
    @Binding var triggerScroll: Bool
    
    var isTextFieldFocused: FocusState<Bool>.Binding
    var tabHeight: [EditTextTab : CGFloat] = [
        .size: 300, .font: 430, .color: 260, .gradient: 260,
        .align: 240, .shadow: 450, .background: 380
    ]
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 0) {
                ZStack {
                    Text(selectedTab.displayName)
                        .font(.headline)
                        .foregroundStyle(.customDarkGray)
                    
                    HStack {
                        Image("Keyboard")
                            .onTapGesture {
                                isTextFieldFocused.wrappedValue = true
                                isEditing = true
                                isVisible = false
                            }
                        
                        Spacer()
                        
                        Image("Done")
                            .onTapGesture {
                                isVisible = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    triggerScroll.toggle()
                                }
                                showToolText = true
                            }
                    }
                    .padding(.horizontal)
                }
                .frame(height: 50)
                
                HStack(spacing: 24) {
                    ForEach([EditTextTab.size, .font, .color, .gradient, .align, .shadow, .background], id: \.self) { tab in
                        Button {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedTab = tab
                                isVisible = true
                                showToolText = false
                            }
                        } label: {
                            Image(imageName(for: tab))
                                .foregroundStyle(selectedTab == tab ? .customRed : .customDarkGray)
                        }
                    }
                }
                .padding(.horizontal)
                .frame(height: 30)
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 30))
                
                if selectedTab == .color || selectedTab == .gradient {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Opacity")
                            .font(.caption)
                            .padding(.horizontal, 26)
                        
                        HStack {
                            Slider(value: $textBoxViewModel.activeTextBox.opacityText, in: 0...100,step: 1)
                                .tint(.customRed)
                            
                            Text(String(format: "%.0f", textBoxViewModel.activeTextBox.opacityText))
                                .font(.subheadline)
                                .frame(width: 29)
                        }
                        .padding(.leading, 26)
                        .padding(.trailing)
                    }
                    .frame(height: 80)
                }
                
                switch selectedTab {
                case .size:
                    SizeTextView(
                        sizeText: $textBoxViewModel.activeTextBox.sizeText,
                        lineHeight: $textBoxViewModel.activeTextBox.lineHeight,
                        letterSpacing: $textBoxViewModel.activeTextBox.letterSpacing
                    )
                    
                case .font:
                    FontPickerView(
                        viewModel: fontViewModel,
                        textBoxViewModel: textBoxViewModel,
                        selectedFont: $textBoxViewModel.activeTextBox.fontFamily,
                        showSubscription: $showSubscription
                    )
                    
                case .color:
                    ColorTextView(
                        textBoxViewModel: textBoxViewModel,
                        colorText: $textBoxViewModel.activeTextBox.colorText,
                        triggerScroll: $triggerScroll
                    )
                    
                case .gradient:
                    GradientTextView(
                        textBoxViewModel: textBoxViewModel,
                        colorText: $textBoxViewModel.activeTextBox.colorText,
                        triggerScroll: $triggerScroll,
                        showSubscription: $showSubscription
                    )
                    
                case .align:
                    AlignTextView(
                        textBoxModel: textBoxModel,
                        textBoxViewModel: textBoxViewModel
                    )
                    
                case .shadow:
                    ShadowTextView(
                        textBoxViewModel: textBoxViewModel,
                        colorShadowText: $textBoxViewModel.activeTextBox.colorShadowText,
                        opacityShadowText: $textBoxViewModel.activeTextBox.opacityShadowText,
                        blurShadowText: $textBoxViewModel.activeTextBox.blurShadowText,
                        xShadowText: $textBoxViewModel.activeTextBox.xShadowText,
                        yShadowText: $textBoxViewModel.activeTextBox.yShadowText,
                        triggerScroll: $triggerScroll)
                    
                case .background:
                    BackgroundTextView(
                        textBoxViewModel: textBoxViewModel,
                        colorBackgroundText: $textBoxViewModel.activeTextBox.colorBackgroundText,
                        paddingBackgroundText: $textBoxViewModel.activeTextBox.paddingBackgroundText,
                        cornerBackgroundText: $textBoxViewModel.activeTextBox.cornerBackgroundText,
                        opacityBackgroundText: $textBoxViewModel.activeTextBox.opacityBackgroundText,
                        triggerScroll: $triggerScroll
                    )
                }
            }
            .background(Color.white)
        }
        .offset(y:(isVisible ? 0 : tabHeight[selectedTab] ?? 0))
        .animation(.easeInOut(duration: 0.2), value: isVisible)
        .ignoresSafeArea()
    }
    
    private func imageName(for tab: EditTextTab) -> String {
        switch tab {
        case .size: return "Size Text"
        case .font: return "Font Text"
        case .color: return "Color Text"
        case .gradient: return "Gradient Text"
        case .align: return "Align Text"
        case .shadow: return "Shadow Text"
        case .background: return "Background Text"
        }
    }
}

extension EditTextTab {
    var displayName: String {
        switch self {
        case .size: return "Size"
        case .font: return "Font"
        case .color: return "Color"
        case .gradient: return "Gradient"
        case .align: return "Align"
        case .shadow: return "Shadow"
        case .background: return "Background"
        }
    }
}

#Preview {
    struct InlinePreview: View {
        @FocusState private var isTextFieldFocused: Bool
        
        var body: some View {
            EditTextView(
                textBoxViewModel: TextBoxViewModel(),
                textBoxModel: TextBoxModel(),
                isVisible: .constant(true),
                isEditing: .constant(true),
                selectedTab: .constant(.background),
                showSubscription: .constant(false),
                showToolText: .constant(true),
                triggerScroll: .constant(false),
                isTextFieldFocused: $isTextFieldFocused
            )
        }
    }

    return InlinePreview()
}
