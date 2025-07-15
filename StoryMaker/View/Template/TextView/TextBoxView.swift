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
    
    @State private var lastTapDate: Date = .distantPast
    @State private var tapWorkItem: DispatchWorkItem?
    
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
                    .tracking(box.letterSpacing)
            } else {
                ZStack {
                    if box.content.isEmpty {
                        Text("Double Tap To Edit")
                            .tracking(box.letterSpacing)
                    }
                    
                    if box.id == textBoxViewModel.activeTextBox.id && isEditing {
                        TextField("", text: $textBoxViewModel.activeTextBox.content, axis: .vertical)
                            .submitLabel(.return)
                            .focused(isTextFieldFocused)
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
                                                    if !textBoxViewModel.activeTextBox.content.isEmpty {
                                                        showToolTextView = true
                                                    }
                                                }
                                        }
                                    }
                                }
                            }
                    } else {
                        Text(box.content)
                            .tracking(box.letterSpacing)
                    }
                }
            }
        }
        .font(.custom(box.fontFamily, size: box.sizeText))
        .lineSpacing(box.lineHeight)
        .foregroundStyle(box.shapeStyle)
        .opacity(box.opacity / 100)
        .multilineTextAlignment(.center)
        .offset(x: box.x + dragOffset.width, y: box.y + dragOffset.height)
        .gesture(
            TapGesture()
                .onEnded {
                    let now = Date()
                    if now.timeIntervalSince(lastTapDate) < 0.3 {
                        tapWorkItem?.cancel()
                        tapWorkItem = nil

                        isEditing = true
                        textBoxViewModel.activeTextBox = box
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                            isTextFieldFocused.wrappedValue = true
                        }
                        showAdjustBackgroundView = false
                        
                        print("2 tap: \(box.id)")
                    } else {
                        let workItem = DispatchWorkItem {
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

                            print("1 tap: \(box.id)")
                        }

                        tapWorkItem = workItem
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: workItem)
                    }

                    lastTapDate = now
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
