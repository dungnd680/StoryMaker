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
                    .font(.system(size: box.sizeText))
                    .lineSpacing(box.lineHeight)
                    .tracking(box.letterSpacing)
            } else {
                ZStack {
                    if box.content.isEmpty {
                        Text("Double Tap To Edit")
                            .font(.system(size: box.sizeText))
                            .lineSpacing(box.lineHeight)
                            .tracking(box.letterSpacing)
                    }
                    
                    if box.id == textBoxViewModel.activeTextBox.id && isEditing {
                        TextField("", text: $textBoxViewModel.activeTextBox.content, axis: .vertical)
                            .submitLabel(.return)
                            .focused(isTextFieldFocused)
                            .font(.system(size: box.sizeText))
                            .lineSpacing(box.lineHeight)
                            .tracking(box.letterSpacing)
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
                                                if !textBoxViewModel.activeTextBox.content.isEmpty {
                                                    isTextFieldFocused.wrappedValue = false
                                                    showEditTextView = true
                                                    isEditing = false
                                                }
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
                            .font(.system(size: box.sizeText))
                            .lineSpacing(box.lineHeight)
                            .tracking(box.letterSpacing)
                    }
                }
            }
        }
        .foregroundStyle(.white)
        .multilineTextAlignment(.center)
        .offset(x: box.x + dragOffset.width, y: box.y + dragOffset.height)
        .gesture(
            TapGesture(count: 1)
                .onEnded {
                    textBoxViewModel.activeTextBox = box
                    isTextFieldFocused.wrappedValue = false
                    isEditing = false
                    showToolTextView = !box.content.isEmpty

                    if box.content.isEmpty {
                        showEditTextView = false
                    }

                    if showAdjustBackgroundView {
                        showAdjustBackgroundView = false
                        if !box.content.isEmpty {
                            showEditTextView = true
                        }
                    }

                    if showEditTextView {
                        showEditTextView = false
                        showEditTextView = true
                    }

                    print("Tapped box ID: \(box.id)")
                }
        )
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
            DragGesture(minimumDistance: 0)
                .updating($dragOffset) { value, state, _ in
                    if (textBoxViewModel.activeTextBox.id == box.id || textBoxViewModel.activeTextBox.isEmpty) && !isEditing {
                        state = value.translation
                    }
                }
                .onEnded { value in
                    if (textBoxViewModel.activeTextBox.id == box.id || textBoxViewModel.activeTextBox.isEmpty) && !isEditing {
                        if let index = textBoxViewModel.textBoxes.firstIndex(where: { $0.id == box.id }) {
                            textBoxViewModel.textBoxes[index].x += value.translation.width
                            textBoxViewModel.textBoxes[index].y += value.translation.height
                        }
                    }
                }
        )
    }
}

//#Preview {
//    TextBoxView()
//}
