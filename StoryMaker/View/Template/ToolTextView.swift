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
    ("Stroke Text", "Stroke"),
    ("Align Text", "Align"),
    ("Shadow Text", "Shadow"),
    ("Background Text", "Background")
]

struct ToolTextView: View {
    @Binding var isVisible: Bool
    
    var toolTextHeight: CGFloat = 80

    var body: some View {
        VStack {
            Spacer()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 32) {
                    ForEach(toolsText, id: \.title) { tool in
                        VStack {
                            Button {
                                
                            } label: {
                                VStack {
                                    Image(tool.image)
                                    
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
        .animation(.easeInOut(duration: 0.15), value: isVisible)
        .ignoresSafeArea()
    }
}

#Preview {
    ToolTextView(isVisible: .constant(true))
}
