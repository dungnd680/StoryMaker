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
    
    @ObservedObject var textBoxModel: TextBoxModel
    @ObservedObject var textBoxViewModel: TextBoxViewModel
    
    @Binding var showToolText: Bool
    @Binding var isEditing: Bool
    @Binding var showEditText: Bool
    @Binding var showAdjustBackground: Bool
    
    var isTextFieldFocused: FocusState<Bool>.Binding
    
    var body: some View {
        Group {
            if isExporting || (!(textBoxModel.id == textBoxViewModel.activeTextBox.id && isEditing) && !textBoxModel.content.isEmpty) {
                Text(textBoxModel.formatText)
                    .tracking(textBoxModel.letterSpacing)
            } else {
                ZStack {
                    if textBoxViewModel.textBoxes.contains(where: { $0.id == textBoxModel.id }) && textBoxModel.content.isEmpty {
                        Text("Double Tap To Edit")
                            .tracking(textBoxModel.letterSpacing)
                    }
                    
                    if textBoxModel.id == textBoxViewModel.activeTextBox.id && isEditing {
                        TextField("", text: $textBoxViewModel.activeTextBox.content, axis: .vertical)
                            .tracking(textBoxModel.letterSpacing)
                            .frame(width: textBoxModel.textSize.width, height: textBoxModel.textSize.height)
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
                    
                    Text(textBoxModel.formatText)
                        .tracking(textBoxModel.letterSpacing)
                        .id(textBoxModel.id)
                        .background(
                            GeometryReader { geo in
                                Color.clear
                                    .onAppear {
                                        textBoxModel.textSize = geo.size
                                    }
                                    .onChange(of: geo.size) {
                                        textBoxModel.textSize = geo.size
                                    }
                            }
                        )
                        .hidden()
                }
            }
        }
        .padding(48)
        .padding(textBoxModel.paddingBackgroundText)
        .font(.custom(textBoxModel.fontFamily, size: textBoxModel.sizeText))
        .lineSpacing(textBoxModel.lineHeight)
        .foregroundStyle(textBoxModel.shapeStyle)
        .opacity(textBoxModel.opacityText / 100)
        .multilineTextAlignment(textBoxModel.textAlignment)
        .shadow(
            color: Color(textBoxModel.colorShadowText).opacity(textBoxModel.opacityShadowText / 100),
            radius: textBoxModel.blurShadowText,
            x: textBoxModel.xShadowText,
            y: textBoxModel.yShadowText
        )
        .background(Color(textBoxModel.colorBackgroundText).opacity(textBoxModel.opacityBackgroundText / 100))
        .clipShape(RoundedRectangle(cornerRadius: textBoxModel.cornerBackgroundText))
        .overlay(
            GeometryReader { geo in
                Color.clear
                    .onAppear {
                        updateSizeIfNeeded(geo: geo)
                    }
                    .onChange(of: geo.size) {
                        updateSizeIfNeeded(geo: geo)
                    }
                    .onChange(of: textBoxViewModel.activeTextBox.id) {
                        updateSizeIfNeeded(geo: geo)
                    }
            }
        )
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
                        textBoxViewModel.activeTextBoxPosition = CGPoint(x: textBoxModel.x, y: textBoxModel.y)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                            isTextFieldFocused.wrappedValue = true
                        }
                        showEditText = false
                        showAdjustBackground = false
                        
                        print("2 tap: \(textBoxModel.id)")
                    } else {
                        let workItem = DispatchWorkItem {
                            textBoxViewModel.activeTextBox = textBoxModel
                            textBoxViewModel.activeTextBoxPosition = CGPoint(x: textBoxModel.x, y: textBoxModel.y)
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

                            print("1 tap: \(textBoxModel.id)")
                        }

                        tapWorkItem = workItem
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: workItem)
                    }

                    lastTapDate = now
                }
        )
        .highPriorityGesture(
            DragGesture(minimumDistance: 1)
                .onChanged { value in
                    let isDraggingAllowed =
                        textBoxViewModel.activeTextBox.isEmpty || textBoxViewModel.activeTextBox.id == textBoxModel.id
                    
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
                        textBoxViewModel.activeTextBoxPosition = CGPoint(x: newX, y: newY)
                    }
                }
                .onEnded { _ in
                    startDragPosition = .zero
                }
        )

    }
    
    private func updateSizeIfNeeded(geo: GeometryProxy) {
        let newSize = geo.size
        if textBoxModel.id == textBoxViewModel.activeTextBox.id {
            textBoxViewModel.activeBoxSize = newSize
        }
    }
}

//#Preview {
//    TextBoxView()
//}
