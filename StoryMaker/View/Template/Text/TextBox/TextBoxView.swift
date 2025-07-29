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
    @State private var startDragPosition: CGPoint = .zero
    @State private var internalScaledSize: CGSize = .zero
    @State private var placeholderSize: CGSize = .zero
    
    @ObservedObject var textBoxModel: TextBoxModel
    @ObservedObject var textBoxViewModel: TextBoxViewModel
    
    @Binding var showToolText: Bool
    @Binding var isEditing: Bool
    @Binding var showEditText: Bool
    @Binding var showAdjustBackground: Bool
    
    var isTextFieldFocused: FocusState<Bool>.Binding
    
    var placeholder: some View {
        Text("Double Tap To Edit")
            .font(.custom(textBoxModel.fontFamily, size: textBoxModel.sizeText))
            .foregroundStyle(textBoxModel.shapeStyle)
            .multilineTextAlignment(textBoxModel.textAlignment)
            .lineSpacing(textBoxModel.lineHeight)
            .tracking(textBoxModel.letterSpacing)
            .opacity(textBoxModel.opacityText / 100)
            .padding(48)
            .padding(textBoxModel.paddingBackgroundText)
            .shadow(
                color: Color(textBoxModel.colorShadowText)
                    .opacity(textBoxModel.opacityShadowText / 100),
                radius: textBoxModel.blurShadowText,
                x: textBoxModel.xShadowText,
                y: textBoxModel.yShadowText
            )
            .background(
                Color(textBoxModel.colorBackgroundText)
                    .opacity(textBoxModel.opacityBackgroundText / 100)
            )
            .clipShape(RoundedRectangle(cornerRadius: textBoxModel.cornerBackgroundText))
            .background(
                GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            textBoxModel.textSize = geo.size
                            placeholderSize = geo.size
                        }
                        .onChange(of: geo.size) {
                            textBoxModel.textSize = geo.size
                            placeholderSize = geo.size
                        }
                }
            )
    }
    
    var displayText: some View {
        Text(textBoxModel.formatText)
            .font(.custom(textBoxModel.fontFamily, size: textBoxModel.sizeText))
            .foregroundStyle(textBoxModel.shapeStyle)
            .multilineTextAlignment(textBoxModel.textAlignment)
            .lineSpacing(textBoxModel.lineHeight)
            .tracking(textBoxModel.letterSpacing)
            .opacity(textBoxModel.opacityText / 100)
            .padding(48)
            .padding(textBoxModel.paddingBackgroundText)
            .shadow(
                color: Color(textBoxModel.colorShadowText)
                    .opacity(textBoxModel.opacityShadowText / 100),
                radius: textBoxModel.blurShadowText,
                x: textBoxModel.xShadowText,
                y: textBoxModel.yShadowText
            )
            .background(
                Color(textBoxModel.colorBackgroundText)
                    .opacity(textBoxModel.opacityBackgroundText / 100)
            )
            .clipShape(RoundedRectangle(cornerRadius: textBoxModel.cornerBackgroundText))
    }
    
    var editTextField: some View {
        TextField("", text: $textBoxViewModel.activeTextBox.content, axis: .vertical)
            .font(.custom(textBoxModel.fontFamily, size: textBoxModel.sizeText))
            .foregroundStyle(textBoxModel.shapeStyle)
            .multilineTextAlignment(textBoxModel.textAlignment)
            .lineSpacing(textBoxModel.lineHeight)
            .tracking(textBoxModel.letterSpacing)
            .opacity(textBoxModel.opacityText / 100)
            .padding(48)
            .padding(textBoxModel.paddingBackgroundText)
            .frame(width: textBoxModel.textSize.width, height: textBoxModel.textSize.height)
            .shadow(
                color: Color(textBoxModel.colorShadowText)
                    .opacity(textBoxModel.opacityShadowText / 100),
                radius: textBoxModel.blurShadowText,
                x: textBoxModel.xShadowText,
                y: textBoxModel.yShadowText
            )
            .background(
                Color(textBoxModel.colorBackgroundText)
                    .opacity(textBoxModel.opacityBackgroundText / 100)
            )
            .clipShape(RoundedRectangle(cornerRadius: textBoxModel.cornerBackgroundText))
    }
    
    var body: some View {
        Group {
            if isExporting
                || (!(textBoxModel.id == textBoxViewModel.activeTextBox.id && isEditing) && !textBoxModel.content.isEmpty) {
                displayText
            } else {
                ZStack {
                    if textBoxViewModel.textBoxes.contains(where: { $0.id == textBoxModel.id }) && textBoxModel.content.isEmpty {
                        placeholder
                    }
                    
                    if textBoxModel.id == textBoxViewModel.activeTextBox.id && isEditing {
                        editTextField
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
                                                    showEditText = true
                                                    isEditing = false
                                                }
                                            }
                                            
                                            Spacer()
                                            
                                            Image("Done")
                                                .onTapGesture {
                                                    isTextFieldFocused.wrappedValue = false
                                                    isEditing = false
                                                    if !textBoxViewModel.activeTextBox.content.isEmpty {
                                                        showToolText = true
                                                    }
                                                }
                                        }
                                    }
                                }
                            }
                    }
                    
                    displayText
                        .background(
                            GeometryReader { geo in
                                Color.clear
                                    .onAppear {
                                        if !textBoxModel.content.isEmpty {
                                            textBoxModel.textSize = geo.size
                                        } else {
                                            textBoxModel.textSize = placeholderSize
                                        }
                                    }
                                    .onChange(of: geo.size) {
                                        if !textBoxModel.content.isEmpty {
                                            textBoxModel.textSize = geo.size
                                        } else {
                                            textBoxModel.textSize = placeholderSize
                                        }
                                    }
                            }
                        )
                        .hidden()
                }
            }
        }
        .rotationEffect(textBoxModel.rotation)
        .scaleEffect(textBoxModel.scale)
        .offset(x: textBoxModel.x, y: textBoxModel.y)
        .gesture(
            TapGesture()
                .onEnded {
                    let now = Date()
                    if now.timeIntervalSince(lastTapDate) < 0.3 {
                        tapWorkItem?.cancel()
                        tapWorkItem = nil
                        isEditing = true
                        textBoxViewModel.activeTextBox = textBoxModel
                        textBoxViewModel.activeTextBoxOffset = CGPoint(x: textBoxModel.x, y: textBoxModel.y)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                            isTextFieldFocused.wrappedValue = true
                        }
                        showEditText = false
                        showToolText = false
                        showAdjustBackground = false
                    } else {
                        let workItem = DispatchWorkItem {
                            textBoxViewModel.activeTextBox = textBoxModel
                            textBoxViewModel.activeTextBoxOffset = CGPoint(x: textBoxModel.x, y: textBoxModel.y)
                            isTextFieldFocused.wrappedValue = false
                            isEditing = false
                            showToolText = !textBoxModel.content.isEmpty

                            if textBoxModel.content.isEmpty {
                                showEditText = false
                            }

                            if showAdjustBackground {
                                showAdjustBackground = false
                                if !textBoxModel.content.isEmpty {
                                    showEditText = true
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
            DragGesture(minimumDistance: 0.1)
                .onChanged { value in
                    let isDraggingAllowed =
                    textBoxViewModel.activeTextBox.id.isEmpty || textBoxViewModel.activeTextBox.id == textBoxModel.id
                    
                    guard isDraggingAllowed else { return }

                    if startDragPosition == .zero {
                        startDragPosition = CGPoint(x: textBoxModel.x, y: textBoxModel.y)
                    }

                    let newX = startDragPosition.x + value.translation.width
                    let newY = startDragPosition.y + value.translation.height

                    textBoxModel.x = newX
                    textBoxModel.y = newY

                    if let index = textBoxViewModel.textBoxes.firstIndex(where: { $0.id == textBoxModel.id }) {
                        textBoxViewModel.textBoxes[index].x = newX
                        textBoxViewModel.textBoxes[index].y = newY
                    }

                    if textBoxViewModel.activeTextBox.id == textBoxModel.id {
                        textBoxViewModel.activeTextBox.x = newX
                        textBoxViewModel.activeTextBox.y = newY
                        textBoxViewModel.activeTextBoxOffset = CGPoint(x: newX, y: newY)
                    }
                }
                .onEnded { _ in
                    startDragPosition = .zero
                }
        )
    }
}

//#Preview {
//    TextBoxView()
//}
