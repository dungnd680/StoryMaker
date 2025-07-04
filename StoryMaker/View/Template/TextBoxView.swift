//
//  EditTextView.swift
//  StoryMaker
//
//  Created by devmacmini on 19/6/25.
//

import SwiftUI

struct TextBoxView: View {
    @Binding var box: TextBoxModel
    @Binding var text: String
    @Binding var showToolTextView: Bool
    @Binding var isSelected: Bool
    @Binding var isEditing: Bool
    
    @Environment(\.isExporting) private var isExporting
    
    @GestureState private var dragOffset: CGSize = .zero
    
    @FocusState private var isTextFieldFocused: Bool
    
    var onSelect: () -> Void
    
    var body: some View {
        Group {
            if isExporting || (!isEditing && !box.text.isEmpty) {
                Text(text)
                    .padding()
            } else {
                ZStack {
                    if box.text.isEmpty {
                        Text("Double Tap To Edit")
                            .padding()
                    }
                    
                    if isEditing {
                        TextField("", text: $box.text)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(Color.clear)
                            .focused($isTextFieldFocused)
                            .onSubmit {
                                isTextFieldFocused = false
                                text = box.text
                                isEditing = false
                            }
                    }
                }
            }
        }
        .highPriorityGesture(
            TapGesture(count: 2)
                .onEnded {
                    onSelect()
                    isEditing = true
                    isTextFieldFocused = true
                    isSelected = true
                }
        )
        .onTapGesture {
            if !box.text.isEmpty {
                isSelected = true
                onSelect()
            }
        }
        .foregroundColor(.white)
        .multilineTextAlignment(.center)
        .overlay((isSelected && !isExporting) ? RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 6) : nil)
        .overlay((isSelected && !isExporting) ? RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 3) : nil)
        .fixedSize()
        .font(.system(size: 100))
        .position(x: box.position.x + dragOffset.width,
                  y: box.position.y + dragOffset.height)
        .gesture(
            DragGesture()
                .updating($dragOffset) { value, state, _ in
                    state = value.translation
                }
                .onEnded { value in
                    box.position.x += value.translation.width
                    box.position.y += value.translation.height
                }
        )
    }
}

//#Preview {
//    TextBoxView()
//}
