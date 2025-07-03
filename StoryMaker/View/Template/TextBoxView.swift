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
    @Environment(\.isExporting) private var isExporting
    @GestureState private var dragOffset: CGSize = .zero
    @State private var isEditing: Bool = false
    @FocusState private var isTextFieldFocused: Bool
    @State private var showToolView: Bool = false
    
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
                        if box.text.isEmpty {
                            Text("Double Tap To Edit")
                                .padding()
                        }
                        
                        TextField("", text: $box.text)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(Color.clear)
                            .focused($isTextFieldFocused)
                            .onSubmit {
                                isEditing = false
                                isTextFieldFocused = false
                                text = box.text
                            }
                    }
                }
            }
        }
        .onTapGesture(count: 2) {
            isEditing = true
            isTextFieldFocused = true
        }
        .onTapGesture {
            showToolView = true
        }
        .foregroundColor(.white)
        .multilineTextAlignment(.center)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 6))
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 3))
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
