//
//  EditTextView.swift
//  StoryMaker
//
//  Created by devmacmini on 8/7/25.
//

import SwiftUI

enum EditTextTab {
    case size, font, color, gradient, stroke, align, shadow, background
}

struct EditTextView: View {
    
    @State private var selectedTab: EditTextTab = .size
    
    @Binding var isVisible: Bool
    @Binding var showEditTextView: Bool
    @Binding var isEditing: Bool
    
    var isTextFieldFocused: FocusState<Bool>.Binding
    var onClose: () -> Void
    
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
                                showEditTextView = false
                            }
                        
                        Spacer()
                        
                        Image("Done")
                            .onTapGesture {
                                onClose()
                            }
                    }
                    .padding(.horizontal)
                }
                .frame(height: 50)
                
                HStack(spacing: 24) {
                    ForEach([EditTextTab.size, .font, .color, .gradient, .stroke, .align, .background, .shadow], id: \.self) { tab in
                        withAnimation(.easeInOut(duration: 0.2)) {
                            Button {
                                selectedTab = tab
                            } label: {
                                Image(imageName(for: tab))
                                    .foregroundStyle(selectedTab == tab ? .backgroundColor2 : .colorDarkGray)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .frame(height: 30)
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 30))
                
                Text(selectedTab.displayName)
                    .frame(height: 150)
            }
            .background(Color.white)
        }
        .offset(y:(isVisible ? 0 : 230))
        .animation(.easeInOut(duration: 0.2), value: isVisible)
        .ignoresSafeArea()
    }
    
    private func imageName(for tab: EditTextTab) -> String {
        switch tab {
        case .size: return "Size Text"
        case .font: return "Font Text"
        case .color: return "Color Text"
        case .gradient: return "Gradient Text"
        case .stroke: return "Stroke Text"
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
        case .stroke: return "Stroke"
        case .align: return "Align"
        case .shadow: return "Shadow"
        case .background: return "Background"
        }
    }
}

//#Preview {
//    EditTextView(onClose: {})
//}
