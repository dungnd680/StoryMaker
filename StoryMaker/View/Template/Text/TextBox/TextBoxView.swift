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
    
    @ObservedObject var textBoxModel: TextBoxModel
    @ObservedObject var textBoxViewModel: TextBoxViewModel
    
    @Binding var showToolText: Bool
    @Binding var isEditing: Bool
    @Binding var showEditText: Bool
    @Binding var showAdjustBackground: Bool
    
    var isTextFieldFocused: FocusState<Bool>.Binding
    
    var body: some View {
        ZStack {
            if textBoxModel.content.isEmpty && !isExporting {
                placeholder
                    .background(
                        GeometryReader { geo in
                            Color.clear
                                .onAppear {
                                    textBoxModel.textBoxSize = geo.size
                                    print("size placeholder on appear: \(geo.size)")
                                }
                                .onChange(of: geo.size) {
                                    textBoxModel.textBoxSize = geo.size
                                    print("size placeholder on change: \(geo.size)")
                                }
                        }
                    )
            }

            if isEditing && textBoxModel.id == textBoxViewModel.activeTextBox.id {
                editTextField
            } else {
                displayText
            }
            
            displayText
                .background(
                    GeometryReader { geo in
                        Color.clear
                            .onAppear {
                                textBoxModel.textBoxSize = geo.size
                                print("size display text on appear: \(geo.size)")
                            }
                            .onChange(of: geo.size) {
                                textBoxModel.textBoxSize = geo.size
                                print("size display text on change: \(geo.size)")
                            }
                    }
                )
                .hidden()
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
                        textBoxViewModel.borderTextBoxOffset = CGPoint(x: textBoxModel.x, y: textBoxModel.y)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                            isTextFieldFocused.wrappedValue = true
                        }
                        showEditText = false
                        showToolText = false
                        showAdjustBackground = false
                    } else {
                        let workItem = DispatchWorkItem {
                            textBoxViewModel.activeTextBox = textBoxModel
                            textBoxViewModel.borderTextBoxOffset = CGPoint(x: textBoxModel.x, y: textBoxModel.y)
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
            DragGesture()
                .onChanged { value in
                    let isDraggingAllowed = textBoxViewModel.activeTextBox.id.isEmpty // chưa text box nào active
                                            || textBoxViewModel.activeTextBox.id == textBoxModel.id // text box hiện tại đang active

                    guard isDraggingAllowed else { return }

                    if initialDragTranslation == .zero {
                        initialDragTranslation = value.translation
                        currentOffset = CGPoint(x: textBoxModel.x, y: textBoxModel.y)
                    }

                    let translation: CGSize = CGSize(
                        width: value.translation.width - initialDragTranslation.width,
                        height: value.translation.height - initialDragTranslation.height
                    )

                    textBoxModel.x = currentOffset.x + translation.width
                    textBoxModel.y = currentOffset.y + translation.height
                    textBoxViewModel.borderTextBoxOffset = CGPoint(x: textBoxModel.x, y: textBoxModel.y)
                }
                .onEnded { _ in
                    currentOffset = .zero
                    initialDragTranslation = .zero
                }
        )
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
            .frame(width: textBoxModel.textBoxSize.width, height: textBoxModel.textBoxSize.height)
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
            .focused(isTextFieldFocused)
            .submitLabel(.return)
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
}

//#Preview {
//    TextBoxView()
//}
