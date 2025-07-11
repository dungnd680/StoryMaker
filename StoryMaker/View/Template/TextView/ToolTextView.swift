//
//  AdjustTextView.swift
//  StoryMaker
//
//  Created by devmacmini on 3/7/25.
//

import SwiftUI

let toolsText: [(image: String, title: String)] = [
    ("Size Text", "Size"),
    ("Font Text", "Font"),
    ("Color Text", "Color"),
    ("Gradient Text", "Gradient"),
    ("Align Text", "Align"),
    ("Shadow Text", "Shadow"),
    ("Background Text", "Background")
]

struct ToolTextView: View {
    
    @Binding var isVisible: Bool
    @Binding var selectedTab: EditTextTab
    @Binding var showEditTextView: Bool
    
    var toolTextHeight: CGFloat = 80

    var body: some View {
        VStack {
            Spacer()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 40) {
                    ForEach(toolsText, id: \.title) { tool in
                        VStack {
                            Button {
                                switch tool.title {
                                case "Size": showEditorText(for: .size)
                                case "Font": showEditorText(for: .font)
                                case "Color": showEditorText(for: .color)
                                case "Gradient": showEditorText(for: .gradient)
                                case "Align": showEditorText(for: .align)
                                case "Shadow": showEditorText(for: .shadow)
                                case "Background": showEditorText(for: .background)
                                default: break
                                }
                            } label: {
                                VStack {
                                    Image(tool.image)
                                        .foregroundStyle(.colorDarkGray)
                                    
                                    Text(tool.title)
                                        .font(.caption)
                                        .foregroundStyle(Color.black)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 22)
            }
            .frame(height: toolTextHeight)
            .background(Color.white)
        }
        .offset(y: isVisible ? 0 : toolTextHeight)
        .animation(.easeInOut(duration: 0.2), value: isVisible)
        .ignoresSafeArea()
    }
    
    private func showEditorText(for tab: EditTextTab) {
        selectedTab = tab
        showEditTextView = true
    }
}

//#Preview {
//    ToolTextView(isVisible: .constant(true), selectedTab: .constant(.size))
//}
