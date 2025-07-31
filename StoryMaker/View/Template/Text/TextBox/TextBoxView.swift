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
    @State private var internalScaledSize: CGSize = .zero
    
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
                            .frame(width: textBoxModel.textBoxSize.width, height: textBoxModel.textBoxSize.height)
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
                    
                    Text(textBoxModel.formatText)
                        .tracking(textBoxModel.letterSpacing)
                        .background(
                            GeometryReader { geo in
                                Color.clear
                                    .onAppear {
                                        textBoxModel.textBoxSize = geo.size
                                    }
                                    .onChange(of: geo.size) {
                                        textBoxModel.textBoxSize = geo.size
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
        .rotationEffect(textBoxModel.rotation)
        .scaleEffect(textBoxModel.scale)
        .offset(x: textBoxModel.x, y: textBoxModel.y)
        .overlay(
            GeometryReader { geo in
                Color.clear
                    .onAppear {
                        updateSize(geo: geo)
                    }
                    .onChange(of: geo.size) {
                        updateSize(geo: geo)
                    }
                    .onChange(of: textBoxViewModel.activeTextBox.id) {
                        updateSize(geo: geo)
                    }
            }
        )
        .background(
            GeometryReader { geo in
                Color.clear
                    .onAppear {
                        internalScaledSize = geo.size
                    }
                    .onChange(of: geo.size) {
                        internalScaledSize = geo.size
                    }
            }
        )
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
                        
                        print("2 tap: \(textBoxModel.id)")
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

                            print("1 tap: \(textBoxModel.id)")
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
    
    private func updateSize(geo: GeometryProxy) {
        textBoxModel.textBoxSize = geo.size
        if textBoxModel.id == textBoxViewModel.activeTextBox.id {
            textBoxViewModel.activeBoxSize = internalScaledSize
        }
    }
}

//#Preview {
//    TextBoxView()
//}
