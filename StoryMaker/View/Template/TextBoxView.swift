//
//  EditTextView.swift
//  StoryMaker
//
//  Created by devmacmini on 19/6/25.
//

import SwiftUI

struct TextBoxView: View {
    
    @Environment(\.isExporting) private var isExporting
    
    @FocusState private var isTextFieldFocused: Bool
    
    @GestureState private var dragOffset: CGSize = .zero
    
    @ObservedObject var box: TextBoxModel
    @ObservedObject var textBoxViewModel: TextBoxViewModel
    
    @Binding var showToolTextView: Bool
    @Binding var isEditing: Bool
    
    var body: some View {
        Group {
            if isExporting || (!isEditing && !box.content.isEmpty) {
                Text(box.content)
            } else {
                ZStack {
                    if box.content.isEmpty {
                        Text("Double Tap To Edit")
                    }
                    
                    if box.id == textBoxViewModel.activeTextBox.id && isEditing {
                        TextField("", text: $textBoxViewModel.activeTextBox.content, axis: .vertical)
                            .submitLabel(.return)
                            .focused($isTextFieldFocused)
                    } else {
                        Text(box.content)
                    }
                }
            }
        }
        .onTapGesture(count: 2) {
            isEditing = true
            isTextFieldFocused = true
            textBoxViewModel.activeTextBox = box
        }
        .onTapGesture {
            if !box.content.isEmpty {
                showToolTextView = true
            }
        }
        .font(.system(size: box.size))
        .foregroundStyle(.white)
        .multilineTextAlignment(.center)
        .offset(x: box.x + dragOffset.width, y: box.y + dragOffset.height)
        .gesture(
            DragGesture()
                .updating($dragOffset) { value, state, _ in
                    state = value.translation
                }
                .onEnded { value in
                    if let index = textBoxViewModel.textBoxes.firstIndex(where: { $0.id == box.id }) {
                        textBoxViewModel.textBoxes[index].x += value.translation.width
                        textBoxViewModel.textBoxes[index].y += value.translation.height
                    }
                }
        )
    }
}

//#Preview {
//    TextBoxView()
//}
