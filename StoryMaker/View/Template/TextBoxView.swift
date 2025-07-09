//
//  EditTextView.swift
//  StoryMaker
//
//  Created by devmacmini on 19/6/25.
//

import SwiftUI

struct TextBoxView: View {
    
    @Environment(\.isExporting) private var isExporting
    
    @GestureState private var dragOffset: CGSize = .zero
    
    @ObservedObject var box: TextBoxModel
    @ObservedObject var textBoxViewModel: TextBoxViewModel
    
    @Binding var showToolTextView: Bool
    @Binding var isEditing: Bool
    @Binding var showEditTextView: Bool
    @Binding var showAdjustBackgroundView: Bool
    
    var isTextFieldFocused: FocusState<Bool>.Binding
    
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
                            .focused(isTextFieldFocused)
                            .toolbar {
                                ToolbarItem(placement: .keyboard) {
                                    ZStack {
                                        Text("Text Edit")
                                            .font(.headline)
                                            .foregroundStyle(.colorDarkGray)
                                        
                                        HStack {
                                            HStack {
                                                Image("Tool Edit Text")
                                                Text("Edit")
                                                    .font(.subheadline)
                                                    .foregroundStyle(.colorDarkGray)
                                            }
                                            .onTapGesture {
                                                isTextFieldFocused.wrappedValue = false
                                                showEditTextView = true
                                                isEditing = false
                                            }
                                            
                                            Spacer()
                                            
                                            Image("Done")
                                                .onTapGesture {
                                                    isTextFieldFocused.wrappedValue = false
                                                    isEditing = false
                                                }
                                        }
                                    }
                                }
                            }
                    } else {
                        Text(box.content)
                    }
                }
            }
        }
        .font(.system(size: box.size))
        .foregroundStyle(.white)
        .multilineTextAlignment(.center)
        .offset(x: box.x + dragOffset.width, y: box.y + dragOffset.height)
        .highPriorityGesture(
            TapGesture(count: 2)
                .onEnded {
                    isEditing = true
                    textBoxViewModel.activeTextBox = box
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        isTextFieldFocused.wrappedValue = true
                    }
                    showEditTextView = false
                    showToolTextView = false
                    showAdjustBackgroundView = false
                    print("Tapped box ID: \(box.id)")
                }
        )
        .gesture(
            TapGesture(count: 1)
                .onEnded {
                    textBoxViewModel.activeTextBox = box
                    isTextFieldFocused.wrappedValue = false
                    isEditing = false
                    if !textBoxViewModel.activeTextBox.content.isEmpty || !showEditTextView {
                        if showAdjustBackgroundView {
                            showEditTextView = true
                        } else {
                            showToolTextView = true
                        }
                        showAdjustBackgroundView = false
                    }
                    print("Tapped box ID: \(box.id)")
                }
        )
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
