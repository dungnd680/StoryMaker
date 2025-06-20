//
//  EditTextView.swift
//  StoryMaker
//
//  Created by devmacmini on 19/6/25.
//

import SwiftUI

struct EditTextView: View {
    @Binding var text: EditableText
    var isSelected: Bool

    @GestureState private var dragOffset: CGSize = .zero

    var body: some View {
        TextEditor(text: $text.text)
            .font(.system(size: text.fontSize))
            .foregroundColor(text.color)
            .frame(width: 200, height: 80)
            .padding(5)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.6)))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
            .position(text.position)
            .gesture(
                DragGesture()
                    .updating($dragOffset) { value, state, _ in
                        state = value.translation
                    }
                    .onEnded { value in
                        text.position.x += value.translation.width
                        text.position.y += value.translation.height
                    }
            )
    }
}

//#Preview {
//    EditTextView()
//}
