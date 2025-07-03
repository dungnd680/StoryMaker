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

    var body: some View {
        VStack {
            Spacer()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 32) {
                    ForEach(toolsText, id: \.title) { tool in
                        VStack {
                            Button {
                                
                            } label: {
                                Image(tool.image)
                            }
                            
                            Text(tool.title)
                                .font(.caption)
                        }
                    }
                }
            }
            .padding(.horizontal, 32)
        }
        .offset(y: isVisible ? 0 : 100)
        .animation(.easeInOut(duration: 0.2), value: isVisible)
    }
}

#Preview {
    ToolTextView(isVisible: .constant(true))
}
