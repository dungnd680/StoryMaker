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
    @State private var currentOffset: CGPoint = .zero
    @State private var initialDragTranslation: CGSize = .zero
    @State private var internalSize: CGSize = .zero
    
    @ObservedObject var textBox: TextBox
    @ObservedObject var editorVM: EditorVM
    
    var isTextFieldFocused: FocusState<Bool>.Binding
    
    var body: some View {
        ZStack {
            Group {
                if textBox.content.isEmpty && !isExporting {
                    Text("Double Tap To Edit")
                }
                
                if !textBox.content.isEmpty || isExporting {
                    Text(textBox.formatText)
                }
                
                Text(textBox.formatText)
                    .hidden()
            }
            .padding(48)
            .padding(textBox.paddingBackgroundText)
            .font(.custom(textBox.fontFamily, size: textBox.sizeText))
            .lineSpacing(textBox.lineHeight)
            .tracking(textBox.letterSpacing)
            .foregroundStyle(textBox.shapeStyle)
            .opacity(textBox.opacityText / 100)
            .multilineTextAlignment(textBox.textAlignment)
            .shadow(
                color: Color(textBox.colorShadowText).opacity(textBox.opacityShadowText / 100),
                radius: textBox.blurShadowText,
                x: textBox.xShadowText,
                y: textBox.yShadowText
            )
            .background(Color(textBox.colorBackgroundText).opacity(textBox.opacityBackgroundText / 100))
            .clipShape(RoundedRectangle(cornerRadius: textBox.cornerBackgroundText))
            .background(
                GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            internalSize = geo.size
                            textBox.textBoxSize = geo.size
                            if textBox.id == textBoxViewModel.activeTextBox.id {
                                textBoxViewModel.activeBoxSize = internalSize
                            }
                        }
                        .onChange(of: geo.size) {
                            internalSize = geo.size
                            textBox.textBoxSize = geo.size
                            if textBox.id == textBoxViewModel.activeTextBox.id {
                                textBoxViewModel.activeBoxSize = internalSize
                            }
                        }
                        .onChange(of: textBoxViewModel.activeTextBox.id) {
                            textBox.textBoxSize = geo.size
                            if textBox.id == textBoxViewModel.activeTextBox.id {
                                textBoxViewModel.activeBoxSize = internalSize
                            }
                        }
                }
            )
            
            if editorVM.isEditing && textBox.id == textBoxViewModel.activeTextBox.id {
                TextField("", text: $textBoxViewModel.activeTextBox.content, axis: .vertical)
                    .font(.custom(textBox.fontFamily, size: textBox.sizeText))
                    .lineSpacing(textBox.lineHeight)
                    .tracking(textBox.letterSpacing)
                    .foregroundStyle(textBox.shapeStyle)
                    .opacity(textBox.opacityText / 100)
                    .multilineTextAlignment(textBox.textAlignment)
                    .shadow(
                        color: Color(textBox.colorShadowText).opacity(textBox.opacityShadowText / 100),
                        radius: textBox.blurShadowText,
                        x: textBox.xShadowText,
                        y: textBox.yShadowText
                    )
                    .background(Color(textBox.colorBackgroundText).opacity(textBox.opacityBackgroundText / 100))
                    .clipShape(RoundedRectangle(cornerRadius: textBox.cornerBackgroundText))
                    .frame(width: textBox.textBoxSize.width, height: textBox.textBoxSize.height)
                    .submitLabel(.return)
                    .focused(isTextFieldFocused)
                    .toolbar {
                        ToolbarItem(placement: .keyboard) {
                            ZStack {
                                Text("Text Edit")
                                    .font(.headline)
                                    .foregroundStyle(.customDarkGray)
                                
                                HStack {
                                    HStack {
                                        Image("Tool Edit Text")
                                        Text("Edit")
                                            .font(.subheadline)
                                            .foregroundStyle(.customDarkGray)
                                    }
                                    .onTapGesture {
                                        if !textBoxViewModel.activeTextBox.content.isEmpty {
                                            isTextFieldFocused.wrappedValue = false
                                            editorVM.showEditText = true
                                            editorVM.isEditing = false
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    Image("Done")
                                        .onTapGesture {
                                            isTextFieldFocused.wrappedValue = false
                                            editorVM.isEditing = false
                                            if !textBoxViewModel.activeTextBox.content.isEmpty {
                                                editorVM.showToolText = true
                                            }
                                        }
                                }
                            }
                        }
                    }
            }
        }
        .rotationEffect(textBox.rotation)
        .scaleEffect(textBox.scale)
        .offset(x: textBox.x, y: textBox.y)
        .gesture(
            TapGesture()
                .onEnded {
                    let now = Date()
                    if now.timeIntervalSince(lastTapDate) < 0.3 {
                        tapWorkItem?.cancel()
                        tapWorkItem = nil
                        editorVM.isEditing = true
                        textBoxViewModel.activeTextBox = textBox
                        textBoxViewModel.borderTextBoxOffset = CGPoint(x: textBox.x, y: textBox.y)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                            isTextFieldFocused.wrappedValue = true
                        }
                        editorVM.showEditText = false
                        editorVM.showToolText = false
                        editorVM.showAdjustBackground = false
                    } else {
                        let workItem = DispatchWorkItem {
                            textBoxViewModel.activeTextBox = textBox
                            textBoxViewModel.borderTextBoxOffset = CGPoint(x: textBox.x, y: textBox.y)
                            isTextFieldFocused.wrappedValue = false
                            editorVM.isEditing = false
                            editorVM.showToolText = !textBox.content.isEmpty

                            if textBox.content.isEmpty {
                                editorVM.showEditText = false
                            }

                            if editorVM.showAdjustBackground {
                                editorVM.showAdjustBackground = false
                                if !textBox.content.isEmpty {
                                    editorVM.showEditText = true
                                }
                            }
                        }

                        tapWorkItem = workItem
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: workItem)
                    }

                    lastTapDate = now
                }
        )
        .highPriorityGesture(
            DragGesture()
                .onChanged { value in
                    let isDraggingAllowed = textBoxViewModel.activeTextBox.id.isEmpty // chưa text box nào active
                                            || textBoxViewModel.activeTextBox.id == textBox.id // text box hiện tại đang active

                    guard isDraggingAllowed else { return }

                    if initialDragTranslation == .zero {
                        initialDragTranslation = value.translation
                        currentOffset = CGPoint(x: textBox.x, y: textBox.y)
                    }

                    let translation: CGSize = CGSize(
                        width: value.translation.width - initialDragTranslation.width,
                        height: value.translation.height - initialDragTranslation.height
                    )

                    textBox.x = currentOffset.x + translation.width
                    textBox.y = currentOffset.y + translation.height
                    textBoxViewModel.borderTextBoxOffset = CGPoint(x: textBox.x, y: textBox.y)
                }
                .onEnded { _ in
                    currentOffset = .zero
                    initialDragTranslation = .zero
                }
        )
    }
}

//#Preview {
//    TextBoxView()
//}
