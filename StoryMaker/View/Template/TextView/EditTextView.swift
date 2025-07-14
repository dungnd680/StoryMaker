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

enum ColorType {
    case solid
    case gradient
}

struct EditTextView: View {
    
    @State private var activeColorType: ColorType = .solid
    
    @StateObject var fontViewModel = FontPickerViewModel()
    
    @ObservedObject var textBoxViewModel: TextBoxViewModel
    
    @Binding var isVisible: Bool
    @Binding var showEditText: Bool
    @Binding var isEditing: Bool
    @Binding var selectedTab: EditTextTab
    @Binding var showSubscription: Bool
    @Binding var showToolText: Bool
    
    var isTextFieldFocused: FocusState<Bool>.Binding
    var onClose: () -> Void
    var tabHeight: [EditTextTab : CGFloat] = [
        .size: 280, .font: 430, .color: 230, .gradient: 230,
        .align: 200, .shadow: 200, .background: 200
    ]
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 0) {
                ZStack {
                    Text(selectedTab.displayName)
                        .font(.headline)
                        .foregroundStyle(.colorDarkGray)
                    
                    HStack {
                        Image("Keyboard")
                            .onTapGesture {
                                isTextFieldFocused.wrappedValue = true
                                isEditing = true
                                showEditText = false
                            }
                        
                        Spacer()
                        
                        Image("Done")
                            .onTapGesture {
                                onClose()
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
                            }
                        } label: {
                            Image(imageName(for: tab))
                                .foregroundStyle(selectedTab == tab ? .backgroundColor2 : .colorDarkGray)
                        }
                    }
                }
                .padding(.horizontal)
                .frame(height: 30)
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 30))
                
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
                        colorText: $textBoxViewModel.activeTextBox.colorText,
                        activeColorType: $activeColorType
                    )
                case .gradient:
                    GradientTextView(
                        gradient: $textBoxViewModel.activeTextBox.gradientText,
                        showSubscription: $showSubscription,
                        activeColorType: $activeColorType
                    )
                case .align:
                    Text("Align View")
                        .frame(height: 120)
                case .shadow:
                    Text("Shadow View")
                        .frame(height: 120)
                case .background:
                    Text("Background View")
                        .frame(height: 120)
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

//#Preview {
//    EditTextView(
//        isVisible: .constant(true),
//        showEditTextView: .constant(true),
//        isEditing: .constant(true),
//        isTextFieldFocused: FocusState<Bool>().projectedValue,
//        onClose: {}
//    )
//}
